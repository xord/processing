module Processing


  # Drawing context
  #
  module GraphicsContext

    # PI
    #
    PI         = Math::PI

    # PI / 2
    #
    HALF_PI    = PI / 2

    # PI / 4
    #
    QUARTER_PI = PI / 4

    # PI * 2
    #
    TWO_PI     = PI * 2

    # PI * 2
    #
    TAU        = PI * 2

    # RGBA format for createImage().
    #
    RGBA = :rgba

    # RGB format for createImage, or RGB mode for colorMode().
    #
    RGB  = :rgb

    # HSB mode for colorMode().
    #
    HSB  = :hsb

    # Radian mode for angleMode().
    #
    RADIANS = :radians

    # Degree mode for angleMode().
    #
    DEGREES = :degrees

    # Mode for rectMode(), ellipseMode(), imageMode(), and shapeMode().
    #
    CORNER  = :corner

    # Mode for rectMode(), ellipseMode(), imageMode(), and shapeMode().
    #
    CORNERS = :corners

    # Mode for rectMode(), ellipseMode(), imageMode(), shapeMode(),
    # and textAlign().
    #
    CENTER  = :center

    # Mode for rectMode() and ellipseMode().
    #
    RADIUS  = :radius

    # Mode for strokeCap().
    #
    PROJECT = :square

    # Mode for strokeJoin().
    #
    MITER   = :miter

    # Mode for strokeCap() and strokeJoin().
    #
    ROUND   = :round

    # Mode for strokeCap() and strokeJoin().
    #
    SQUARE  = :butt

    # Mode for blendMode().
    #
    BLEND     = :normal

    # Mode for blendMode().
    #
    ADD       = :add

    # Mode for blendMode().
    #
    SUBTRACT  = :subtract

    # Mode for blendMode().
    #
    LIGHTEST  = :lightest

    # Mode for blendMode().
    #
    DARKEST   = :darkest

    # Mode for blendMode().
    #
    EXCLUSION = :exclusion

    # Mode for blendMode().
    #
    MULTIPLY  = :multiply

    # Mode for blendMode().
    #
    SCREEN    = :screen

    # Mode for blendMode().
    #
    REPLACE   = :replace

    # Key code or Mode for textAlign().
    LEFT     = :left

    # Key code or Mode for textAlign().
    RIGHT    = :right

    # Mode for textAlign().
    TOP      = :top

    # Mode for textAlign().
    BOTTOM   = :bottom

    # Mode for textAlign().
    BASELINE = :baseline

    # Mode for textureMode().
    IMAGE  = :image

    # Mode for textureMode().
    NORMAL = :normal

    # Mode for textureWrap().
    CLAMP  = :clamp

    # Mode for textureWrap().
    REPEAT = :repeat

    # Filter type for filter()
    THRESHOLD = :threshold

    # Filter type for filter()
    GRAY      = :gray

    # Filter type for filter()
    INVERT    = :invert

    # Filter type for filter()
    BLUR      = :blur

    # Shape mode for createShape()
    LINE     = :line

    # Shape mode for createShape()
    RECT     = :rect

    # Shape mode for createShape()
    ELLIPSE  = :ellipse

    # Shape mode for createShape()
    ARC      = :arc

    # Shape mode for createShape()
    TRIANGLE = :triangle

    # Shape mode for createShape()
    QUAD     = :quad

    # Shape mode for createShape()
    GROUP    = :group

    # Shape mode for beginShape()
    POINTS         = :points

    # Shape mode for beginShape()
    LINES          = :lines

    # Shape mode for beginShape()
    TRIANGLES      = :triangles

    # Shape mode for beginShape()
    TRIANGLE_FAN   = :triangle_fan

    # Shape mode for beginShape()
    TRIANGLE_STRIP = :triangle_strip

    # Shape mode for beginShape()
    QUADS          = :quads

    # Shape mode for beginShape()
    QUAD_STRIP     = :quad_strip

    # Shape mode for beginShape()
    TESS           = :tess

    # OPEN flag for endShape()
    OPEN           = :open

    # CLOSE flag for endShape()
    CLOSE          = :close

    # Key codes.
    ENTER     = :enter
    SPACE     = :space
    TAB       = :tab
    DELETE    = :delete
    BACKSPACE = :backspace
    ESC       = :escape
    HOME      = :home
    #END       = :end
    PAGEUP    = :pageup
    PAGEDOWN  = :pagedown
    CLEAR     = :clear
    SHIFT     = :shift
    CONTROL   = :control
    ALT       = :alt
    WIN       = :win
    COMMAND   = :command
    OPTION    = :option
    FUNCTION  = :function
    CAPSLOCK  = :capslock
    SECTION   = :section
    HELP      = :help
    F1        = :f1
    F2        = :f2
    F3        = :f3
    F4        = :f4
    F5        = :f5
    F6        = :f6
    F7        = :f7
    F8        = :f8
    F9        = :f9
    F10       = :f10
    F11       = :f11
    F12       = :f12
    F13       = :f13
    F14       = :f14
    F15       = :f15
    F16       = :f16
    F17       = :f17
    F18       = :f18
    F19       = :f19
    F20       = :f20
    F21       = :f21
    F22       = :f22
    F23       = :f23
    F24       = :f24
    UP        = :up
    DOWN      = :down

    # @private
    DEG2RAD__ = Math::PI / 180.0

    # @private
    RAD2DEG__ = 180.0 / Math::PI

    # @private
    FONT_SIZE_DEFAULT__ = 12

    # @private
    FONT_SIZE_MAX__     = 256

    # @private
    def init__(image, painter)
      @drawing__        = false
      @colorMode__      = nil
      @hsbColor__       = false
      @colorMaxes__     = [1.0] * 4
      @angleMode__      = nil
      @angleScale__     = 1.0
      @rectMode__       = nil
      @ellipseMode__    = nil
      @imageMode__      = nil
      @shapeMode__      = nil
      @blendMode__      = nil
      @curveDetail__    = nil
      @curveTightness__ = nil
      @bezierDetail__   = nil
      @textAlignH__     = nil
      @textAlignV__     = nil
      @textFont__       = nil
      @tint__           = nil
      @filter__         = nil
      @pixels__         = nil
      @random__         = nil
      @noiseSeed__      = nil
      @noiseOctaves__   = nil
      @noiseFallOff__   = nil
      @matrixStack__    = []
      @styleStack__     = []

      updateCanvas__ image, painter

      colorMode   RGB, 255
      angleMode   RADIANS
      rectMode    CORNER
      ellipseMode CENTER
      imageMode   CORNER
      shapeMode   CORNER
      blendMode   BLEND
      strokeCap   ROUND
      strokeJoin  MITER
      textAlign   LEFT
      textFont    createFont(nil, nil)
      textureMode IMAGE
      textureWrap CLAMP

      fill           255
      stroke         0
      strokeWeight   1
      noTint
      curveDetail    20
      curveTightness 0
      bezierDetail   20
      randomSeed     Random.new_seed
      noiseSeed      Random.new_seed
      noiseDetail    4, 0.5
    end

    # @private
    def updateCanvas__(image, painter)
      @image__, @painter__     = image, painter
      @painter__.miter_limit   = 10
      @painter__.stroke_outset = 0.5
    end

    # @private
    def beginDraw__()
      raise "call beginDraw() before drawing" if @drawing__
      @matrixStack__.clear
      @styleStack__.clear
      @drawing__ = true
    end

    # @private
    def endDraw__()
      raise unless @drawing__
      @drawing__ = false
    end

    # Returns the width of the graphics object.
    #
    # @return [Numeric] width
    #
    def width()
      getInternal__.width
    end

    # Returns the height of the graphics object.
    #
    # @return [Numeric] height
    #
    def height()
      getInternal__.height
    end

    # Returns the width of the graphics object in pixels.
    #
    # @return [Numeric] width
    #
    def pixelWidth()
      width * pixelDensity
    end

    # Returns the height of the graphics object in pixels.
    #
    # @return [Numeric] height
    #
    def pixelHeight()
      height * pixelDensity
    end

    # Returns the pixel density of the graphics object.
    #
    # @return [Numeric] pixel density
    #
    def pixelDensity()
      @painter__.pixel_density
    end

    # Sets color mode and max color values.
    #
    # @overload colorMode(mode)
    # @overload colorMode(mode, max)
    # @overload colorMode(mode, max1, max2, max3)
    # @overload colorMode(mode, max1, max2, max3, maxA)
    #
    # @param mode [RGB, HSB] RGB or HSB
    # @param max  [Numeric]  max values for all color values
    # @param max1 [Numeric]  max value for red or hue
    # @param max2 [Numeric]  max value for green or saturation
    # @param max3 [Numeric]  max value for blue or brightness
    # @param maxA [Numeric]  max value for alpha
    #
    # @return [RGB, HSB] current mode
    #
    def colorMode(mode = nil, *maxes)
      if mode != nil
        mode = mode.downcase.to_sym
        raise ArgumentError, "invalid color mode: #{mode}" unless [RGB, HSB].include?(mode)
        raise ArgumentError unless [0, 1, 3, 4].include?(maxes.size)

        @colorMode__ = mode
        @hsbColor__  = mode == HSB
        case maxes.size
        when 1    then @colorMaxes__                 = [maxes.first.to_f] * 4
        when 3, 4 then @colorMaxes__[0...maxes.size] = maxes.map &:to_f
        end
      end
      @colorMode__
    end

    # Creates color value.
    #
    # @overload color(gray)
    # @overload color(gray, alpha)
    # @overload color(v1, v2, v3)
    # @overload color(v1, v2, v3, alpha)
    #
    # @param gray  [Numeric] the value for gray
    # @param alpha [Numeric] the value for alpha
    # @param v1    [Numeric] the value for red or hue
    # @param v2    [Numeric] the value for green or saturation
    # @param v3    [Numeric] the value for blue or brightness
    #
    # @return [Integer] the rgba color value
    #
    def color(*args)
      toRGBA__(*args)
        .map {|n| (n * 255).to_i.clamp 0, 255}
        .then {|r, g, b, a| Image.toColor__ r, g, b, a}
    end

    # Returns the red value of the color.
    #
    # @param color [Numeric] color value
    #
    # @return [Numeric] the red value
    #
    def red(color)
      ((color >> 16) & 0xff) / 255.0 * @colorMaxes__[0]
    end

    # Returns the green value of the color.
    #
    # @param color [Numeric] color value
    #
    # @return [Numeric] the green value
    #
    def green(color)
      ((color >> 8) & 0xff) / 255.0 * @colorMaxes__[1]
    end

    # Returns the blue value of the color.
    #
    # @param color [Numeric] color value
    #
    # @return [Numeric] the blue value
    #
    def blue(color)
      (color & 0xff) / 255.0 * @colorMaxes__[2]
    end

    # Returns the red value of the color.
    #
    # @param color [Numeric] color value
    #
    # @return [Numeric] the red value
    #
    def alpha(color)
      ((color >> 24) & 0xff) / 255.0 * @colorMaxes__[3]
    end

    # @private
    private def toRGBA__(*args)
      a, b = args
      return parseColor__(a, b || alphaMax__) if a.kind_of?(String)
      toRaysColor__(*args).to_a
    end

    # @private
    def toRaysColor__(*args)
      a, b, c, d = args
      rgba = case args.size
        when 1, 2 then [a, a, a, b || alphaMax__]
        when 3, 4 then [a, b, c, d || alphaMax__]
        else raise ArgumentError
        end
      rgba = rgba.map.with_index {|value, i| value / @colorMaxes__[i]}
      @hsbColor__ ? Rays::Color.hsv(*rgba) : Rays::Color.new(*rgba)
    end

    # @private
    private def parseColor__(str, alpha)
      result = str.match(/^\s*##{'([0-9a-f]{2})' * 3}\s*$/i)
      raise ArgumentError, "invalid color code: '#{str}'" unless result

      rgb = result[1..3].map.with_index {|hex, i| hex.to_i(16) / 255.0}
      return *rgb, (alpha / alphaMax__)
    end

    # @private
    private def alphaMax__()
      @colorMaxes__[3]
    end

    # Sets angle mode.
    #
    # @param mode [RADIANS, DEGREES] RADIANS or DEGREES
    #
    # @return [RADIANS, DEGREES] current mode
    #
    def angleMode(mode = nil)
      if mode != nil
        @angleMode__  = mode
        @angleScale__ =
          case mode.downcase.to_sym
          when RADIANS then RAD2DEG__
          when DEGREES then 1.0
          else raise ArgumentError, "invalid angle mode: #{mode}"
          end
      end
      @angleMode__
    end

    # @private
    def toDegrees__(angle)
      angle * @angleScale__
    end

    # @private
    def fromRadians__(radians)
      case @angleMode__
      when RADIANS then radians
      when DEGREES then radians * RAD2DEG__
      else raise "invalid angle mode: #{mode}"
      end
    end

    # @private
    def fromDegrees__(degrees)
      case @angleMode__
      when RADIANS then degrees * DEG2RAD__
      when DEGREES then degrees
      else raise "invalid angle mode: #{mode}"
      end
    end

    # Sets rect mode. Default is CORNER.
    #
    # CORNER  -> rect(left, top, width, height)
    # CORNERS -> rect(left, top, right, bottom)
    # CENTER  -> rect(centerX, centerY, width, height)
    # RADIUS  -> rect(centerX, centerY, radiusH, radiusV)
    #
    # @param mode [CORNER, CORNERS, CENTER, RADIUS]
    #
    # @return [nil] nil
    #
    def rectMode(mode)
      @rectMode__ = mode
    end

    # Sets ellipse mode. Default is CENTER.
    #
    # CORNER  -> ellipse(left, top, width, height)
    # CORNERS -> ellipse(left, top, right, bottom)
    # CENTER  -> ellipse(centerX, centerY, width, height)
    # RADIUS  -> ellipse(centerX, centerY, radiusH, radiusV)
    #
    # @param mode [CORNER, CORNERS, CENTER, RADIUS]
    #
    # @return [nil] nil
    #
    def ellipseMode(mode)
      @ellipseMode__ = mode
    end

    # Sets image mode. Default is CORNER.
    #
    # CORNER  -> image(img, left, top, width, height)
    # CORNERS -> image(img, left, top, right, bottom)
    # CENTER  -> image(img, centerX, centerY, width, height)
    #
    # @param mode [CORNER, CORNERS, CENTER]
    #
    # @return [nil] nil
    #
    def imageMode(mode)
      @imageMode__ = mode
    end

    # Sets shape mode. Default is CORNER.
    #
    # CORNER  -> shape(shp, left, top, width, height)
    # CORNERS -> shape(shp, left, top, right, bottom)
    # CENTER  -> shape(shp, centerX, centerY, width, height)
    #
    # @param mode [CORNER, CORNERS, CENTER]
    #
    # @return [nil] nil
    #
    def shapeMode(mode)
      @shapeMode__ = mode
    end

    # @private
    private def toXYWH__(mode, a, b, c, d)
      case mode
      when CORNER  then [a,           b,           c,     d]
      when CORNERS then [a,           b,           c - a, d - b]
      when CENTER  then [a - c / 2.0, b - d / 2.0, c,     d]
      when RADIUS  then [a - c,       b - d,       c * 2, d * 2]
      else raise ArgumentError # ToDo: refine error message
      end
    end

    # Sets blend mode. Default is BLEND.
    #
    # @param mode [BLEND, ADD, SUBTRACT, LIGHTEST, DARKEST, EXCLUSION, MULTIPLY, SCREEN, REPLACE]
    #
    # @return [nil] nil
    #
    def blendMode(mode = nil)
      if mode != nil
        @blendMode__          = mode
        @painter__.blend_mode = mode
      end
      @blendMode__
    end

    # Sets fill color.
    #
    # @overload fill(rgb)
    # @overload fill(rgb, alpha)
    # @overload fill(gray)
    # @overload fill(gray, alpha)
    # @overload fill(r, g, b)
    # @overload fill(r, g, b, alpha)
    #
    # @param rgb   [String]  color code like '#00AAFF'
    # @param gray  [Integer]  gray value (0..255)
    # @param r     [Integer]   red value (0..255)
    # @param g     [Integer] green value (0..255)
    # @param b     [Integer]  blue value (0..255)
    # @param alpha [Integer] alpha value (0..255)
    #
    # @return [nil] nil
    #
    def fill(*args)
      @painter__.fill(*toRGBA__(*args))
      nil
    end

    # @private
    def getFill__()
      @painter__.fill
    end

    # Disables filling.
    #
    # @return [nil] nil
    #
    def noFill()
      @painter__.fill nil
      nil
    end

    # Sets stroke color.
    #
    # @overload stroke(rgb)
    # @overload stroke(rgb, alpha)
    # @overload stroke(gray)
    # @overload stroke(gray, alpha)
    # @overload stroke(r, g, b)
    # @overload stroke(r, g, b, alpha)
    #
    # @param rgb   [String]  color code like '#00AAFF'
    # @param gray  [Integer]  gray value (0..255)
    # @param r     [Integer]   red value (0..255)
    # @param g     [Integer] green value (0..255)
    # @param b     [Integer]  blue value (0..255)
    # @param alpha [Integer] alpha value (0..255)
    #
    # @return [nil] nil
    #
    def stroke(*args)
      @painter__.stroke(*toRGBA__(*args))
      nil
    end

    # Disables drawing stroke.
    #
    # @return [nil] nil
    #
    def noStroke()
      @painter__.stroke nil
      nil
    end

    # Sets stroke weight.
    #
    # @param weight [Numeric] width of stroke
    #
    # @return [nil] nil
    #
    def strokeWeight(weight)
      @painter__.stroke_width weight
      nil
    end

    # Sets stroke cap mode.
    #
    # @param cap [BUTT, ROUND, SQUARE]
    #
    # @return [nil] nil
    #
    def strokeCap(cap)
      @painter__.stroke_cap cap
      nil
    end

    # Sets stroke join mode.
    #
    # @param join [MITER, ROUND, SQUARE]
    #
    # @return [nil] nil
    #
    def strokeJoin(join)
      @painter__.stroke_join join
      nil
    end

    # Sets the resolution at which curves display.
    # The default value is 20 while the minimum value is 3.
    #
    # @param detail [Numeric] resolution of the curves
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/curveDetail_.html
    # @see https://p5js.org/reference/#/p5/curveDetail
    #
    def curveDetail(detail)
      detail = 3 if detail < 3
      @curveDetail__ = detail
      nil
    end

    # Sets the quality of curve forms.
    #
    # @param tightness [Numeric] determines how the curve fits to the vertex points
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/curveTightness_.html
    # @see https://p5js.org/reference/#/p5/curveTightness
    #
    def curveTightness(tightness)
      @curveTightness__ = tightness
      nil
    end

    # Sets the resolution at which Bezier's curve is displayed.
    # The default value is 20.
    #
    # @param detail [Numeric] resolution of the curves
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/bezierDetail_.html
    # @see https://p5js.org/reference/#/p5/bezierDetail
    #
    def bezierDetail(detail)
      detail = 1 if detail < 1
      @bezierDetail__ = detail
      nil
    end

    # Sets fill color for drawing images.
    #
    # @overload tint(rgb)
    # @overload tint(rgb, alpha)
    # @overload tint(gray)
    # @overload tint(gray, alpha)
    # @overload tint(r, g, b)
    # @overload tint(r, g, b, alpha)
    #
    # @param rgb   [String]  color code like '#00AAFF'
    # @param gray  [Integer]  gray value (0..255)
    # @param r     [Integer]   red value (0..255)
    # @param g     [Integer] green value (0..255)
    # @param b     [Integer]  blue value (0..255)
    # @param alpha [Integer] alpha value (0..255)
    #
    # @return [nil] nil
    #
    def tint(*args)
      @tint__ = args
      nil
    end

    # Resets tint color.
    #
    # @return [nil] nil
    #
    def noTint()
      @tint__ = nil
    end

    # @private
    def getTint__()
      @tint__ ? toRGBA__(*@tint__) : 1
    end

    # Limits the drawable rectangle.
    #
    # The parameters a, b, c, and d are determined by rectMode().
    #
    # @param a [Numeric] horizontal position of the drawable area, by default
    # @param b [Numeric] vertical position of the drawable area, by default
    # @param c [Numeric] width of the drawable area, by default
    # @param d [Numeric] height of the drawable area, by default
    #
    # @return [nil] nil
    #
    def clip(a, b, c, d)
      x, y, w, h = toXYWH__ @imageMode__, a, b, c, d
      @painter__.clip x, y, w, h
      nil
    end

    # Disables clipping.
    #
    # @return [nil] nil
    #
    def noClip()
      @painter__.no_clip
      nil
    end

    # Sets text font.
    #
    # (Passing a font name as the first parameter is deprecated)
    #
    # @overload textFont(font)
    # @overload textFont(name)
    # @overload textFont(font, size)
    # @overload textFont(name, size)
    #
    # @param font [Font]    font
    # @param name [String]  font name
    # @param size [Numeric] font size (max 256)
    #
    # @return [nil] nil
    #
    def textFont(font, size = nil)
      size = FONT_SIZE_MAX__ if size && size > FONT_SIZE_MAX__
      if font.nil? || font.kind_of?(String)
        font = createFont font, size
      elsif size
        font.setSize__ size
      end
      @textFont__     = font
      @painter__.font = font.getInternal__
      nil
    end

    # Sets text size.
    #
    # @param size [Numeric] font size (max 256)
    #
    # @return [nil] nil
    #
    def textSize(size)
      textFont @textFont__, size
    end

    def textWidth(str)
      @painter__.font.width str
    end

    def textAscent()
      @painter__.font.ascent
    end

    def textDescent()
      @painter__.font.descent
    end

    def textAlign(horizontal, vertical = BASELINE)
      @textAlignH__ = horizontal
      @textAlignV__ = vertical
    end

    def texture(image)
      @painter__.texture image&.getInternal__
      nil
    end

    # @private
    def drawWithTexture__(&block)
      if @painter__.texture
        @painter__.push fill: getTint__, &block
      else
        block.call
      end
    end

    # Sets the coordinate space for texture mapping.
    #
    # @param mode [IMAGE, NORMAL] image coordinate, or normalized coordinate
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/textureMode_.html
    # @see https://p5js.org/reference/#/p5/textureMode
    #
    def textureMode(mode)
      @painter__.texcoord_mode = mode
      nil
    end

    # Sets the texture wrapping mode.
    #
    # @param wrap [CLAMP, REPEAT] how texutres behave when go outside of the range
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/textureWrap_.html
    # @see https://p5js.org/reference/#/p5/textureWrap
    #
    def textureWrap(wrap)
      @painter__.texcoord_wrap = wrap
      nil
    end

    # Sets shader.
    #
    # @param shader [Shader] a shader to apply
    #
    # @return [nil] nil
    #
    def shader(shader)
      @painter__.shader shader&.getInternal__
      nil
    end

    # Resets shader.
    #
    # @return [nil] nil
    #
    def resetShader()
      @painter__.no_shader
      nil
    end

    # Applies an image filter to screen.
    #
    # overload filter(shader)
    # overload filter(type)
    # overload filter(type, param)
    #
    # @param shader [Shader]  a shader to apply
    # @param type   [THRESHOLD, GRAY, INVERT, BLUR] filter type
    # @param param  [Numeric] a parameter for each filter
    #
    def filter(*args)
      @filter__ = Shader.createFilter__(*args)
    end

    # Clears screen.
    #
    # @overload background(str)
    # @overload background(str, alpha)
    # @overload background(gray)
    # @overload background(gray, alpha)
    # @overload background(r, g, b)
    # @overload background(r, g, b, alpha)
    #
    # @param str   [String]  color code like '#00AAFF'
    # @param gray  [Integer]  gray value (0..255)
    # @param r     [Integer]   red value (0..255)
    # @param g     [Integer] green value (0..255)
    # @param b     [Integer]  blue value (0..255)
    # @param alpha [Integer] alpha value (0..255)
    #
    # @return [nil] nil
    #
    def background(*args)
      assertDrawing__
      rgba = toRGBA__(*args)
      if rgba[3] == 1
        @painter__.background(*rgba)
      else
        @painter__.push fill: rgba, stroke: :none do |_|
          @painter__.rect 0, 0, width, height
        end
      end
      nil
    end

    def clear()
      assertDrawing__
      @painter__.background 0, 0
      nil
    end

    # Draws a point.
    #
    # @param x [Numeric] horizontal position
    # @param y [Numeric] vertical position
    #
    # @return [nil] nil
    #
    def point(x, y)
      assertDrawing__
      @painter__.point x, y
      nil
    end

    alias drawPoint point

    # Draws a line.
    #
    # @param x1 [Numeric] horizontal position of first point
    # @param y1 [Numeric] vertical position of first point
    # @param x2 [Numeric] horizontal position of second point
    # @param y2 [Numeric] vertical position of second point
    #
    # @return [nil] nil
    #
    def line(x1, y1, x2, y2)
      assertDrawing__
      @painter__.line x1, y1, x2, y2
      nil
    end

    alias drawLine line

    # Draws a rectangle.
    #
    # The parameters a, b, c, and d are determined by rectMode().
    #
    # @overload rect(a, b, c, d)
    # @overload rect(a, b, c, d, r)
    # @overload rect(a, b, c, d, tl, tr, br, bl)
    #
    # @param a  [Numeric] horizontal position of the shape, by default
    # @param b  [Numeric] vertical position of the shape, by default
    # @param c  [Numeric] width of the shape, by default
    # @param d  [Numeric] height of the shape, by default
    # @param r  [Numeric] radius for all corners
    # @param tl [Numeric] radius for top-left corner
    # @param tr [Numeric] radius for top-right corner
    # @param br [Numeric] radius for bottom-right corner
    # @param bl [Numeric] radius for bottom-left corner
    #
    # @return [nil] nil
    #
    def rect(a, b, c, d, *args)
      assertDrawing__
      x, y, w, h = toXYWH__ @rectMode__, a, b, c, d
      case args.size
      when 0 then @painter__.rect x, y, w, h
      when 1 then @painter__.rect x, y, w, h, round: args[0]
      when 4 then @painter__.rect x, y, w, h, lt: args[0], rt: args[1], rb: args[2], lb: args[3]
      else raise ArgumentError # ToDo: refine error message
      end
      nil
    end

    alias drawRect rect

    # Draws an ellipse.
    #
    # The parameters a, b, c, and d are determined by ellipseMode().
    #
    # @param a [Numeric] horizontal position of the shape, by default
    # @param b [Numeric] vertical position of the shape, by default
    # @param c [Numeric] width of the shape, by default
    # @param d [Numeric] height of the shape, by default
    #
    # @return [nil] nil
    #
    def ellipse(a, b, c, d)
      assertDrawing__
      x, y, w, h = toXYWH__ @ellipseMode__, a, b, c, d
      @painter__.ellipse x, y, w, h
      nil
    end

    alias drawEllipse ellipse

    # Draws a circle.
    #
    # @param x      [Numeric] horizontal position of the shape
    # @param y      [Numeric] vertical position of the shape
    # @param extent [Numeric] width and height of the shape
    #
    # @return [nil] nil
    #
    def circle(x, y, extent)
      ellipse x, y, extent, extent
    end

    alias drawCircle circle

    # Draws an arc.
    #
    # The parameters a, b, c, and d are determined by ellipseMode().
    #
    # @param a     [Numeric] horizontal position of the shape, by default
    # @param b     [Numeric] vertical position of the shape, by default
    # @param c     [Numeric] width of the shape, by default
    # @param d     [Numeric] height of the shape, by default
    # @param start [Numeric] angle to start the arc
    # @param stop  [Numeric] angle to stop the arc
    #
    # @return [nil] nil
    #
    def arc(a, b, c, d, start, stop)
      assertDrawing__
      x, y, w, h = toXYWH__ @ellipseMode__, a, b, c, d
      from, to   = toDegrees__(-start), toDegrees__(-stop)
      @painter__.ellipse x, y, w, h, from: from, to: to
      nil
    end

    alias drawArc arc

    # Draws a square.
    #
    # @param x      [Numeric] horizontal position of the shape
    # @param y      [Numeric] vertical position of the shape
    # @param extent [Numeric] width and height of the shape
    #
    # @return [nil] nil
    #
    def square(x, y, extent)
      rect x, y, extent, extent
    end

    alias drawSquare square

    # Draws a triangle.
    #
    # @param x1 [Numeric] horizontal position of first point
    # @param y1 [Numeric] vertical position of first point
    # @param x2 [Numeric] horizontal position of second point
    # @param y2 [Numeric] vertical position of second point
    # @param x3 [Numeric] horizontal position of third point
    # @param y3 [Numeric] vertical position of third point
    #
    # @return [nil] nil
    #
    def triangle(x1, y1, x2, y2, x3, y3)
      assertDrawing__
      @painter__.line x1, y1, x2, y2, x3, y3, loop: true
      nil
    end

    alias drawTriangle triangle

    # Draws a quad.
    #
    # @param x1 [Numeric] horizontal position of first point
    # @param y1 [Numeric] vertical position of first point
    # @param x2 [Numeric] horizontal position of second point
    # @param y2 [Numeric] vertical position of second point
    # @param x3 [Numeric] horizontal position of third point
    # @param y3 [Numeric] vertical position of third point
    # @param x4 [Numeric] horizontal position of fourth point
    # @param y4 [Numeric] vertical position of fourth point
    #
    # @return [nil] nil
    #
    def quad(x1, y1, x2, y2, x3, y3, x4, y4)
      assertDrawing__
      @painter__.line x1, y1, x2, y2, x3, y3, x4, y4, loop: true
      nil
    end

    alias drawQuad quad

    # Draws a Catmull-Rom spline curve.
    #
    # @param cx1 [Numeric] horizontal position of beginning control point
    # @param cy1 [Numeric] vertical position of beginning control point
    # @param x1  [Numeric] horizontal position of first point
    # @param y1  [Numeric] vertical position of first point
    # @param x2  [Numeric] horizontal position of second point
    # @param y2  [Numeric] vertical position of second point
    # @param cx2 [Numeric] horizontal position of ending control point
    # @param cy2 [Numeric] vertical position of ending control point
    #
    # @return [nil] nil
    #
    def curve(cx1, cy1, x1, y1, x2, y2, cx2, cy2)
      assertDrawing__
      @painter__.nsegment = @curveDetail__
      @painter__.curve cx1, cy1, x1, y1, x2, y2, cx2, cy2
      @painter__.nsegment = 0
      nil
    end

    alias drawCurve curve

    # Draws a Bezier spline curve.
    #
    # @param x1  [Numeric] horizontal position of first point
    # @param y1  [Numeric] vertical position of first point
    # @param cx1 [Numeric] horizontal position of first control point
    # @param cy1 [Numeric] vertical position of first control point
    # @param cx2 [Numeric] horizontal position of second control point
    # @param cy2 [Numeric] vertical position of second control point
    # @param x2  [Numeric] horizontal position of second point
    # @param y2  [Numeric] vertical position of second point
    #
    # @return [nil] nil
    #
    def bezier(x1, y1, cx1, cy1, cx2, cy2, x2, y2)
      assertDrawing__
      @painter__.nsegment = @bezierDetail__
      @painter__.bezier x1, y1, cx1, cy1, cx2, cy2, x2, y2
      @painter__.nsegment = 0
      nil
    end

    alias drawBezier bezier

    # Draws a text.
    #
    # The parameters a, b, c, and d are determined by rectMode().
    #
    # @overload text(str)
    # @overload text(str, x, y)
    # @overload text(str, a, b, c, d)
    #
    # @param str [String]  text to draw
    # @param x   [Numeric] horizontal position of the text
    # @param y   [Numeric] vertical position of the text
    # @param a   [Numeric] horizontal position of the text, by default
    # @param b   [Numeric] vertical position of the text, by default
    # @param c   [Numeric] width of the text, by default
    # @param d   [Numeric] height of the text, by default
    #
    # @return [nil] nil
    #
    def text(str, x, y, x2 = nil, y2 = nil)
      assertDrawing__
      if x2
        raise ArgumentError, "missing y2 parameter" unless y2
        x, y, w, h = toXYWH__ @rectMode__, x, y, x2, y2
        case @textAlignH__
        when RIGHT  then x +=  w - @painter__.font.width(str)
        when CENTER then x += (w - @painter__.font.width(str)) / 2
        end
        case @textAlignV__
        when BOTTOM then y +=  h - @painter__.font.height
        when CENTER then y += (h - @painter__.font.height) / 2
        else
        end
      else
        y -= @painter__.font.ascent
      end
      @painter__.text str, x, y
      nil
    end

    alias drawText text

    # Draws an image.
    #
    # The parameters a, b, c, and d are determined by imageMode().
    #
    # @overload image(img, a, b)
    # @overload image(img, a, b, c, d)
    #
    # @param img [Image] image to draw
    # @param a   [Numeric] horizontal position of the image, by default
    # @param b   [Numeric] vertical position of the image, by default
    # @param c   [Numeric] width of the image, by default
    # @param d   [Numeric] height of the image, by default
    #
    # @return [nil] nil
    #
    def image(img, a, b, c = nil, d = nil)
      assertDrawing__
      x, y, w, h = toXYWH__ @imageMode__, a, b, c || img.width, d || img.height
      img.drawImage__ @painter__, x, y, w, h, fill: getTint__, stroke: :none
      nil
    end

    alias drawImage image

    # Draws a shape.
    #
    # The parameters a, b, c, and d are determined by shapeMode().
    #
    # @overload shape(img, a, b)
    # @overload shape(img, a, b, c, d)
    #
    # @param shp [Shape] shape to draw
    # @param a   [Numeric] horizontal position of the shape, by default
    # @param b   [Numeric] vertical position of the shape, by default
    # @param c   [Numeric] width of the shape, by default
    # @param d   [Numeric] height of the shape, by default
    #
    # @return [nil] nil
    #
    def shape(shp, a = 0, b = 0, c = nil, d = nil)
      assertDrawing__
      return nil unless shp.isVisible

      drawWithTexture__ do |_|
        if c || d || @shapeMode__ != CORNER
          x, y, w, h = toXYWH__ @shapeMode__, a, b, c || shp.width, d || shp.height
          shp.draw__ @painter__, x, y, w, h
        else
          shp.draw__ @painter__, a, b
        end
      end
      nil
    end

    alias drawShape shape

    # Begins drawing complex shapes.
    #
    # @param type [POINTS, LINES, TRIANGLES, TRIANGLE_FAN, TRIANGLE_STRIP, QUADS, QUAD_STRIP, TESS]
    #
    # @return [nil] nil
    #
    # @example
    #  # Draws polygon
    #  beginShape
    #  vertex 10, 10
    #  vertex 10, 50
    #  vertex 50, 50
    #  vertex 90, 10
    #  endShape CLOSE
    #
    #  # Draws triangles
    #  beginShape TRIANGLES
    #  vertex 10, 10
    #  vertex 10, 50
    #  vertex 50, 50
    #  endShape
    #
    # @see https://processing.org/reference/beginShape_.html
    #
    def beginShape(type = nil)
      raise "beginShape() cannot be called twice" if @drawingShape__
      @drawingShape__ = createShape
      @drawingShape__.beginShape type
    end

    # Ends drawing complex shapes.
    #
    # @overload endShape()
    # @overload endShape(CLOSE)
    #
    # @param mode [CLOSE] Use CLOSE to create looped polygon
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/endShape_.html
    #
    def endShape(mode = nil)
      s = @drawingShape__ or raise "endShape() must be called after beginShape()"
      s.endShape mode
      shape s
      @drawingShape__ = nil
      nil
    end

    # Begins drawing a hole inside shape.
    #
    # @return [nil] nil
    #
    # @example
    #  beginShape
    #  vertex 10, 10
    #  vertex 10, 50
    #  vertex 50, 50
    #  vertex 90, 10
    #  beginContour
    #  vertex 20, 20
    #  vertex 30, 20
    #  vertex 30, 30
    #  vertex 20, 30
    #  endContour
    #  endShape CLOSE
    #
    # @see https://processing.org/reference/beginContour_.html
    # @see https://p5js.org/reference/#/p5/beginContour
    #
    def beginContour()
      (@drawingShape__ or raise "beginContour() must be called after beginShape()")
        .beginContour
    end

    # Ends drawing a hole.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/endContour_.html
    # @see https://p5js.org/reference/#/p5/endContour
    #
    def endContour()
      (@drawingShape__ or raise "endContour() must be called after beginShape()")
        .endContour
    end

    # Append vertex for shape polygon.
    #
    # @overload vertex(x, y)
    # @overload vertex(x, y, u, v)
    #
    # @param x [Numeric] x position of vertex
    # @param y [Numeric] y position of vertex
    # @param u [Numeric] u texture coordinate of vertex
    # @param v [Numeric] v texture coordinate of vertex
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/vertex_.html
    # @see https://p5js.org/reference/#/p5/vertex
    #
    def vertex(x, y, u = nil, v = nil)
      (@drawingShape__ or raise "vertex() must be called after beginShape()")
        .vertex x, y, u, v
    end

    # Append curve vertex for shape polygon.
    #
    # @param x [Numeric] x position of vertex
    # @param y [Numeric] y position of vertex
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/curveVertex_.html
    # @see https://p5js.org/reference/#/p5/curveVertex
    #
    def curveVertex(x, y)
      (@drawingShape__ or raise "curveVertex() must be called after beginShape()")
        .curveVertex x, y
    end

    # Append bezier vertex for shape polygon.
    #
    # @param x [Numeric] x position of vertex
    # @param y [Numeric] y position of vertex
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/bezierVertex_.html
    # @see https://p5js.org/reference/#/p5/bezierVertex
    #
    def bezierVertex(x2, y2, x3, y3, x4, y4)
      (@drawingShape__ or raise "bezierVertex() must be called after beginShape()")
        .bezierVertex x2, y2, x3, y3, x4, y4
    end

    # Append quadratic vertex for shape polygon.
    #
    # @param x [Numeric] x position of vertex
    # @param y [Numeric] y position of vertex
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/quadraticVertex_.html
    # @see https://p5js.org/reference/#/p5/quadraticVertex
    #
    def quadraticVertex(cx, cy, x3, y3)
      (@drawingShape__ or raise "quadraticVertex() must be called after beginShape()")
        .quadraticVertex cx, cy, x3, y3
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
      blend img, sx, sy, sw, sh, dx, dy, dw, dh, BLEND
    end

    # Blends image.
    #
    # @overload blend(sx, sy, sw, sh, dx, dy, dw, dh, mode)
    # @overload blend(img, sx, sy, sw, sh, dx, dy, dw, dh, mode)
    #
    # @param img  [Image]   image for blend source
    # @param sx   [Numrtic] x position of source region
    # @param sy   [Numrtic] y position of source region
    # @param sw   [Numrtic] width of source region
    # @param sh   [Numrtic] height of source region
    # @param dx   [Numrtic] x position of destination region
    # @param dy   [Numrtic] y position of destination region
    # @param dw   [Numrtic] width of destination region
    # @param dh   [Numrtic] height of destination region
    # @param mode [BLEND, ADD, SUBTRACT, LIGHTEST, DARKEST, EXCLUSION, MULTIPLY, SCREEN, REPLACE] blend mode
    #
    # @return [nil] nil
    #
    def blend(img = nil, sx, sy, sw, sh, dx, dy, dw, dh, mode)
      assertDrawing__
      (img || self).drawImage__(
        @painter__, sx, sy, sw, sh, dx, dy, dw, dh,
        fill: getTint__, stroke: :none, blend_mode: mode)
    end

    # Loads all pixels to the 'pixels' array.
    #
    # @return [nil] nil
    #
    def loadPixels()
      @pixels__ = getInternal__.pixels
    end

    # Update the image pixels with the 'pixels' array.
    #
    # @return [nil] nil
    #
    def updatePixels(&block)
      return if !block && !@pixels__
      if block
        loadPixels
        block.call pixels
      end
      getInternal__.tap do |img|
        img.pixels = @pixels__
        img.paint {} # update texture and set modifiied
      end
      @pixels__ = nil
    end

    # An array of all pixels.
    # Call loadPixels() before accessing the array.
    #
    def pixels()
      @pixels__
    end

    # Saves screen image to file.
    #
    # @param filename [String] file name to save image
    #
    # @return [nil] nil
    #
    def save(filename)
      getInternal__.save filename
      nil
    end

    # Applies translation matrix to current transformation matrix.
    #
    # @overload translate(x, y)
    # @overload translate(x, y, z)
    #
    # @param x [Numeric] left/right translation
    # @param y [Numeric] up/down translation
    # @param y [Numeric] forward/backward translation
    #
    # @return [nil] nil
    #
    def translate(x, y, z = 0)
      assertDrawing__
      @painter__.translate x, y, z
      nil
    end

    # Applies scale matrix to current transformation matrix.
    #
    # @overload scale(s)
    # @overload scale(x, y)
    #
    # @param s [Numeric] horizontal and vertical scale
    # @param x [Numeric] horizontal scale
    # @param y [Numeric] vertical scale
    #
    # @return [nil] nil
    #
    def scale(x, y = nil, z = 1)
      assertDrawing__
      @painter__.scale x, (y || x), z
      nil
    end

    # Applies rotation matrix to current transformation matrix.
    #
    # @param angle [Numeric] angle for rotation
    #
    # @return [nil] nil
    #
    def rotate(angle)
      assertDrawing__
      @painter__.rotate toDegrees__ angle
      nil
    end

    # Pushes the current transformation matrix to stack.
    #
    # @return [Object] result of the expression at the end of the block
    #
    def pushMatrix(&block)
      assertDrawing__
      @matrixStack__.push @painter__.matrix
      block.call if block
    ensure
      popMatrix if block
    end

    # Pops the current transformation matrix from stack.
    #
    # @return [nil] nil
    #
    def popMatrix()
      assertDrawing__
      raise "matrix stack underflow" if @matrixStack__.empty?
      @painter__.matrix = @matrixStack__.pop
      nil
    end

    # Reset current transformation matrix with identity matrix.
    #
    # @return [nil] nil
    #
    def resetMatrix()
      assertDrawing__
      @painter__.matrix = 1
      nil
    end

    # Save current style values to the style stack.
    #
    # @return [Object] result of the expression at the end of the block
    #
    def pushStyle(&block)
      assertDrawing__
      @styleStack__.push [
        @painter__.fill,
        @painter__.stroke,
        @painter__.stroke_width,
        @painter__.stroke_cap,
        @painter__.stroke_join,
        @painter__.miter_limit,
        @painter__.clip,
        @painter__.blend_mode,
        @painter__.font,
        @painter__.texture,
        @painter__.texcoord_mode,
        @painter__.texcoord_wrap,
        @painter__.shader,
        @colorMode__,
        @hsbColor__,
        @colorMaxes__,
        @angleMode__,
        @angleScale__,
        @rectMode__,
        @ellipseMode__,
        @imageMode__,
        @shapeMode__,
        @blendMode__,
        @curveDetail__,
        @curveTightness__,
        @bezierDetail__,
        @textAlignH__,
        @textAlignV__,
        @textFont__,
        @tint__,
      ]
      block.call if block
    ensure
      popStyle if block
    end

    # Restore style values from the style stack.
    #
    # @return [nil] nil
    #
    def popStyle()
      assertDrawing__
      raise "style stack underflow" if @styleStack__.empty?
      @painter__.fill,
      @painter__.stroke,
      @painter__.stroke_width,
      @painter__.stroke_cap,
      @painter__.stroke_join,
      @painter__.miter_limit,
      @painter__.clip,
      @painter__.blend_mode,
      @painter__.font,
      @painter__.texture,
      @painter__.texcoord_mode,
      @painter__.texcoord_wrap,
      @painter__.shader,
      @colorMode__,
      @hsbColor__,
      @colorMaxes__,
      @angleMode__,
      @angleScale__,
      @rectMode__,
      @ellipseMode__,
      @imageMode__,
      @shapeMode__,
      @blendMode__,
      @curveDetail__,
      @curveTightness__,
      @bezierDetail__,
      @textAlignH__,
      @textAlignV__,
      @textFont__,
      @tint__ = @styleStack__.pop
      @textFont__.setSize__ @painter__.font.size
      nil
    end

    # Save current styles and transformations to stack.
    #
    # @return [Object] result of the expression at the end of the block
    #
    def push(&block)
      pushMatrix
      pushStyle
      block.call if block
    ensure
      pop if block
    end

    # Restore styles and transformations from stack.
    #
    # @return [nil] nil
    #
    def pop()
      popMatrix
      popStyle
    end

    # @private
    def getInternal__()
      @image__
    end

    # @private
    def drawImage__(painter, *args, image__: getInternal__, **states)
      shader = painter.shader || @filter__&.getInternal__
      painter.push shader: shader, **states do |_|
        painter.image image__, *args
      end
    end

    # @private
    private def assertDrawing__()
      raise "call beginDraw() before drawing" unless @drawing__
    end

    #
    # Utilities
    #

    # Returns the absolute number of the value.
    #
    # @param value [Numeric] number
    #
    # @return [Numeric] absolute number
    #
    def abs(value)
      value.abs
    end

    # Returns the closest integer number greater than or equal to the value.
    #
    # @param value [Numeric] number
    #
    # @return [Numeric] rounded up number
    #
    def ceil(value)
      value.ceil
    end

    # Returns the closest integer number less than or equal to the value.
    #
    # @param value [Numeric] number
    #
    # @return [Numeric] rounded down number
    #
    def floor(value)
      value.floor
    end

    # Returns the closest integer number.
    #
    # @param value [Numeric] number
    #
    # @return [Numeric] rounded number
    #
    def round(value)
      value.round
    end

    # Returns the natural logarithm (the base-e logarithm) of a number.
    #
    # @param value [Numeric] number (> 0.0)
    #
    # @return [Numeric] result number
    #
    def log(n)
      Math.log n
    end

    # Returns Euler's number e raised to the power of value.
    #
    # @param value [Numeric] number
    #
    # @return [Numeric] result number
    #
    def exp(n)
      Math.exp n
    end

    # Returns value raised to the power of exponent.
    #
    # @param value    [Numeric] base number
    # @param exponent [Numeric] exponent number
    #
    # @return [Numeric] value ** exponent
    #
    def pow(value, exponent)
      value ** exponent
    end

    # Returns squared value.
    #
    # @param value [Numeric] number
    #
    # @return [Numeric] squared value
    #
    def sq(value)
      value * value
    end

    # Returns squared value.
    #
    # @param value [Numeric] number
    #
    # @return [Numeric] squared value
    #
    def sqrt(value)
      Math.sqrt value
    end

    # Returns the magnitude (or length) of a vector.
    #
    # @overload mag(x, y)
    # @overload mag(x, y, z)
    #
    # @param x [Numeric] x of point
    # @param y [Numeric] y of point
    # @param z [Numeric] z of point
    #
    # @return [Numeric] magnitude
    #
    def mag(*args)
      x, y, z = *args
      case args.size
      when 2 then Math.sqrt x * x + y * y
      when 3 then Math.sqrt x * x + y * y + z * z
      else raise ArgumentError
      end
    end

    # Returns distance between 2 points.
    #
    # @overload dist(x1, y1, x2, y2)
    # @overload dist(x1, y1, z1, x2, y2, z2)
    #
    # @param x1 [Numeric] x of first point
    # @param y1 [Numeric] y of first point
    # @param z1 [Numeric] z of first point
    # @param x2 [Numeric] x of second point
    # @param y2 [Numeric] y of second point
    # @param z2 [Numeric] z of second point
    #
    # @return [Numeric] distance between 2 points
    #
    def dist(*args)
      case args.size
      when 4
        x1, y1, x2, y2 = *args
        xx, yy = x2 - x1, y2 - y1
        Math.sqrt xx * xx + yy * yy
      when 3
        x1, y1, z1, x2, y2, z2 = *args
        xx, yy, zz = x2 - x1, y2 - y1, z2 - z1
        Math.sqrt xx * xx + yy * yy + zz * zz
      else raise ArgumentError
      end
    end

    # Normalize the value from range start..stop into 0..1.
    #
    # @param value [Numeric] number to be normalized
    # @param start [Numeric] lower bound of the range
    # @param stop  [Numeric] upper bound of the range
    #
    # @return [Numeric] normalized value between 0..1
    #
    def norm(value, start, stop)
      (value.to_f - start.to_f) / (stop.to_f - start.to_f)
    end

    # Returns the interpolated number between range start..stop.
    #
    # @param start  [Numeric] lower bound of the range
    # @param stop   [Numeric] upper bound of the range
    # @param amount [Numeric] amount to interpolate
    #
    # @return [Numeric] interporated number
    #
    def lerp(start, stop, amount)
      start + (stop - start) * amount
    end

    # Returns the interpolated color between color1 and color2.
    #
    # @param color1 [Integer] the 1st color for interpolation
    # @param color2 [Integer] the 2nd color for interpolation
    # @param amount [Numeric] amount to interpolate
    #
    # @return [Integer] interporated color
    #
    def lerpColor(color1, color2, amount)
      color(
        lerp(red(  color1), red(  color2), amount),
        lerp(green(color1), green(color2), amount),
        lerp(blue( color1), blue( color2), amount),
        lerp(alpha(color1), alpha(color2), amount))
    end

    # Maps a number from range start1..stop1 to range start2..stop2.
    #
    # @param value  [Numeric] number to be mapped
    # @param start1 [Numeric] lower bound of the range1
    # @param stop1  [Numeric] upper bound of the range1
    # @param start2 [Numeric] lower bound of the range2
    # @param stop2  [Numeric] upper bound of the range2
    #
    # @return [Numeric] mapped number
    #
    def map(value, start1, stop1, start2, stop2)
      lerp start2, stop2, norm(value, start1, stop1)
    end

    # Returns minimum value.
    #
    # @overload min(a, b)
    # @overload min(a, b, c)
    # @overload min(array)
    #
    # @param a     [Numeric] value to compare
    # @param b     [Numeric] value to compare
    # @param c     [Numeric] value to compare
    # @param array [Numeric] values to compare
    #
    # @return [Numeric] minimum value
    #
    def min(*args)
      args.flatten.min
    end

    # Returns maximum value.
    #
    # @overload max(a, b)
    # @overload max(a, b, c)
    # @overload max(array)
    #
    # @param a     [Numeric] value to compare
    # @param b     [Numeric] value to compare
    # @param c     [Numeric] value to compare
    # @param array [Numeric] values to compare
    #
    # @return [Numeric] maximum value
    #
    def max(*args)
      args.flatten.max
    end

    # Constrains the number between min..max.
    #
    # @param value [Numeric] number to be constrained
    # @param min   [Numeric] lower bound of the range
    # @param max   [Numeric] upper bound of the range
    #
    # @return [Numeric] constrained number
    #
    def constrain(value, min, max)
      value < min ? min : (value > max ? max : value)
    end

    # Converts degree to radian.
    #
    # @param degree [Numeric] degree to convert
    #
    # @return [Numeric] radian
    #
    def radians(degree)
      degree * DEG2RAD__
    end

    # Converts radian to degree.
    #
    # @param radian [Numeric] radian to convert
    #
    # @return [Numeric] degree
    #
    def degrees(radian)
      radian * RAD2DEG__
    end

    # Returns the sine of an angle.
    #
    # @param angle [Numeric] angle in radians
    #
    # @return [Numeric] the sine
    #
    def sin(angle)
      Math.sin angle
    end

    # Returns the cosine of an angle.
    #
    # @param angle [Numeric] angle in radians
    #
    # @return [Numeric] the cosine
    #
    def cos(angle)
      Math.cos angle
    end

    # Returns the ratio of the sine and cosine of an angle.
    #
    # @param angle [Numeric] angle in radians
    #
    # @return [Numeric] the tangent
    #
    def tan(angle)
      Math.tan angle
    end

    # Returns the inverse of sin().
    #
    # @param value [Numeric] value for calculation
    #
    # @return [Numeric] the arc sine
    #
    def asin(value)
      Math.asin value
    end

    # Returns the inverse of cos().
    #
    # @param value [Numeric] value for calculation
    #
    # @return [Numeric] the arc cosine
    #
    def acos(value)
      Math.acos value
    end

    # Returns the inverse of tan().
    #
    # @param value [Numeric] value for valculation
    #
    # @return [Numeric] the arc tangent
    #
    def atan(value)
      Math.atan value
    end

    # Returns the angle from a specified point.
    #
    # @param y [Numeric] y of the point
    # @param x [Numeric] x of the point
    #
    # @return [Numeric] the angle in radians
    #
    def atan2(y, x)
      Math.atan2 y, x
    end

    # Evaluates the curve at point t for points a, b, c, d.
    #
    # @param a [Numeric] coordinate of first control point
    # @param b [Numeric] coordinate of first point on the curve
    # @param c [Numeric] coordinate of second point on the curve
    # @param d [Numeric] coordinate of second control point
    # @param t [Numeric] value between 0.0 and 1.0
    #
    # @return [Numeric] interpolated value
    #
    # @see https://processing.org/reference/curvePoint_.html
    # @see https://p5js.org/reference/#/p5/curvePoint
    #
    def curvePoint(a, b, c, d, t)
      s  = @curveTightness__
      t3 = t * t * t
      t2 = t * t
      f1 = ( s - 1.0) / 2.0 * t3 + ( 1.0 - s)       * t2 + (s - 1.0) / 2.0 * t
      f2 = ( s + 3.0) / 2.0 * t3 + (-5.0 - s) / 2.0 * t2 +  1.0
      f3 = (-3.0 - s) / 2.0 * t3 + ( s + 2.0)       * t2 + (1.0 - s) / 2.0 * t
      f4 = ( 1.0 - s) / 2.0 * t3 + ( s - 1.0) / 2.0 * t2
      a * f1 + b * f2 + c * f3 + d * f4
    end

    # Calculates the tangent of a point on a curve.
    #
    # @param a [Numeric] coordinate of first control point
    # @param b [Numeric] coordinate of first point on the curve
    # @param c [Numeric] coordinate of second point on the curve
    # @param d [Numeric] coordinate of second control point
    # @param t [Numeric] value between 0.0 and 1.0
    #
    # @return [Numeric] tangent value
    #
    # @see https://processing.org/reference/curveTangent_.html
    # @see https://p5js.org/reference/#/p5/curveTangent
    #
    def curveTangent(a, b, c, d, t)
      s = @curveTightness__
      tt3 = t * t * 3.0
      t2  = t * 2.0
      f1  = ( s - 1.0) / 2.0 * tt3 + ( 1.0 - s)       * t2 + (s - 1.0) / 2.0
      f2  = ( s + 3.0) / 2.0 * tt3 + (-5.0 - s) / 2.0 * t2
      f3  = (-3.0 - s) / 2.0 * tt3 + ( s + 2.0)       * t2 + (1.0 - s) / 2.0
      f4  = ( 1.0 - s) / 2.0 * tt3 + ( s - 1.0) / 2.0 * t2
      a * f1 + b * f2 + c * f3 + d * f4
    end

    # Evaluates the Bezier at point t for points a, b, c, d.
    #
    # @param a [Numeric] coordinate of first point on the curve
    # @param b [Numeric] coordinate of first control point
    # @param c [Numeric] coordinate of second control point
    # @param d [Numeric] coordinate of second point on the curve
    # @param t [Numeric] value between 0.0 and 1.0
    #
    # @return [Numeric] interpolated value
    #
    # @see https://processing.org/reference/bezierPoint_.html
    # @see https://p5js.org/reference/#/p5/bezierPoint
    #
    def bezierPoint(a, b, c, d, t)
      tt = 1.0 - t
      tt ** 3.0 * a +
      tt ** 2.0 * b * 3.0 * t +
      t  ** 2.0 * c * 3.0 * tt +
      t  ** 3.0 * d
    end

    # Calculates the tangent of a point on a Bezier curve.
    #
    # @param a [Numeric] coordinate of first point on the curve
    # @param b [Numeric] coordinate of first control point
    # @param c [Numeric] coordinate of second control point
    # @param d [Numeric] coordinate of second point on the curve
    # @param t [Numeric] value between 0.0 and 1.0
    #
    # @return [Numeric] tangent value
    #
    # @see https://processing.org/reference/bezierTangent_.html
    # @see https://p5js.org/reference/#/p5/bezierTangent
    #
    def bezierTangent(a, b, c, d, t)
      tt = 1.0 - t
      3.0 * d * t  ** 2.0 -
      3.0 * c * t  ** 2.0 +
      6.0 * c * tt *  t   -
      6.0 * b * tt *  t   +
      3.0 * b * tt ** 2.0 -
      3.0 * a * tt ** 2.0
    end

    # Returns the perlin noise value.
    #
    # @overload noise(x)
    # @overload noise(x, y)
    # @overload noise(x, y, z)
    #
    # @param x [Numeric] horizontal point in noise space
    # @param y [Numeric] vertical point in noise space
    # @param z [Numeric] depth point in noise space
    #
    # @return [Numeric] noise value (0.0..1.0)
    #
    # @see https://processing.org/reference/noise_.html
    # @see https://p5js.org/reference/#/p5/noise
    #
    def noise(x, y = 0, z = 0)
      seed, falloff = @noiseSeed__, @noiseFallOff__
      amp           = 0.5
      @noiseOctaves__.times.reduce(0) do |sum|
        value = (Rays.perlin(x, y, z, seed) / 2.0 + 0.5) * amp
        x    *= 2
        y    *= 2
        z    *= 2
        amp  *= falloff
        sum + value
      end
    end

    # Sets the seed value for noise()
    #
    # @param seed [Numeric] seed value
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/noiseSeed_.html
    # @see https://p5js.org/reference/#/p5/noiseSeed
    #
    def noiseSeed(seed)
      @noiseSeed__ = Random.new(seed).rand 0.0..1.0
    end

    # Adjusts the character and level of detail produced by the Perlin noise function.
    #
    # @param lod     [Numeric] number of octaves to be used by the noise
    # @param falloff [Numeric] falloff factor for each octave
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/noiseDetail_.html
    # @see https://p5js.org/reference/#/p5/noiseDetail
    #
    def noiseDetail(lod, falloff = nil)
      @noiseOctaves__ = lod     if lod     && lod > 0
      @noiseFallOff__ = falloff if falloff && falloff > 0
    end

    # Returns a random number in range low...high
    #
    # @overload random(high)
    # @overload random(low, high)
    # @overload random(choices)
    #
    # @param low     [Numeric] lower limit
    # @param high    [Numeric] upper limit
    # @param choices [Array]   array to choose from
    #
    # @return [Float] random number
    #
    # @see https://processing.org/reference/random_.html
    # @see https://p5js.org/reference/#/p5/random
    #
    def random(*args)
      if args.first.kind_of? Array
        a = args.first
        a.empty? ? nil : a[@random__.rand a.size]
      else
        high, low = args.reverse
        @random__.rand (low || 0).to_f...(high || 1).to_f
      end
    end

    # Sets the seed value for random()
    #
    # @param seed [Numeric] seed value
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/randomSeed_.html
    # @see https://p5js.org/reference/#/p5/randomSeed
    #
    def randomSeed(seed)
      @random__ = Random.new seed
    end

    # Creates a new vector object.
    #
    # @overload createVector()
    # @overload createVector(x, y)
    # @overload createVector(x, y, z)
    #
    # @param x [Numeric] x of new vector
    # @param y [Numeric] y of new vector
    # @param z [Numeric] z of new vector
    #
    # @return [Vector] new vector
    #
    def createVector(*args)
      Vector.new(*args, context: self)
    end

    # Creates a new font object.
    #
    # @param name [String]  font name
    # @param size [Numeric] font size (max 256)
    #
    def createFont(name, size)
      size = FONT_SIZE_MAX__ if size && size > FONT_SIZE_MAX__
      Font.new Rays::Font.new(name, size || FONT_SIZE_DEFAULT__)
    end

    # Creates a new image object.
    #
    # @overload createImage(w, h)
    # @overload createImage(w, h, format)
    #
    # @param w      [Numeric]   width of new image
    # @param h      [Numeric]   height of new image
    # @param format [RGB, RGBA] image format
    #
    # @return [Image] new image
    #
    def createImage(w, h, format = RGBA)
      colorspace = {RGB => Rays::RGB, RGBA => Rays::RGBA}[format]
      raise ArgumentError, "Unknown image format" unless colorspace
      Image.new Rays::Image.new(w, h, colorspace).paint {background 0, 0}
    end

    # Creates a new shape object.
    #
    # @overload createShape()
    # @overload createShape(LINE, x1, y1, x2, y2)
    # @overload createShape(RECT, a, b, c, d)
    # @overload createShape(ELLIPSE, a, b, c, d)
    # @overload createShape(ARC, a, b, c, d, start, stop)
    # @overload createShape(TRIANGLE, x1, y1, x2, y2, x3, y3)
    # @overload createShape(QUAD, x1, y1, x2, y2, x3, y3, x4, y4)
    # @overload createShape(GROUP)
    #
    # @param kind [LINE, RECT, ELLIPSE, ARC, TRIANGLE, QUAD, GROUP]
    #
    def createShape(kind = nil, *args)
      case kind
      when LINE     then createLineShape__(    *args)
      when RECT     then createRectShape__(    *args)
      when ELLIPSE  then createEllipseShape__( *args)
      when ARC      then createArcShape__(     *args)
      when TRIANGLE then createTriangleShape__(*args)
      when QUAD     then createQuadShape__(    *args)
      when GROUP    then Shape.new nil, [], context: self
      when nil      then Shape.new context: self
      else raise ArgumentError, "Unknown shape kind '#{kind}'"
      end
    end

    # @private
    private def createLineShape__(x1, y1, x2, y2)
      Shape.new Rays::Polygon.line(x1, y1, x2, y2), context: self
    end

    # @private
    private def createRectShape__(a, b, c, d)
      x, y, w, h = toXYWH__ @rectMode__, a, b, c, d
      Shape.new Rays::Polygon.rect(x, y, w, h), context: self
    end

    # @private
    private def createEllipseShape__(a, b, c, d)
      x, y, w, h = toXYWH__ @ellipseMode__, a, b, c, d
      Shape.new Rays::Polygon.ellipse(x, y, w, h), context: self
    end

    # @private
    private def createArcShape__(a, b, c, d, start, stop)
      x, y, w, h = toXYWH__ @ellipseMode__, a, b, c, d
      from, to   = toDegrees__(-start), toDegrees__(-stop)
      Shape.new Rays::Polygon.ellipse(x, y, w, h, from: from, to: to), context: self
    end

    # @private
    private def createTriangleShape__(x1, y1, x2, y2, x3, y3)
      Shape.new Rays::Polygon.new(x1, y1, x2, y2, x3, y3, loop: true), context: self
    end

    # @private
    private def createQuadShape__(x1, y1, x2, y2, x3, y3, x4, y4)
      Shape.new Rays::Polygon.quads(x1, y1, x2, y2, x3, y3, x4, y4), context: self
    end

    # Creates a new off-screen graphics context object.
    #
    # @param width        [Numeric] width of graphics image
    # @param height       [Numeric] height of graphics image
    # @param pixelDensity [Numeric] pixel density of graphics image
    #
    # @return [Graphics] graphics object
    #
    def createGraphics(width, height, pixelDensity = 1)
      Graphics.new width, height, pixelDensity
    end

    # Creates a shader object.
    #
    # Passing nil for a vertex shader parameter causes the following default vertex shader to be used.
    # ```
    # attribute vec3 position;
    # attribute vec3 texCoord;
    # attribute vec4 color;
    # varying vec4 vertPosition;
    # varying vec4 vertTexCoord;
    # varying vec4 vertColor;
    # uniform mat4 transform;
    # uniform mat4 texMatrix;
    # void main ()
    # {
    #   vec4 pos__   = vec4(position, 1.0);
    #   vertPosition = pos__;
    #   vertTexCoord = texMatrix * vec4(texCoord, 1.0);
    #   vertColor    = color;
    #   gl_Position  = transform * pos__;
    # }
    # ```
    #
    # @overload createShader(vertPath, fragPath)
    # @overload createShader(vertSource, fragSource)
    #
    # @param vertPath   [String] vertex shader file path
    # @param fragPath   [String] fragment shader file path
    # @param vertSource [String] vertex shader source
    # @param fragSource [String] fragment shader source
    #
    # @return [Shader] shader object
    #
    def createShader(vert, frag)
      vert = File.read if vert && File.exist?(vert)
      frag = File.read if frag && File.exist?(frag)
      Shader.new vert, frag
    end

    # Creates a camera object as a video input device.
    #
    # @return [Capture] camera object
    #
    def createCapture(*args)
      Capture.new(*args)
    end

    # Loads font from file.
    #
    # @param filename  [String] file name to load font file
    #
    # @return [Font] loaded font object
    #
    # @see https://processing.org/reference/loadFont_.html
    # @see https://p5js.org/reference/#/p5/loadFont
    #
    def loadFont(filename)
      ext = File.extname filename
      raise "unsupported font type -- '#{ext}'" unless ext =~ /^\.?(ttf|otf)$/i

      filename = httpGet__ filename, ext if filename =~ %r|^https?://|
      Font.new Rays::Font.load p filename
    end

    # Loads image.
    #
    # @param filename  [String] file name to load image
    # @param extension [String] type of image to load (ex. 'png')
    #
    # @return [Image] loaded image object
    #
    # @see https://processing.org/reference/loadImage_.html
    # @see https://p5js.org/reference/#/p5/loadImage
    #
    def loadImage(filename, extension = nil)
      ext = extension || File.extname(filename)
      raise "unsupported image type -- '#{ext}'" unless ext =~ /^\.?(png|jpg|gif)$/i

      filename = httpGet__ filename, ext if filename =~ %r|^https?://|
      Image.new Rays::Image.load filename
    end

    # Loads image on a new thread.
    # When the image is loading, its width and height will be 0.
    # If an error occurs while loading the image, its width and height wil be -1.
    #
    # @param filename  [String] file name to load image
    # @param extension [String] type of image to load (ex. 'png')
    #
    # @return [Image] loading image object
    #
    # @see https://processing.org/reference/requestImage_.html
    #
    def requestImage(filename, extension = nil)
      img = Image.new nil
      Thread.new filename, extension do |fn, ext|
        loaded = loadImage(fn, ext) or raise
        img.setInternal__ loaded.getInternal__
      rescue
        img.setInternal__ nil, true
      end
      img
    end

    # Loads shader file.
    #
    # @overload loadShader(fragPath)
    # @overload loadShader(fragPath, vertPath)
    #
    # @param fragPath [String] fragment shader file path
    # @param vertPath [String] vertex shader file path
    #
    # @return [Shader] loaded shader object
    #
    def loadShader(fragPath, vertPath = nil)
      createShader vertPath, fragPath
    end

    # @private
    private def httpGet__(uri, ext)
      tmpdir = tmpdir__
      path   = tmpdir + Digest::SHA1.hexdigest(uri)
      path   = path.sub_ext ext

      unless path.file?
        URI.open uri do |input|
          input.set_encoding nil# disable default_internal
          tmpdir.mkdir unless tmpdir.directory?
          path.open('w') do |output|
            output.set_encoding Encoding::ASCII_8BIT
            while buf = input.read(2 ** 16)
              output.write buf
            end
          end
        end
      end
      path.to_s
    end

    # @private
    private def tmpdir__()
      Pathname(Dir.tmpdir) + Digest::SHA1.hexdigest(self.class.name)
    end

  end# GraphicsContext


end# Processing
