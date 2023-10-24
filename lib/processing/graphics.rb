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

    # Saves image to file.
    #
    # @param filename [String] file name to save image
    #
    def save(filename)
      @image__.save filename
    end

  end# Graphics


end# Processing
