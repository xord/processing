module RubySketch


  # Processing compatible API
  #
  class Processing

    include Math

    extend Starter

    HALF_PI    = PI / 2
    QUARTER_PI = PI / 4
    TWO_PI     = PI * 2
    TAU        = PI * 2

    # RGB mode for colorMode() function.
    #
    RGB = :RGB

    # HSB mode for colorMode() function.
    #
    HSB = :HSB

    # Radian mode for angleMode() function.
    #
    RADIANS = :RADIANS

    # Degree mode for angleMode() function.
    #
    DEGREES = :DEGREES

    CORNER  = :CORNER
    CORNERS = :CORNERS
    CENTER  = :CENTER
    RADIUS  = :RADIUS

    # @private
    DEG2RAD__ = PI / 180.0

    # @private
    RAD2DEG__ = 180.0 / PI

    # @private
    def initialize ()
      @matrixStack__  = []
      @styleStack__   = []
      @frameCount__   = 0
      @hsbColor__     = false
      @colorMaxes__   = [1.0] * 4
      @angleScale__   = 1.0
      @mouseX__       =
      @mouseY__       =
      @mousePrevX__   =
      @mousePrevY__   = 0
      @mousePressed__ = false

      colorMode   RGB, 255
      angleMode   RADIANS
      rectMode    CORNER
      ellipseMode CENTER
    end

    # @private
    def on_start__ (window)
      @window__  = window
      @painter__ = window.canvas_painter

      setupDrawBlock__
      setupMousePressedBlock__
      setupMouseReleasedBlock__
      setupMouseMovedBlock__
      setupMouseDraggedBlock__
    end

    # Returns the absolute number of the value.
    #
    # @param value [Numeric] number
    #
    # @return [Numeric] absolute number
    #
    def abs (value)
      value.abs
    end

    # Returns the closest integer number greater than or equal to the value.
    #
    # @param value [Numeric] number
    #
    # @return [Numeric] rounded up number
    #
    def ceil (value)
      value.ceil
    end

    # Returns the closest integer number less than or equal to the value.
    #
    # @param value [Numeric] number
    #
    # @return [Numeric] rounded down number
    #
    def floor (value)
      value.floor
    end

    # Returns the closest integer number.
    #
    # @param value [Numeric] number
    #
    # @return [Numeric] rounded number
    #
    def round (value)
      value.round
    end

    # Returns value raised to the power of exponent.
    #
    # @param value    [Numeric] base number
    # @param exponent [Numeric] exponent number
    #
    # @return [Numeric] value ** exponent
    #
    def pow (value, exponent)
      value ** exponent
    end

    # Returns squared value.
    #
    # @param value [Numeric] number
    #
    # @return [Numeric] squared value
    #
    def sq (value)
      value * value
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
    def mag (*args)
      x, y, z = *args
      case args.size
        when 2 then sqrt x * x + y * y
        when 3 then sqrt x * x + y * y + z * z
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
    def dist (*args)
      case args.size
        when 4
          x1, y1, x2, y2 = *args
          xx, yy = x2 - x1, y2 - y1
          sqrt xx * xx + yy * yy
        when 3
          x1, y1, z1, x2, y2, z2 = *args
          xx, yy, zz = x2 - x1, y2 - y1, z2 - z1
          sqrt xx * xx + yy * yy + zz * zz
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
    def norm (value, start, stop)
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
    def lerp (start, stop, amount)
      start + (stop - start) * amount
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
    def map (value, start1, stop1, start2, stop2)
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
    def min (*args)
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
    def max (*args)
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
    def constrain (value, min, max)
      value < min ? min : (value > max ? max : value)
    end

    # Converts degree to radian.
    #
    # @param degree [Numeric] degree to convert
    #
    # @return [Numeric] radian
    #
    def radians (degree)
      degree * DEG2RAD__
    end

    # Converts radian to degree.
    #
    # @param radian [Numeric] radian to convert
    #
    # @return [Numeric] degree
    #
    def degrees (radian)
      radian * RAD2DEG__
    end

    # Define setup block.
    #
    def setup (&block)
      @window__.setup = block
      nil
    end

    # @private
    private def setupDrawBlock__ ()
      @window__.draw = proc do |e, painter|
        @painter__ = painter
        @matrixStack__.clear
        @styleStack__.clear
        begin
          push
          @drawBlock__.call e if @drawBlock__
        ensure
          pop
        end
        @frameCount__ += 1
        updateMousePrevPos__
      end
    end

    # Define draw block.
    #
    def draw (&block)
      @drawBlock__ = block if block
      nil
    end

    def key (&block)
      @window__.key = block
      nil
    end

    # @private
    private def setupMousePressedBlock__ ()
      @window__.pointer_down = proc do |e|
        updateMouseState__ e.x, e.y, true
        @mousePressedBlock__.call e if @mousePressedBlock__
      end
    end

    def mousePressed (&block)
      @mousePressedBlock__ = block if block
      @mousePressed__
    end

    # @private
    private def setupMouseReleasedBlock__ ()
      @window__.pointer_up = proc do |e|
        updateMouseState__ e.x, e.y, false
        @mouseReleasedBlock__.call e if @mouseReleasedBlock__
      end
    end

    def mouseReleased (&block)
      @mouseReleasedBlock__ = block if block
      nil
    end

    # @private
    private def setupMouseMovedBlock__ ()
      @window__.pointer_move = proc do |e|
        updateMouseState__ e.x, e.y
        @mouseMovedBlock__.call e if @mouseMovedBlock__
      end
    end

    def mouseMoved (&block)
      @mouseMovedBlock__ = block if block
      nil
    end

    # @private
    private def setupMouseDraggedBlock__ ()
      @window__.pointer_drag = proc do |e|
        updateMouseState__ e.x, e.y
        @mouseDraggedBlock__.call e if @mouseDraggedBlock__
      end
    end

    def mouseDragged (&block)
      @mouseDraggedBlock__ = block if block
      nil
    end

    # @private
    private def updateMouseState__ (x, y, pressed = nil)
      @mouseX__       = x
      @mouseY__       = y
      @mousePressed__ = pressed if pressed != nil
    end

    # @private
    private def updateMousePrevPos__ ()
      @mousePrevX__ = @mouseX__
      @mousePrevY__ = @mouseY__
    end

    # @private
    private def size__ (width, height)
      raise 'size() must be called on startup or setup block' if @started__

      @painter__.send :end_paint
      reset_canvas width, height
      @painter__.send :begin_paint

      @auto_resize__ = false
    end

    def width ()
      @window__.canvas.width
    end

    def height ()
      @window__.canvas.height
    end

    def windowWidth ()
      @window__.width
    end

    def windowHeight ()
      @window__.height
    end

    # Returns number of frames since program started.
    #
    # @return [Integer] total number of frames
    #
    def frameCount ()
      @frameCount__
    end

    # Returns number of frames per second.
    #
    # @return [Float] frames per second
    #
    def frameRate ()
      @window__.event.fps
    end

    # Returns pixel density
    #
    # @return [Numeric] pixel density
    #
    def displayDensity ()
      @painter__.pixel_density
    end

    # Returns mouse x position
    #
    # @return [Numeric] horizontal position of mouse
    #
    def mouseX ()
      @mouseX__
    end

    # Returns mouse y position
    #
    # @return [Numeric] vertical position of mouse
    #
    def mouseY ()
      @mouseY__
    end

    # Returns mouse x position in previous frame
    #
    # @return [Numeric] horizontal position of mouse
    #
    def pmouseX ()
      @mousePrevX__
    end

    # Returns mouse y position in previous frame
    #
    # @return [Numeric] vertical position of mouse
    #
    def pmouseY ()
      @mousePrevY__
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
    # @return [nil] nil
    #
    def colorMode (mode, *maxes)
      raise ArgumentError, "invalid color mode: #{mode}" unless [RGB, HSB].include?(mode)
      raise ArgumentError unless [0, 1, 3, 4].include?(maxes.size)

      @hsbColor__ = mode.upcase == HSB
      case maxes.size
        when 1    then @colorMaxes__                 = [maxes.first.to_f] * 4
        when 3, 4 then @colorMaxes__[0...maxes.size] = maxes.map &:to_f
      end
      nil
    end

    # @private
    private def toRGBA__ (*args)
      a, b, c, d = args
      return parseColor__(a, b || alphaMax__) if a.kind_of?(String)

      rgba = case args.size
        when 1, 2 then [a, a, a, b || alphaMax__]
        when 3, 4 then [a, b, c, d || alphaMax__]
        else raise ArgumentError
      end
      rgba  = rgba.map.with_index {|value, i| value / @colorMaxes__[i]}
      color = @hsbColor__ ? Rays::Color.hsv(*rgba) : Rays::Color.new(*rgba)
      color.to_a
    end

    # @private
    private def parseColor__ (str, alpha)
      result = str.match /^\s*##{'([0-9a-f]{2})' * 3}\s*$/i
      raise ArgumentError, "invalid color code: '#{str}'" unless result

      rgb = result[1..3].map.with_index {|hex, i| hex.to_i(16) / 255.0}
      return *rgb, (alpha / alphaMax__)
    end

    # @private
    private def alphaMax__ ()
      @colorMaxes__[3]
    end

    # Sets angle mode.
    #
    # @param mode [RADIANS, DEGREES] RADIANS or DEGREES
    #
    # @return [nil] nil
    #
    def angleMode (mode)
      @angleScale__ = case mode
        when RADIANS then RAD2DEG__
        when DEGREES then 1.0
        else raise ArgumentError, "invalid angle mode: #{mode}"
      end
      nil
    end

    # @private
    private def toAngle__ (angle)
      angle * @angleScale__
    end

    # Sets rect mode. Default is CORNER.
    #
    # CORNER  -> rect(left, top, width, height)
    # CORNERS -> rect(left, top, right, bottom)
    # CENTER  -> rect(center_x, center_y, width, height)
    # RADIUS  -> rect(center_x, center_y, radius_h, radius_v)
    #
    # @param mode [CORNER, CORNERS, CENTER, RADIUS]
    #
    # @return [nil] nil
    #
    def rectMode (mode)
      @rectMode__ = mode
    end

    # Sets ellipse mode. Default is CENTER.
    #
    # CORNER  -> ellipse(left, top, width, height)
    # CORNERS -> ellipse(left, top, right, bottom)
    # CENTER  -> ellipse(center_x, center_y, width, height)
    # RADIUS  -> ellipse(center_x, center_y, radius_h, radius_v)
    #
    # @param mode [CORNER, CORNERS, CENTER, RADIUS]
    #
    # @return [nil] nil
    #
    def ellipseMode (mode)
      @ellipseMode__ = mode
    end

    # @private
    private def toXYWH__ (mode, a, b, c, d)
      case mode
      when CORNER  then [a,           b,           c,     d]
      when CORNERS then [a,           b,           c - a, d - b]
      when CENTER  then [a - c / 2.0, b - d / 2.0, c,     d]
      when RADIUS  then [a - c,       b - d,       c * 2, d * 2]
      else raise ArgumentError # ToDo: refine error message
      end
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
    def background (*args)
      rgba = toRGBA__ *args
      if rgba[3] == 1
        @painter__.background *rgba
      else
        @painter__.push fill: rgba, stroke: nil do |_|
          @painter__.rect 0, 0, width, height
        end
      end
      nil
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
    def fill (*args)
      @painter__.fill(*toRGBA__(*args))
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
    def stroke (*args)
      @painter__.stroke(*toRGBA__(*args))
      nil
    end

    # Sets stroke weight.
    #
    # @param weight [Numeric] width of stroke
    #
    # @return [nil] nil
    #
    def strokeWeight (weight)
      @painter__.stroke_width weight
      nil
    end

    # Disables filling.
    #
    # @return [nil] nil
    #
    def noFill ()
      @painter__.fill nil
      nil
    end

    # Disables drawing stroke.
    #
    # @return [nil] nil
    #
    def noStroke ()
      @painter__.stroke nil
      nil
    end

    # Sets font.
    #
    # @param name [String]  font name
    # @param size [Numeric] font size
    #
    # @return [Font] current font
    #
    def textFont (name = nil, size = nil)
      @painter__.font name, size if name || size
      Font.new @painter__.font
    end

    # Sets text size.
    #
    # @param size [Numeric] font size
    #
    # @return [nil] nil
    #
    def textSize (size)
      @painter__.font @painter__.font.name, size
      nil
    end

    # Draws a point.
    #
    # @param x [Numeric] horizontal position
    # @param y [Numeric] vertical position
    #
    # @return [nil] nil
    #
    def point (x, y)
      w = @painter__.stroke_width
      w = 1 if w == 0
      @painter__.ellipse x - (w / 2.0), y - (w / 2.0), w, w
      nil
    end

    # Draws a line.
    #
    # @param x1 [Numeric] horizontal position for first point
    # @param y1 [Numeric] vertical position for first point
    # @param x2 [Numeric] horizontal position for second point
    # @param y2 [Numeric] vertical position for second point
    #
    # @return [nil] nil
    #
    def line (x1, y1, x2, y2)
      @painter__.line x1, y1, x2, y2
      nil
    end

    # Draws a rectangle.
    #
    # @overload rect(a, b, c, d)
    # @overload rect(a, b, c, d, r)
    # @overload rect(a, b, c, d, tl, tr, br, bl)
    #
    # @param a  [Numeric] horizontal position of the shape by default
    # @param b  [Numeric] vertical position of the shape by default
    # @param c  [Numeric] width of the shape by default
    # @param d  [Numeric] height of the shape by default
    # @param r  [Numeric] radius for all corners
    # @param tl [Numeric] radius for top-left corner
    # @param tr [Numeric] radius for top-right corner
    # @param br [Numeric] radius for bottom-right corner
    # @param bl [Numeric] radius for bottom-left corner
    #
    # @return [nil] nil
    #
    def rect (a, b, c, d, *args)
      x, y, w, h = toXYWH__ @rectMode__, a, b, c, d
      case args.size
        when 0 then @painter__.rect x, y, w, h
        when 1 then @painter__.rect x, y, w, h, round: args[0]
        when 4 then @painter__.rect x, y, w, h, lt: args[0], rt: args[1], rb: args[2], lb: args[3]
        else raise ArgumentError # ToDo: refine error message
      end
      nil
    end

    # Draws an ellipse.
    #
    # @param a [Numeric] horizontal position of the shape
    # @param b [Numeric] vertical position of the shape
    # @param c [Numeric] width of the shape
    # @param d [Numeric] height of the shape
    #
    # @return [nil] nil
    #
    def ellipse (a, b, c, d)
      x, y, w, h = toXYWH__ @ellipseMode__, a, b, c, d
      @painter__.ellipse x, y, w, h
      nil
    end

    # Draws a circle.
    #
    # @param x      [Numeric] horizontal position of the shape
    # @param y      [Numeric] vertical position of the shape
    # @param extent [Numeric] width and height of the shape
    #
    # @return [nil] nil
    #
    def circle (x, y, extent)
      ellipse x, y, extent, extent
    end

    # Draws an arc.
    #
    # @param a     [Numeric] horizontal position of the shape
    # @param b     [Numeric] vertical position of the shape
    # @param c     [Numeric] width of the shape
    # @param d     [Numeric] height of the shape
    # @param start [Numeric] angle to start the arc
    # @param stop  [Numeric] angle to stop the arc
    #
    # @return [nil] nil
    #
    def arc (a, b, c, d, start, stop)
      x, y, w, h = toXYWH__ @ellipseMode__, a, b, c, d
      start      = toAngle__ start
      stop       = toAngle__ stop
      @painter__.ellipse x, y, w, h, from: start, to: stop
      nil
    end

    # Draws a square.
    #
    # @param x      [Numeric] horizontal position of the shape
    # @param y      [Numeric] vertical position of the shape
    # @param extent [Numeric] width and height of the shape
    #
    # @return [nil] nil
    #
    def square (x, y, extent)
      rect x, y, extent, extent
    end

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
    def triangle (x1, y1, x2, y2, x3, y3)
      @painter__.line x1, y1, x2, y2, x3, y3, loop: true
      nil
    end

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
    def quad (x1, y1, x2, y2, x3, y3, x4, y4)
      @painter__.line x1, y1, x2, y2, x3, y3, x4, y4, loop: true
      nil
    end

    # Draws a text.
    #
    # @overload text(str)
    # @overload text(str, x, y)
    #
    # @param str [String]  text to draw
    # @param x   [Numeric] horizontal position of the text
    # @param y   [Numeric] vertical position of the text
    #
    # @return [nil] nil
    #
    def text (str, x, y)
      @painter__.text str, x, y
      nil
    end

    # Draws an image.
    #
    # @overload image(img, x, y)
    # @overload image(img, x, y, w, h)
    #
    # @param img [Image] image to draw
    # @param x   [Numeric] horizontal position of the image
    # @param y   [Numeric] vertical position of the image
    # @param w   [Numeric] width of the image
    # @param h   [Numeric] height of the image
    #
    # @return [nil] nil
    #
    def image (img, x, y, w = nil, h = nil)
      w ||= img.width
      h ||= img.height
      @painter__.image img.internal, x, y, w, h
      nil
    end

    # Applies translation matrix to current transformation matrix.
    #
    # @param x [Numeric] horizontal transformation
    # @param y [Numeric] vertical transformation
    #
    # @return [nil] nil
    #
    def translate (x, y)
      @painter__.translate x, y
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
    def scale (x, y)
      @painter__.scale x, y
      nil
    end

    # Applies rotation matrix to current transformation matrix.
    #
    # @param angle [Numeric] angle for rotation
    #
    # @return [nil] nil
    #
    def rotate (angle)
      @painter__.rotate toAngle__ angle
      nil
    end

    # Pushes the current transformation matrix to stack.
    #
    # @return [nil] nil
    #
    def pushMatrix ()
      @matrixStack__.push @painter__.matrix
      nil
    end

    # Pops the current transformation matrix from stack.
    #
    # @return [nil] nil
    #
    def popMatrix ()
      raise "matrix stack underflow" if @matrixStack__.empty?
      @painter__.matrix = @matrixStack__.pop
      nil
    end

    # Reset current transformation matrix with identity matrix.
    #
    # @return [nil] nil
    #
    def resetMatrix ()
      @painter__.matrix = 1
      nil
    end

    # Save current style values to the style stack.
    #
    # @return [nil] nil
    #
    def pushStyle ()
      @styleStack__.push [
        @painter__.fill,
        @painter__.stroke,
        @painter__.stroke_width,
        @painter__.font,
        @hsbColor__,
        @colorMaxes__,
        @angleScale__,
        @rectMode__,
        @ellipseMode__
      ]
      nil
    end

    # Restore style values from the style stack.
    #
    # @return [nil] nil
    #
    def popStyle ()
      raise "style stack underflow" if @styleStack__.empty?
      @painter__.fill,
      @painter__.stroke,
      @painter__.stroke_width,
      @painter__.font,
      @hsbColor__,
      @colorMaxes__,
      @angleScale__,
      @rectMode__,
      @ellipseMode__ = @styleStack__.pop
      nil
    end

    # Save current styles and transformations to stack.
    #
    # @return [nil] nil
    #
    def push ()
      pushMatrix
      pushStyle
    end

    # Restore styles and transformations from stack.
    #
    # @return [nil] nil
    #
    def pop ()
      popMatrix
      popStyle
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
    def noise (x, y = 0, z = 0)
      Rays.perlin(x, y, z) / 2.0 + 0.5
    end

    # Loads image.
    #
    # @param filename  [String] file name to load image
    # @param extension [String] type of image to load (ex. 'png')
    #
    # @return [Image] loaded image object
    #
    def loadImage (filename, extension = nil)
      filename = getImage__ filename, extension if filename =~ %r|^https?://|
      Image.new Rays::Image.load filename
    end

    # @private
    private def getImage__ (uri, ext)
      ext ||= File.extname uri
      raise "unsupported image type -- #{ext}" unless ext =~ /^\.?(png)$/i

      tmpdir = Pathname(Dir.tmpdir) + Digest::SHA1.hexdigest(self.class.name)
      path   = tmpdir + Digest::SHA1.hexdigest(uri)
      path   = path.sub_ext ext

      unless path.file?
        p "getting #{uri}"
        URI.open uri do |input|
          tmpdir.mkdir unless tmpdir.directory?
          path.open('w') do |output|
            while buf = input.read(2 ** 16)
              output.write buf
            end
          end
        end
      end
      path.to_s
    end

  end# Processing


  # Image object.
  #
  class Processing::Image

    # Initialize image.
    #
    def initialize (image)
      @image = image
    end

    # Gets width of image.
    #
    # @return [Numeric] width of image
    #
    def width ()
      @image.width
    end

    # Gets height of image.
    #
    # @return [Numeric] height of image
    #
    def height ()
      @image.height
    end

    # Saves image to file.
    #
    # @param filename [String] file name to save image
    #
    def save (filename)
      @image.save filename
    end

    # @private
    def internal ()
      @image
    end

  end# Processing::Image


  # Font object.
  #
  class Processing::Font

    # Initialize font.
    #
    # @private
    #
    def initialize (font)
      @font = font
    end

    # Returns bounding box.
    #
    # @overload textBounds(str)
    # @overload textBounds(str, x, y)
    # @overload textBounds(str, x, y, fontSize)
    #
    # @param str      [String]  text to calculate bounding box
    # @param x        [Numeric] horizontal position of bounding box
    # @param y        [Numeric] vertical position of bounding box
    # @param fontSize [Numeric] font size
    #
    # @return [TextBounds] bounding box for text
    #
    def textBounds (str, x = 0, y = 0, fontSize = nil)
      f = fontSize ? Rays::Font.new(@font.name, fontSize) : @font
      TextBounds.new x, y, x + f.width(str), y + f.height
    end

  end# Processing::Font


  # Bounding box for text.
  #
  class Processing::TextBounds

    # Horizontal position
    #
    attr_reader :x

    # Vertical position
    #
    attr_reader :y

    # Width of bounding box
    #
    attr_reader :w

    # Height of bounding box
    #
    attr_reader :h

    # Initialize bouding box.
    #
    # @param x [Numeric] horizontal position
    # @param y [Numeric] vertical position
    # @param w [Numeric] width of bounding box
    # @param h [Numeric] height of bounding box
    #
    def initialize (x, y, w, h)
      @x, @y, @w, @h = x, y, w, h
    end

  end# Processing::TextBounds


end# RubySketch
