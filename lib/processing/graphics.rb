module Processing


  # Draws graphics into an offscreen buffer
  #
  class Graphics

    include Xot::Inspectable
    include GraphicsContext

    # Initialize graphics object.
    #
    def initialize(width, height)
      image = Rays::Image.new width, height
      init__ image, image.painter
    end

    # Start drawing.
    #
    def beginDraw(&block)
      beginDraw__
      @painter__.__send__ :begin_paint
      push
      if block
        begin
          block.call self
        ensure
          endDraw
        end
      end
    end

    # End drawing.
    #
    def endDraw()
      pop
      @painter__.__send__ :end_paint
      endDraw__
    end

  end# Graphics


end# Processing
