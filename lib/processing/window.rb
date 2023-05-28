module Processing


  # @private
  class Window < Reflex::Window

    include Xot::Inspectable

    attr_accessor :setup, :update, :draw, :resize,
      :key_down, :key_up,
      :pointer_down, :pointer_up, :pointer_move, :pointer_drag,
      :move, :resize, :motion,
      :before_draw, :after_draw, :update_canvas

    attr_accessor :auto_resize

    def initialize(width = 500, height = 500, *args, **kwargs, &block)
      Processing.instance_variable_set :@window, self

      @events       = []
      @error        = nil
      @auto_resize  = true
      @canvas       = Canvas.new self
      @canvas_view  =              add   CanvasView.new name: :canvas
      @overlay_view = @canvas_view.add Reflex::View.new name: :overlay

      super(*args, size: [width, height], **kwargs, &block)
    end

    def canvas_image()
      @canvas.image
    end

    def canvas_painter()
      @canvas.painter
    end

    def window_painter()
      self.painter
    end

    def event()
      @events.last
    end

    def add_overlay(view)
      @overlay_view.add view
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

    def on_resize(e)
      on_canvas_resize e
    end

    def on_change_pixel_density(pixel_density)
      resize_canvas width, height, window_pixel_density: pixel_density
    end

    def on_draw(e)
      window_painter.pixel_density.tap do |pd|
        prev, @prev_pixel_density = @prev_pixel_density, pd
        on_change_pixel_density pd if prev && pd != prev
      end
      update_canvas_view
    end

    def on_key(e)
      block = case e.action
        when :down then @key_down
        when :up   then @key_up
      end
      draw_canvas {call_block block, e} if block
    end

    def on_move(e)
      draw_canvas {call_block @move, e} if @move
    end

    def on_resize(e)
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
        when :move        then e.drag? ? @pointer_drag : @pointer_move
      end
      draw_canvas {call_block block, e} if block
    end

    def on_canvas_resize(e)
      resize_canvas e.width, e.height if @auto_resize
      draw_canvas {call_block @resize, e} if @resize
    end

    def resize_canvas(width, height, pixel_density = nil, window_pixel_density: nil)
      @pixel_density = pixel_density if pixel_density
      if @canvas.resize width, height, pixel_density || @pixel_density || window_pixel_density
        @update_canvas.call canvas_image, canvas_painter if @update_canvas
        size width, height
      end
    end

    private

    def update_canvas_view()
      scrollx, scrolly, zoom = get_scroll_and_zoom
      @canvas_view.scroll_to scrollx, scrolly
      @canvas_view.zoom  = zoom
      @overlay_view.size = canvas_image.size
    end

    def get_scroll_and_zoom()
      ww, wh =              width.to_f,              height.to_f
      cw, ch = canvas_image.width.to_f, canvas_image.height.to_f
      return [0, 0, 1] if ww == 0 || wh == 0 || cw == 0 || ch == 0

      wratio, cratio = ww / wh, cw / ch
      if wratio >= cratio
        scaled_w = wh * cratio
        return (ww - scaled_w) / 2, 0, scaled_w / cw
      else
        scaled_h = ww / cratio
        return 0, (wh - scaled_h) / 2, ww / cw
      end
    end

    def draw_canvas(&block)
      begin_draw
      block.call
    ensure
      end_draw
    end

    def begin_draw()
      canvas_painter.__send__ :begin_paint
      @before_draw&.call
    end

    def end_draw()
      @after_draw&.call
      canvas_painter.__send__ :end_paint
    end

    def draw_screen(painter)
      window_painter.image canvas_image
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


  class Window::Canvas

    attr_reader :image, :painter

    def initialize(window)
      @image   = nil
      @painter = window.painter

      resize 1, 1
      painter.miter_limit = 10
    end

    def resize(width, height, pixel_density = nil)
      return false if width <= 0 || height <= 0

      return false if
        width         == @image&.width  &&
        height        == @image&.height &&
        pixel_density == @painter.pixel_density

      old_image   = @image
      old_painter = @painter
      cs          = old_image&.color_space || Rays::RGBA
      pd          = pixel_density || old_painter.pixel_density

      @image   = Rays::Image.new width, height, cs, pd
      @painter = @image.painter

      @painter.paint {image old_image} if old_image
      copy_painter old_painter, @painter

      GC.start
      return true
    end

    private

    def copy_painter(from, to)
      to.fill         = from.fill
      to.stroke       = from.stroke
      to.stroke_width = from.stroke_width
      to.stroke_cap   = from.stroke_cap
      to.stroke_join  = from.stroke_join
      to.miter_limit  = from.miter_limit
      to.font         = from.font
    end

  end# Window::Canvas


  class Window::CanvasView < Reflex::View

    def on_update(e)
      window.on_canvas_update e
    end

    def on_draw(e)
      window.on_canvas_draw e
    end

    def on_pointer(e)
      window.on_canvas_pointer e
    end

    def on_resize(e)
      window.on_canvas_resize e
    end

  end# Window::CanvasView


end# Processing
