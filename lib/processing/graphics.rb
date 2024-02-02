module Processing


  # Draws graphics into an offscreen buffer
  #
  class Graphics

    include Xot::Inspectable
    include GraphicsContext

    # Initialize graphics object.
    #
    def initialize(width, height, pixelDensity = 1)
      image = Rays::Image.new width, height, Rays::RGBA, pixelDensity
      init__ image, image.painter
    end

    # Start drawing.
    #
    def beginDraw(&block)
      @painter__.__send__ :begin_paint
      beginDraw__
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
      endDraw__
      @painter__.__send__ :end_paint
    end

  end# Graphics


end# Processing
