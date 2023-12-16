module Processing


  # Draws graphics into an offscreen buffer
  #
  # @see https://processing.org/reference/PGraphics.html
  # @see https://p5js.org/reference/p5/p5.Graphics/
  #
  class Graphics

    include Xot::Inspectable
    include GraphicsContext

    # Initialize graphics object.
    #
    # @see https://p5js.org/reference/p5/p5.Graphics/
    #
    def initialize(width, height, pixelDensity = 1)
      image = Rays::Image.new(
        width, height, Rays::RGBA, pixel_density: pixelDensity)
      init__ image, image.painter
    end

    # Start drawing.
    #
    # @see https://processing.org/reference/PGraphics_beginDraw_.html
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
    # @see https://processing.org/reference/PGraphics_endDraw_.html
    #
    def endDraw()
      pop
      endDraw__
      @painter__.__send__ :end_paint
    end

  end# Graphics


end# Processing
