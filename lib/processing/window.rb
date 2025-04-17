module Processing


  # @private
  class Window < Reflex::Window

    include Xot::Inspectable

    def initialize(width = 500, height = 500, *args, **kwargs, &block)
      Processing.instance_variable_set :@window, self

      @events       = []
      @active       = false
      @error        = nil
      @auto_resize  = true
      @canvas       = Canvas.new self, width, height
      @canvas_view  =              add   CanvasView.new name: :canvas
      @overlay_view = @canvas_view.add Reflex::View.new name: :overlay

      super(*args, size: [width, height], **kwargs, &block)
      self.center = screen.center
    end

    attr_accessor :setup, :update, :draw, :move, :resize, :motion,
      :key_down, :key_up, :pointer_down, :pointer_up, :pointer_move, :wheel,
      :before_draw, :after_draw, :update_window, :update_canvas

    attr_accessor :auto_resize

    attr_reader :canvas

    def event()
      @events.last
    end

    def active?()
      @active
    end

    def add_overlay(view)
      @overlay_view.add view
    end

    def remove_overlay(view)
      @overlay_view.remove view
    end

    def start(&block)
      draw_canvas do
        block.call if block
        on_setup
      end
    end

    def on_setup()
      call_block @setup, nil
    end

    def on_change_pixel_density(pixel_density)
      resize_canvas(
        @canvas.width, @canvas.height,
        window_pixel_density: pixel_density)
    end

    def on_activate(e)
      @active = true
    end

    def on_deactivate(e)
      @active = false
    end

    def on_update(e)
      draw_canvas {call_block @update_window, e} if @update_window
    end

    def on_draw(e)
      painter.pixel_density.tap do |pd|
        prev, @prev_pixel_density = @prev_pixel_density, pd
        on_change_pixel_density pd if prev && pd != prev
      end
      update_canvas_view
    end

    def on_key_down(e)
      draw_canvas {call_block @key_down, e} if @key_down
    end

    def on_key_up(e)
      draw_canvas {call_block @key_up,   e} if @key_up
    end

    def on_move(e)
      draw_canvas {call_block @move, e} if @move
    end

    def on_resize(e)
      resize_canvas e.width, e.height if @auto_resize
      draw_canvas {call_block @resize, e} if @resize
    end

    def on_motion(e)
      draw_canvas {call_block @motion, e} if @motion
    end

    def on_canvas_update(e)
      call_block @update, e
      @canvas_view.redraw
    end

    def on_canvas_draw(e)
      draw_canvas {call_block @draw, e} if @draw
      draw_screen e.painter
    end

    def on_canvas_pointer(e)
      block = case e.action
        when :down        then @pointer_down
        when :up, :cancel then @pointer_up
        when :move        then @pointer_move
      end
      draw_canvas {call_block block, e} if block
    end

    def on_canvas_wheel(e)
      draw_canvas {call_block @wheel, e} if @wheel
    end

    def on_canvas_resize(e)
      resize_canvas e.width, e.height if @auto_resize
      draw_canvas {call_block @resize, e} if @resize
    end

    def resize_canvas(
      width, height,
      pixel_density       = nil,
      window_pixel_density: nil,
      antialiasing:         nil)

      painting = @canvas.painter.painting?
      @canvas.painter.__send__ :end_paint if painting

      @pixel_density = pixel_density if pixel_density

      resized =
        begin
          pd = @pixel_density || window_pixel_density
          @canvas.resize width, height, pd, antialiasing
        ensure
          @canvas.painter.__send__ :begin_paint if painting
        end

      @update_canvas&.call @canvas.image, @canvas.painter if resized
    end

    private

    def update_canvas_view()
      scrollx, scrolly, zoom = get_scroll_and_zoom
      @canvas_view.scroll_to scrollx, scrolly
      @canvas_view.zoom  = zoom
      @overlay_view.size = @canvas.image.size
    end

    def get_scroll_and_zoom()
      ww, wh =               width.to_f,               height.to_f
      cw, ch = @canvas.image.width.to_f, @canvas.image.height.to_f
      return 0, 0, 1 if ww == 0 || wh == 0 || cw == 0 || ch == 0

      wratio, cratio = ww / wh, cw / ch
      if wratio == cratio
        return 0, 0, ww / cw
      elsif wratio > cratio
        w = wh * cratio
        return (ww - w) / 2, 0, w / cw
      else
        h = ww / cratio
        return 0, (wh - h) / 2, ww / cw
      end
    end

    def draw_canvas(&block)
      drawing = self.drawing?
      begin_draw unless drawing
      block.call
    ensure
      end_draw unless drawing
    end

    def begin_draw()
      @canvas.painter.__send__ :begin_paint
      @before_draw&.call
    end

    def end_draw()
      @after_draw&.call
      @canvas.painter.__send__ :end_paint
    end

    def drawing?()
      @canvas.painter.painting?
    end

    def draw_screen(painter)
      painter.image @canvas.render
    end

    def call_block(block, event, *args)
      @events.push event
      block.call event, *args if block && !@error
    rescue Exception => e
      @error = e
      $stderr.puts e.full_message
    ensure
      @events.pop
    end

  end# Window


  # @private
  class Window::Canvas

    def initialize(window, width, height)
      @framebuffer = nil
      @paintable   = nil
      @painter     = window.painter

      @painter.miter_limit = 10

      resize width, height
    end

    attr_reader :painter

    def resize(width, height, pixel_density = nil, antialiasing = nil)
      return false if width <= 0 || height <= 0

      cs = @framebuffer&.color_space || Rays::RGBA
      pd = pixel_density || (@framebuffer || @painter).pixel_density
      aa = antialiasing == nil ? antialiasing? : (antialiasing && pd < 2)
      return false if
        width  == @framebuffer&.width  &&
        height == @framebuffer&.height &&
        pd     == @framebuffer&.pixel_density &&
        aa     == antialiasing?

      old_paintable, old_painter = @paintable, @painter

      @framebuffer = Rays::Image.new width, height, cs, pixel_density: pd
      @paintable   = aa ?
        Rays::Image.new(width, height, cs, pixel_density: pd * 2) : @framebuffer
      @painter     = @paintable.painter

      @painter.paint {image old_paintable} if old_paintable
      copy_painter old_painter, @painter

      GC.start
      return true
    end

    def render()
      @framebuffer.paint {|p| p.image @paintable} if antialiasing?
      @framebuffer
    end

    def image()
      @paintable
    end

    def width()
      @framebuffer.width
    end

    def height()
      @framebuffer.height
    end

    def pixel_density()
      @framebuffer.pixel_density
    end

    def antialiasing?()
      !!@framebuffer && !!@paintable && @framebuffer != @paintable
    end

    private

    def copy_painter(from, to)
      to.fill          = from.fill
      to.stroke        = from.stroke
      to.stroke_width  = from.stroke_width
      to.stroke_cap    = from.stroke_cap
      to.stroke_join   = from.stroke_join
      to.miter_limit   = from.miter_limit
      to.clip          = from.clip
      to.blend_mode    = from.blend_mode
      to.font          = from.font
      to.texture       = from.texture
      to.texcoord_mode = from.texcoord_mode
      to.texcoord_wrap = from.texcoord_wrap
      to.shader        = from.shader
    end

  end# Window::Canvas


  # @private
  class Window::CanvasView < Reflex::View

    def on_update(e)
      window.on_canvas_update e
      Thread.pass
    end

    def on_draw(e)
      window.on_canvas_draw e
    end

    def on_pointer(e)
      window.on_canvas_pointer e
    end

    def on_wheel(e)
      window.on_canvas_wheel e
    end

    def on_resize(e)
      window.on_canvas_resize e
    end

  end# Window::CanvasView


end# Processing
