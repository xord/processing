module RubySketch


  class Window < Reflex::Window

    attr_accessor :setup, :update, :draw, :before_draw, :after_draw, :resize,
      :pointer_down, :pointer_up, :pointer_move, :pointer_drag,
      :key, :motion

    attr_accessor :auto_resize

    attr_reader :canvas, :canvas_painter

    def initialize (width = 500, height = 500, *args, &block)
      @events      = []
      @auto_resize = true
      @error       = nil

      reset_canvas 1, 1

      super *args, size: [width, height], &block
    end

    def start (&block)
      draw_canvas do
        block.call if block
        on_setup
      end
    end

    def event ()
      @events.last
    end

    def on_setup ()
      call_block @setup, nil
    end

    def on_update (e)
      call_block @update, e
      redraw
    end

    def on_draw (e)
      draw_canvas {call_block @draw, e} if @draw
      e.painter.image @canvas
    end

    def on_key (e)
      draw_canvas {call_block @key, e} if @key
    end

    def on_pointer (e)
      block = case e.type
        when :down then @pointer_down
        when :up   then @pointer_up
        when :move then e.drag? ? @pointer_drag : @pointer_move
      end
      draw_canvas {call_block block, e} if block
    end

    def on_motion (e)
      draw_canvas {call_block @motion, e} if @motion
    end

    def on_resize (e)
      reset_canvas e.width, e.height if @auto_resize
      draw_canvas {call_block @resize, e} if @resize
    end

    private

    def reset_canvas (width, height)
      return if width * height == 0
      return if width == @canvas&.width && height == @canvas&.height

      old_canvas  = @canvas
      old_painter = @canvas_painter

      cs              = old_canvas&.color_space || Rays::RGBA
      @canvas         = Rays::Image.new width, height, cs, painter.pixel_density
      @canvas_painter = @canvas.painter

      if old_canvas
        @canvas_painter.paint {image old_canvas}
        copy_painter_attributes old_painter, @canvas_painter
      end
    end

    def copy_painter_attributes (from, to)
      to.fill         = from.fill
      to.stroke       = from.stroke
      to.stroke_width = from.stroke_width
      to.stroke_cap   = from.stroke_cap
      to.stroke_join  = from.stroke_join
      to.miter_limit  = from.miter_limit
      to.font         = from.font
    end

    def draw_canvas (&block)
      begin_draw
      block.call
    ensure
      end_draw
    end

    def begin_draw ()
      @canvas_painter.__send__ :begin_paint
      @before_draw&.call
    end

    def end_draw ()
      @after_draw&.call
      @canvas_painter.__send__ :end_paint
    end

    def call_block (block, event, *args)
      @events.push event
      block.call event, *args if block && !@error
    rescue Exception => e
      @error = e
      $stderr.puts e.full_message
    ensure
      @events.pop
    end

  end# Window


end# RubySketch
