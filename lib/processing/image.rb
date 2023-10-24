module Processing


  # Image object.
  #
  class Image

    include Xot::Inspectable

    # @private
    def initialize(image)
      @image = image
    end

    # Gets width of image.
    #
    # @return [Numeric] width of image
    #
    def width()
      @image.width
    end

    # Gets height of image.
    #
    # @return [Numeric] height of image
    #
    def height()
      @image.height
    end

    alias w width
    alias h height

    # Returns the width and height of image.
    #
    # @return [Array<Numeric>] [width, height]
    #
    def size()
      @image.size
    end

    # Sets the color of the pixel.
    #
    # @param x [Integer] x position of the pixel
    # @param y [Integer] y position of the pixel
    # @param c [Integer] color value
    #
    # @return [nil] nil
    #
    def set(x, y, c)
      @image.bitmap[x, y] = self.class.fromColor__ c
      nil
    end


    # Returns the color of the pixel.
    #
    # @return [Integer] color value (0xAARRGGBB)
    #
    def get(x, y)
      @image.bitmap[x, y]
        .map {|n| (n * 255).to_i.clamp 0, 255}
        .then {|r, g, b, a| self.class.toColor__ r, g, b, a}
    end

    # Applies an image filter.
    #
    # overload filter(shader)
    # overload filter(type)
    # overload filter(type, param)
    #
    # @param shader [Shader]  a fragment shader to apply
    # @param type   [THRESHOLD, GRAY, INVERT, BLUR] filter type
    # @param param  [Numeric] a parameter for each filter
    #
    def filter(*args)
      @filter = Shader.createFilter__(*args)
    end

    # Resizes image.
    #
    # @param width  [Numeric] width for resized image
    # @param height [Numeric] height for resized image
    #
    # @return [nil] nil
    #
    def resize(width, height)
      @image = Rays::Image.new(width, height).paint do |painter|
        painter.image @image, 0, 0, width, height
      end
      nil
    end

    # Copies image.
    #
    # @overload copy(sx, sy, sw, sh, dx, dy, dw, dh)
    # @overload copy(img, sx, sy, sw, sh, dx, dy, dw, dh)
    #
    # @param img [Image]   image for copy source
    # @param sx  [Numrtic] x position of source region
    # @param sy  [Numrtic] y position of source region
    # @param sw  [Numrtic] width of source region
    # @param sh  [Numrtic] height of source region
    # @param dx  [Numrtic] x position of destination region
    # @param dy  [Numrtic] y position of destination region
    # @param dw  [Numrtic] width of destination region
    # @param dh  [Numrtic] height of destination region
    #
    # @return [nil] nil
    #
    def copy(img = nil, sx, sy, sw, sh, dx, dy, dw, dh)
      blend img, sx, sy, sw, sh, dx, dy, dw, dh, :normal
    end

    # Blends image.
    #
    # @overload blend(sx, sy, sw, sh, dx, dy, dw, dh, mode)
    # @overload blend(img, sx, sy, sw, sh, dx, dy, dw, dh, mode)
    #
    # @param img  [Image]   image for blend source
    # @param sx   [Numeric] x position of source region
    # @param sy   [Numeric] y position of source region
    # @param sw   [Numeric] width of source region
    # @param sh   [Numeric] height of source region
    # @param dx   [Numeric] x position of destination region
    # @param dy   [Numeric] y position of destination region
    # @param dw   [Numeric] width of destination region
    # @param dh   [Numeric] height of destination region
    # @param mode [BLEND, ADD, SUBTRACT, LIGHTEST, DARKEST, EXCLUSION, MULTIPLY, SCREEN, REPLACE] blend mode
    #
    # @return [nil] nil
    #
    def blend(img = nil, sx, sy, sw, sh, dx, dy, dw, dh, mode)
      img ||= self
      @image.paint do |painter|
        img.drawImage__ painter, sx, sy, sw, sh, dx, dy, dw, dh, blend_mode: mode
      end
      nil
    end

    # Saves image to file.
    #
    # @param filename [String] file name to save image
    #
    # @return [nil] nil
    #
    def save(filename)
      @image.save filename
      nil
    end

    # @private
    def getInternal__()
      @image
    end

    # @private
    def drawImage__(painter, *args, **states)
      shader = painter.shader || @filter&.getInternal__
      painter.push shader: shader, **states do |_|
        painter.image getInternal__, *args
      end
    end

    # @private
    def self.fromColor__(color)
      [
        color >> 16 & 0xff,
        color >> 8  & 0xff,
        color       & 0xff,
        color >> 24 & 0xff
      ]
    end

    # @private
    def self.toColor__(r, g, b, a)
      (r & 0xff) << 16 |
      (g & 0xff) << 8  |
      (b & 0xff)       |
      (a & 0xff) << 24
    end

  end# Image


end# Processing
