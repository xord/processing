module Processing


  # Image object.
  #
  # @see https://processing.org/reference/PImage.html
  # @see https://p5js.org/reference/#/p5.Image
  #
  class Image

    include Xot::Inspectable

    # @private
    def initialize(image)
      @image = image
      @pixels, @error = nil, false
    end

    # Gets width of image.
    #
    # @return [Numeric] width of image
    #
    # @see https://processing.org/reference/PImage_width.html
    # @see https://p5js.org/reference/#/p5.Image/width
    #
    def width()
      @image&.width || (@error ? -1 : 0)
    end

    # Gets height of image.
    #
    # @return [Numeric] height of image
    #
    # @see https://processing.org/reference/PImage_height.html
    # @see https://p5js.org/reference/#/p5.Image/height
    #
    def height()
      @image&.height || (@error ? -1 : 0)
    end

    alias w width
    alias h height

    # Returns the width and height of image.
    #
    # @return [Array<Numeric>] [width, height]
    #
    def size()
      [width, height]
    end

    # Sets the color of the pixel.
    #
    # @param x [Integer] x position of the pixel
    # @param y [Integer] y position of the pixel
    # @param c [Integer] color value
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PImage_set_.html
    # @see https://p5js.org/reference/#/p5.Image/set
    #
    def set(x, y, c)
      getInternal__.bitmap(true)[x, y] = self.class.fromColor__(c).map {|n| n / 255.0}
      nil
    end

    # Returns the color of the pixel.
    #
    # @return [Integer] color value (0xAARRGGBB)
    #
    # @see https://processing.org/reference/PImage_get_.html
    # @see https://p5js.org/reference/#/p5.Image/get
    #
    def get(x, y)
      getInternal__.bitmap[x, y]
        .map {|n| (n * 255).to_i.clamp 0, 255}
        .then {|r, g, b, a| self.class.toColor__ r, g, b, a}
    end

    # Loads all pixels to the 'pixels' array.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PImage_loadPixels_.html
    # @see https://p5js.org/reference/#/p5.Image/loadPixels
    #
    def loadPixels()
      @pixels = getInternal__.pixels
    end

    # Update the image pixels with the 'pixels' array.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PImage_updatePixels_.html
    # @see https://p5js.org/reference/#/p5.Image/updatePixels
    #
    def updatePixels()
      return unless @pixels
      getInternal__.pixels = @pixels
      @pixels = nil
    end

    # An array of all pixels.
    # Call loadPixels() before accessing the array.
    #
    # @return [Array] color array
    #
    # @see https://processing.org/reference/PImage_pixels.html
    # @see https://p5js.org/reference/#/p5.Image/pixels
    #
    attr_reader :pixels

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
    # @see https://processing.org/reference/PImage_filter_.html
    # @see https://p5js.org/reference/#/p5.Image/filter
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
    # @see https://processing.org/reference/PImage_resize_.html
    # @see https://p5js.org/reference/#/p5.Image/resize
    #
    def resize(width, height)
      @image = Rays::Image.new(width, height).paint do |painter|
        painter.image getInternal__, 0, 0, width, height
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
    # @see https://processing.org/reference/PImage_copy_.html
    # @see https://p5js.org/reference/#/p5.Image/copy
    #
    def copy(img = nil, sx, sy, sw, sh, dx, dy, dw, dh)
      blend img, sx, sy, sw, sh, dx, dy, dw, dh, :normal
    end

    # @private
    def mask__()
      raise NotImplementedError
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
    # @see https://processing.org/reference/PImage_blend_.html
    # @see https://p5js.org/reference/#/p5.Image/blend
    #
    def blend(img = nil, sx, sy, sw, sh, dx, dy, dw, dh, mode)
      img ||= self
      getInternal__.paint do |painter|
        img.drawImage__ painter, sx, sy, sw, sh, dx, dy, dw, dh, blend_mode: mode
      end
      nil
    end

    # @private
    def blendColor__()
      raise NotImplementedError
    end

    # @private
    def reset__()
      raise NotImplementedError
    end

    # @private
    def getCurrentFrame__()
      raise NotImplementedError
    end

    # @private
    def setFrame__()
      raise NotImplementedError
    end

    # @private
    def numFrames__()
      raise NotImplementedError
    end

    # @private
    def play__()
      raise NotImplementedError
    end

    # @private
    def pause__()
      raise NotImplementedError
    end

    # @private
    def delay__()
      raise NotImplementedError
    end

    # Saves image to file.
    #
    # @param filename [String] file name to save image
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PImage_save_.html
    # @see https://p5js.org/reference/#/p5.Image/save
    #
    def save(filename)
      getInternal__.save filename
      nil
    end

    # @private
    def getInternal__()
      @image or raise 'Invalid image object'
    end

    # @private
    def setInternal__(image, error = false)
      @image, @error = image, error
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
