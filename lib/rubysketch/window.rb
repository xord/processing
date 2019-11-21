module RubySketch


  class Window < Reflex::Window

    attr_accessor :setup, :update, :draw, :key, :motion, :resize,
      :pointer_down, :pointer_up, :pointer_move, :pointer_drag

    attr_accessor :auto_resize

    attr_reader :canvas

    def initialize (width = 500, height = 500, *args, &block)
      @canvas      = nil
      @events      = []
      @auto_resize = true
      @error       = nil

      super *args, size: [width, height] do |_|
        @canvas.painter.paint do |_|
          block.call if block
          on_setup
        end
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
      call_block @draw, e, @canvas.painter
      e.painter.image @canvas if @canvas
    end

    def on_key (e)
      call_block @key, e
    end

    def on_pointer (e)
      block = case e.type
        when :down then @pointer_down
        when :up   then @pointer_up
        when :move then e.drag? ? @pointer_drag : @pointer_move
      end
      call_block block, e if block
    end

    def on_motion (e)
      call_block @motion, e
    end

    def on_resize (e)
      reset_canvas e.width, e.height if @auto_resize
      call_block @resize, e
    end

    private

    def reset_canvas (width, height)
      return if width * height == 0
      return if width == @canvas&.width && height == @canvas&.height

      old     = @canvas
      pd      = @canvas&.pixel_density || painter.pixel_density
      @canvas = Rays::Image.new width, height, Rays::ColorSpace::RGBA, pd

      @canvas.paint {image old} if old
    end

    def call_block (block, event, *args)
      @events.push event
      block.call event, *args if block && !@error
    rescue => e
      @error = e
      $stderr.puts e.full_message
    ensure
      @events.pop
    end

  end# Window


end# RubySketch
