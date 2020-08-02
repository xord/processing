module RubySketch


  # Processing compatible API
  #
  module Processing


    # @private
    DEG2RAD__ = Math::PI / 180.0

    # @private
    RAD2DEG__ = 180.0 / Math::PI


    # Vector class.
    #
    class Vector

      include Comparable

      # Initialize vector object.
      #
      # @overload new()
      # @overload new(x)
      # @overload new(x, y)
      # @overload new(x, y, z)
      # @overload new(v)
      # @overload new(a)
      #
      # @param x [Numeric] x of vector
      # @param y [Numeric] y of vector
      # @param z [Numeric] z of vector
      # @param v [Vector]  vector object to copy
      # @param a [Array]   array like [x, y, z]
      #
      def initialize (x = 0, y = 0, z = 0, context: nil)
        @point = case x
          when Rays::Point then x.dup
          when Vector      then x.getInternal__.dup
          when Array       then Rays::Point.new x[0] || 0, x[1] || 0, x[2] || 0
          else                  Rays::Point.new x    || 0, y    || 0, z    || 0
          end
        @context = context || Context.context__
      end

      # Initializer for dup or clone
      #
      def initialize_copy (o)
        @point = o.getInternal__.dup
      end

      # Copy vector object
      #
      # @return [Vector] duplicated vector object
      #
      alias copy dup

      # Sets x, y and z.
      #
      # @overload set(x)
      # @overload set(x, y)
      # @overload set(x, y, z)
      # @overload set(v)
      # @overload set(a)
      #
      # @param x [Numeric] x of vector
      # @param y [Numeric] y of vector
      # @param z [Numeric] z of vector
      # @param v [Vector]  vector object to copy
      # @param a [Array]   array with x, y, z
      #
      # @return [nil] nil
      #
      def set (*args)
        initialize *args
        self
      end

      # Gets x value.
      #
      # @return [Numeric] x value of vector
      #
      def x ()
        @point.x
      end

      # Gets y value.
      #
      # @return [Numeric] y value of vector
      #
      def y ()
        @point.y
      end

      # Gets z value.
      #
      # @return [Numeric] z value of vector
      #
      def z ()
        @point.z
      end

      # Sets x value.
      #
      # @return [Numeric] x value of vector
      #
      def x= (x)
        @point.x = x
      end

      # Sets y value.
      #
      # @return [Numeric] y value of vector
      #
      def y= (y)
        @point.y = y
      end

      # Sets z value.
      #
      # @return [Numeric] z value of vector
      #
      def z= (z)
        @point.z = z
      end

      # Returns the interpolated vector between 2 vectors.
      #
      # @overload lerp(v, amount)
      # @overload lerp(x, y, amount)
      # @overload lerp(x, y, z, amount)
      #
      # @param v      [Vector]  vector to interpolate
      # @param x      [Numeric] x of vector to interpolate
      # @param y      [Numeric] y of vector to interpolate
      # @param z      [Numeric] z of vector to interpolate
      # @param amount [Numeric] amount to interpolate
      #
      # @return [Vector] interporated vector
      #
      def lerp (*args, amount)
        v      = toVector__ *args
        self.x = Context.lerp x, v.x, amount
        self.y = Context.lerp y, v.y, amount
        self.z = Context.lerp z, v.z, amount
        self
      end

      # Returns the interpolated vector between 2 vectors.
      #
      # @param v1     [Vector] vector to interpolate
      # @param v2     [Vector] vector to interpolate
      # @param amount [Numeric] amount to interpolate
      #
      # @return [Vector] interporated vector
      #
      def self.lerp (v1, v2, amount)
        v1.dup.lerp v2, amount
      end

      # Returns x, y, z as an array
      #
      # @return [Array] array of x, y, z
      #
      def array ()
        @point.to_a 3
      end

      # Adds a vector.
      #
      # @overload add(v)
      # @overload add(x, y)
      # @overload add(x, y, z)
      #
      # @param v [Vector] vector to add
      # @param x [Vector] x of vector to add
      # @param y [Vector] y of vector to add
      # @param z [Vector] z of vector to add
      #
      # @return [Vector] added vector
      #
      def add (*args)
        @point += toVector__(*args).getInternal__
        self
      end

      # Subtracts a vector.
      #
      # @overload sub(v)
      # @overload sub(x, y)
      # @overload sub(x, y, z)
      #
      # @param v [Vector] vector to subtract
      # @param x [Vector] x of vector to subtract
      # @param y [Vector] y of vector to subtract
      # @param z [Vector] z of vector to subtract
      #
      # @return [Vector] subtracted vector
      #
      def sub (*args)
        @point -= toVector__(*args).getInternal__
        self
      end

      # Multiplies a vector by scalar.
      #
      # @param num [Numeric] number to multiply the vector
      #
      # @return [Vector] multiplied vector
      #
      def mult (num)
        @point *= num
        self
      end

      # Divides a vector by scalar.
      #
      # @param num [Numeric] number to divide the vector
      #
      # @return [Vector] divided vector
      #
      def div (num)
        @point /= num
        self
      end

      # Adds a vector.
      #
      # @param v [Vector] vector to add
      #
      # @return [Vector] added vector
      #
      def + (v)
        dup.add v
      end

      # Subtracts a vector.
      #
      # @param v [Vector] vector to subtract
      #
      # @return [Vector] subtracted vector
      #
      def - (v)
        dup.sub v
      end

      # Multiplies a vector by scalar.
      #
      # @param num [Numeric] number to multiply the vector
      #
      # @return [Vector] multiplied vector
      #
      def * (num)
        dup.mult num
      end

      # Divides a vector by scalar.
      #
      # @param num [Numeric] number to divide the vector
      #
      # @return [Vector] divided vector
      #
      def / (num)
        dup.div num
      end

      # Adds 2 vectors.
      #
      # @overload add(v1, v2)
      # @overload add(v1, v2, target)
      #
      # @param v1     [Vector] a vector
      # @param v2     [Vector] another vector
      # @param target [Vector] vector to store added vector
      #
      # @return [Vector] added vector
      #
      def self.add (v1, v2, target = nil)
        v = v1 + v2
        target.set v if self === target
        v
      end

      # Subtracts 2 vectors.
      #
      # @overload sub(v1, v2)
      # @overload sub(v1, v2, target)
      #
      # @param v1     [Vector] a vector
      # @param v2     [Vector] another vector
      # @param target [Vector] vector to store subtracted vector
      #
      # @return [Vector] subtracted vector
      #
      def self.sub (v1, v2, target = nil)
        v = v1 - v2
        target.set v if self === target
        v
      end

      # Multiplies a vector by scalar.
      #
      # @overload mult(v, num)
      # @overload mult(v, num, target)
      #
      # @param v      [Vector]  a vector
      # @param num    [Numeric] number to multiply the vector
      # @param target [Vector]  vector to store multiplied vector
      #
      # @return [Vector] multiplied vector
      #
      def self.mult (v1, num, target = nil)
        v = v1 * num
        target.set v if self === target
        v
      end

      # Divides a vector by scalar.
      #
      # @overload div(v, num)
      # @overload div(v, num, target)
      #
      # @param v      [Vector]  a vector
      # @param num    [Numeric] number to divide the vector
      # @param target [Vector]  vector to store divided vector
      #
      # @return [Vector] divided vector
      #
      def self.div (v1, num, target = nil)
        v = v1 / num
        target.set v if self === target
        v
      end

      # Returns the length of the vector.
      #
      # @return [Numeric] length
      #
      def mag ()
        @point.length
      end

      # Returns squared length of the vector.
      #
      # @return [Numeric] squared length
      #
      def magSq ()
        Rays::Point::dot(@point, @point)
      end

      # Changes the length of the vector.
      #
      # @overload setMag(len)
      # @overload setMag(target, len)
      #
      # @param len    [Numeric] length of new vector
      # @param target [Vector]  vector to store new vector
      #
      # @return [Vector] vector with new length
      #
      def setMag (target = nil, len)
        (target || self).set @point.normal * len
      end

      # Changes the length of the vector to 1.0.
      #
      # @param target [Vector] vector to store the normalized vector
      #
      # @return [Vector] normalized vector
      #
      def normalize (target = nil)
        (target || self).set @point.normal
      end

      # Changes the length of the vector if it's length is greater than the max value.
      #
      # @param max [Numeric] max length
      #
      # @return [Vector] new vector
      #
      def limit (max)
        setMag max if magSq > max ** 2
        self
      end

      # Returns the distance of 2 vectors.
      #
      # @param v [Vector] a vector
      #
      # @return [Numeric] the distance
      #
      def dist (v)
        (self - v).mag
      end

      # Returns the distance of 2 vectors.
      #
      # @param v1 [Vector] a vector
      # @param v2 [Vector] another vector
      #
      # @return [Numeric] the distance
      #
      def self.dist (v1, v2)
        v1.dist v2
      end

      # Calculates the dot product of 2 vectors.
      #
      # @overload dot(v)
      # @overload dot(x, y)
      # @overload dot(x, y, z)
      #
      # @param v [Vector] a vector
      # @param x [Numeric] x of vector
      # @param y [Numeric] y of vector
      # @param z [Numeric] z of vector
      #
      # @return [Numeric] result of dot product
      #
      def dot (*args)
        Rays::Point::dot getInternal__, toVector__(*args).getInternal__
      end

      # Calculates the dot product of 2 vectors.
      #
      # @param v1 [Vector] a vector
      # @param v2 [Vector] another vector
      #
      # @return [Numeric] result of dot product
      #
      def self.dot (v1, v2)
        v1.dot v2
      end

      # Calculates the cross product of 2 vectors.
      #
      # @overload cross(v)
      # @overload cross(x, y)
      # @overload cross(x, y, z)
      #
      # @param v [Vector] a vector
      # @param x [Numeric] x of vector
      # @param y [Numeric] y of vector
      # @param z [Numeric] z of vector
      #
      # @return [Numeric] result of cross product
      #
      def cross (a, *rest)
        target = self.class === rest.last ? rest.pop : nil
        v = self.class.new Rays::Point::cross getInternal__, toVector__(a, *rest).getInternal__
        target.set v if self.class === target
        v
      end

      # Calculates the cross product of 2 vectors.
      #
      # @param v1 [Vector] a vector
      # @param v2 [Vector] another vector
      #
      # @return [Numeric] result of cross product
      #
      def self.cross (v1, v2, target = nil)
        v1.cross v2, target
      end

      # Rotate the vector.
      #
      # @param angle [Numeric] the angle of rotation
      #
      # @return [Vector] rotated this object
      #
      def rotate (angle)
        angle = @context ? @context.toAngle__(angle) : angle * RAD2DEG__
        @point.rotate! angle
        self
      end

      # Returns the angle of rotation for this vector.
      #
      # @return [Numeric] the angle in radians
      #
      def heading ()
        Math.atan2 y, x
      end

      # Returns rotated new vector.
      #
      # @param angle  [Numeric] the angle of rotation
      # @param target [Vector]  vector to store new vector
      #
      # @return [Vector] rotated vector
      #
      def self.fromAngle (angle, target = nil)
        v = self.new(1, 0, 0).rotate(angle)
        target.set v if target
        v
      end

      # Returns angle between 2 vectors.
      #
      # @param v1 [Vector] a vector
      # @param v2 [Vector] another vector
      #
      # @return [Numeric] angle in radians
      #
      def self.angleBetween (v1, v2)
        x1, y1, z1 = v1.array
        x2, y2, z2 = v2.array
        return 0 if (x1 == 0 && y1 == 0 && z1 == 0) || (x2 == 0 && y2 == 0 && z2 == 0)

        x = dot(v1, v2) / (v1.mag * v2.mag)
        return Math::PI if x <= -1
        return 0        if x >= 1
        return Math.acos x
      end

      # Returns a new 2D unit vector with a random direction.
      #
      # @param target [Vector] a vector to store the new vector
      #
      # @return [Vector] a random vector
      #
      def self.random2D (target = nil)
        v = self.fromAngle rand 0.0...(Math::PI * 2)
        target.set v if target
        v
      end

      # Returns a new 3D unit vector with a random direction.
      #
      # @param target [Vector] a vector to store the new vector
      #
      # @return [Vector] a random vector
      #
      def self.random3D (target = nil)
        angle = rand 0.0...(Math::PI * 2)
        z     = rand -1.0..1.0
        z2    = z ** 2
        x     = Math.sqrt(1.0 - z2) * Math.cos(angle)
        y     = Math.sqrt(1.0 - z2) * Math.sin(angle)
        v     = self.new x, y, z
        target.set v if target
        v
      end

      # @private
      def inspect ()
        "<##{self.class.name} #{x}, #{y}, #{z}>"
      end

      # @private
      def <=> (o)
        @point <=> o.getInternal__
      end

      # @private
      protected def getInternal__ ()
        @point
      end

      # @private
      private def toVector__ (*args)
        self.class === args.first ? args.first : self.class.new(*args)
      end

    end# Vector


    # Image object.
    #
    class Image

      # @private
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

      # Resizes image.
      #
      # @param width  [Numeric] width for resized image
      # @param height [Numeric] height for resized image
      #
      # @return [nil] nil
      #
      def resize (width, height)
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
      def copy (img = nil, sx, sy, sw, sh, dx, dy, dw, dh)
        img ||= self
        @image.paint do |painter|
          painter.image img.getInternal__, sx, sy, sw, sh, dx, dy, dw, dh
        end
      end

      # Saves image to file.
      #
      # @param filename [String] file name to save image
      #
      def save (filename)
        @image.save filename
      end

      # @private
      def getInternal__ ()
        @image
      end

    end# Image


    # Font object.
    #
    class Font

      # @private
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

    end# Font


    # Bounding box for text.
    #
    class TextBounds

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

      # @private
      def initialize (x, y, w, h)
        @x, @y, @w, @h = x, y, w, h
      end

    end# TextBounds


    # Touch object.
    #
    class Touch

      # Horizontal position of touch
      #
      attr_reader :x

      # Vertical position of touch
      #
      attr_reader :y

      # @private
      def initialize (x, y)
        @x, @y = x, y
      end

      def id ()
        raise NotImplementedError
      end

    end# Touch


    # Drawing context
    #
    module GraphicsContext

      Vector = Processing::Vector

      # PI / 2
      #
      HALF_PI    = Math::PI / 2

      # PI / 4
      #
      QUARTER_PI = Math::PI / 4

      # PI * 2
      #
      TWO_PI     = Math::PI * 2

      # PI * 2
      #
      TAU        = Math::PI * 2

      # RGB mode for colorMode().
      #
      RGB = :RGB

      # HSB mode for colorMode().
      #
      HSB = :HSB

      # Radian mode for angleMode().
      #
      RADIANS = :RADIANS

      # Degree mode for angleMode().
      #
      DEGREES = :DEGREES

      # Mode for rectMode(), ellipseMode() and imageMode().
      #
      CORNER  = :CORNER

      # Mode for rectMode(), ellipseMode() and imageMode().
      #
      CORNERS = :CORNERS

      # Mode for rectMode(), ellipseMode(), imageMode() and textAlign().
      #
      CENTER  = :CENTER

      # Mode for rectMode() and ellipseMode().
      #
      RADIUS  = :RADIUS

      # Mode for textAlign().
      LEFT     = :LEFT

      # Mode for textAlign().
      RIGHT    = :RIGHT

      # Mode for textAlign().
      TOP      = :TOP

      # Mode for textAlign().
      BOTTOM   = :BOTTOM

      # Mode for textAlign().
      BASELINE = :BASELINE

      # Mode for strokeCap().
      #
      BUTT   = :butt

      # Mode for strokeJoin().
      #
      MITER  = :miter

      # Mode for strokeCap() and strokeJoin().
      #
      ROUND  = :round

      # Mode for strokeCap() and strokeJoin().
      #
      SQUARE = :square

      def setup__ (painter)
        @painter__             = painter
        @painter__.miter_limit = 10

        @drawing       = false
        @hsbColor__    = false
        @colorMaxes__  = [1.0] * 4
        @angleScale__  = 1.0
        @rectMode__    = nil
        @ellipseMode__ = nil
        @imageMode__   = nil
        @textAlignH__  = nil
        @textAlignV__  = nil
        @matrixStack__ = []
        @styleStack__  = []

        colorMode   RGB, 255
        angleMode   RADIANS
        rectMode    CORNER
        ellipseMode CENTER
        imageMode   CORNER
        textAlign   LEFT

        fill 255
        stroke 0
      end

      def beginDraw ()
        @matrixStack__.clear
        @styleStack__.clear
        @drawing = true
      end

      def endDraw ()
        @drawing = false
      end

      def width ()
        @image__.width
      end

      def height ()
        @image__.height
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
        mode = mode.upcase.to_sym
        raise ArgumentError, "invalid color mode: #{mode}" unless [RGB, HSB].include?(mode)
        raise ArgumentError unless [0, 1, 3, 4].include?(maxes.size)

        @hsbColor__ = mode == HSB
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
        @angleScale__ = case mode.upcase.to_sym
          when RADIANS then RAD2DEG__
          when DEGREES then 1.0
          else raise ArgumentError, "invalid angle mode: #{mode}"
          end
        nil
      end

      # @private
      def toAngle__ (angle)
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

      # Sets image mode. Default is CORNER.
      #
      # CORNER  -> image(img, left, top, width, height)
      # CORNERS -> image(img, left, top, right, bottom)
      # CENTER  -> image(img, center_x, center_y, width, height)
      #
      # @param mode [CORNER, CORNERS, CENTER]
      #
      # @return [nil] nil
      #
      def imageMode (mode)
        @imageMode__ = mode
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

      # Sets stroke cap mode.
      #
      # @param cap [BUTT, ROUND, SQUARE]
      #
      # @return [nil] nil
      #
      def strokeCap (cap)
        @painter__.stroke_cap cap
        nil
      end

      # Sets stroke join mode.
      #
      # @param join [MITER, ROUND, SQUARE]
      #
      # @return [nil] nil
      #
      def strokeJoin (join)
        @painter__.stroke_join join
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
      # @param size [Numeric] font size (max 256)
      #
      # @return [Font] current font
      #
      def textFont (name = nil, size = nil)
        setFont__ name, size if name || size
        Font.new @painter__.font
      end

      # Sets text size.
      #
      # @param size [Numeric] font size (max 256)
      #
      # @return [nil] nil
      #
      def textSize (size)
        setFont__ @painter__.font.name, size
        nil
      end

      def textWidth (str)
        @painter__.font.width str
      end

      def textAscent ()
        @painter__.font.ascent
      end

      def textDescent ()
        @painter__.font.descent
      end

      def textAlign (horizontal, vertical = BASELINE)
        @textAlignH__ = horizontal
        @textAlignV__ = vertical
      end

      # @private
      def setFont__ (name, size)
        size = 256 if size && size > 256
        @painter__.font name, size
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
        assertDrawing__
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

      # Draws a point.
      #
      # @param x [Numeric] horizontal position
      # @param y [Numeric] vertical position
      #
      # @return [nil] nil
      #
      def point (x, y)
        assertDrawing__
        w = @painter__.stroke_width
        w = 1 if w == 0
        @painter__.ellipse x - (w / 2.0), y - (w / 2.0), w, w
        nil
      end

      # Draws a line.
      #
      # @param x1 [Numeric] horizontal position of first point
      # @param y1 [Numeric] vertical position of first point
      # @param x2 [Numeric] horizontal position of second point
      # @param y2 [Numeric] vertical position of second point
      #
      # @return [nil] nil
      #
      def line (x1, y1, x2, y2)
        assertDrawing__
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
        assertDrawing__
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
        assertDrawing__
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
        assertDrawing__
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
        assertDrawing__
        @painter__.line x1, y1, x2, y2, x3, y3, x4, y4, loop: true
        nil
      end

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
      def curve (cx1, cy1, x1, y1, x2, y2, cx2, cy2)
        assertDrawing__
        @painter__.curve cx1, cy1, x1, y1, x2, y2, cx2, cy2
        nil
      end

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
      def bezier (x1, y1, cx1, cy1, cx2, cy2, x2, y2)
        assertDrawing__
        @painter__.bezier x1, y1, cx1, cy1, cx2, cy2, x2, y2
        nil
      end

      # Draws a text.
      #
      # @overload text(str)
      # @overload text(str, x, y)
      # @overload text(str, a, b, c, d)
      #
      # @param str [String]  text to draw
      # @param x   [Numeric] horizontal position of the text
      # @param y   [Numeric] vertical position of the text
      # @param a   [Numeric] equivalent to parameters of the rect(), see rectMode()
      # @param b   [Numeric] equivalent to parameters of the rect(), see rectMode()
      # @param c   [Numeric] equivalent to parameters of the rect(), see rectMode()
      # @param d   [Numeric] equivalent to parameters of the rect(), see rectMode()
      #
      # @return [nil] nil
      #
      def text (str, x, y, x2 = nil, y2 = nil)
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

      # Draws an image.
      #
      # @overload image(img, a, b)
      # @overload image(img, a, b, c, d)
      #
      # @param img [Image] image to draw
      # @param a   [Numeric] horizontal position of the image
      # @param b   [Numeric] vertical position of the image
      # @param c   [Numeric] width of the image
      # @param d   [Numeric] height of the image
      #
      # @return [nil] nil
      #
      def image (img, a, b, c = nil, d = nil)
        assertDrawing__
        x, y, w, h = toXYWH__ @imageMode__, a, b, c || img.width, d || img.height
        @painter__.image img.getInternal__, x, y, w, h
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
      def copy (img = nil, sx, sy, sw, sh, dx, dy, dw, dh)
        assertDrawing__
        src = img&.getInternal__ || @window__.canvas
        @painter__.image src, sx, sy, sw, sh, dx, dy, dw, dh
      end

      # Applies translation matrix to current transformation matrix.
      #
      # @param x [Numeric] horizontal transformation
      # @param y [Numeric] vertical transformation
      #
      # @return [nil] nil
      #
      def translate (x, y)
        assertDrawing__
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
        assertDrawing__
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
        assertDrawing__
        @painter__.rotate toAngle__ angle
        nil
      end

      # Pushes the current transformation matrix to stack.
      #
      # @return [nil] nil
      #
      def pushMatrix (&block)
        assertDrawing__
        @matrixStack__.push @painter__.matrix
        if block
          block.call
          popMatrix
        end
        nil
      end

      # Pops the current transformation matrix from stack.
      #
      # @return [nil] nil
      #
      def popMatrix ()
        assertDrawing__
        raise "matrix stack underflow" if @matrixStack__.empty?
        @painter__.matrix = @matrixStack__.pop
        nil
      end

      # Reset current transformation matrix with identity matrix.
      #
      # @return [nil] nil
      #
      def resetMatrix ()
        assertDrawing__
        @painter__.matrix = 1
        nil
      end

      # Save current style values to the style stack.
      #
      # @return [nil] nil
      #
      def pushStyle (&block)
        assertDrawing__
        @styleStack__.push [
          @painter__.fill,
          @painter__.stroke,
          @painter__.stroke_width,
          @painter__.stroke_cap,
          @painter__.stroke_join,
          @painter__.font,
          @hsbColor__,
          @colorMaxes__,
          @angleScale__,
          @rectMode__,
          @ellipseMode__,
          @imageMode__
        ]
        if block
          block.call
          popStyle
        end
        nil
      end

      # Restore style values from the style stack.
      #
      # @return [nil] nil
      #
      def popStyle ()
        assertDrawing__
        raise "style stack underflow" if @styleStack__.empty?
        @painter__.fill,
        @painter__.stroke,
        @painter__.stroke_width,
        @painter__.stroke_cap,
        @painter__.stroke_join,
        @painter__.font,
        @hsbColor__,
        @colorMaxes__,
        @angleScale__,
        @rectMode__,
        @ellipseMode__,
        @imageMode__ = @styleStack__.pop
        nil
      end

      # Save current styles and transformations to stack.
      #
      # @return [nil] nil
      #
      def push (&block)
        pushMatrix
        pushStyle
        if block
          block.call
          pop
        end
      end

      # Restore styles and transformations from stack.
      #
      # @return [nil] nil
      #
      def pop ()
        popMatrix
        popStyle
      end

      # @private
      private def getInternal__ ()
        @image__
      end

      # @private
      private def assertDrawing__ ()
        raise "call beginDraw() before drawing" unless @drawing
      end

    end# GraphicsContext


    # Draws graphics into an offscreen buffer
    #
    class Graphics

      include GraphicsContext

      def initialize (width, height)
        @image__ = Rays::Image.new width, height
        setup__ @image__.painter
      end

      def beginDraw ()
        @painter__.__send__ :begin_paint
        super
        push
      end

      def endDraw ()
        pop
        super
        @painter__.__send__ :end_paint
      end

    end# Graphics


    # Processing context
    #
    module Context

      include GraphicsContext, Math

      @@context__ = nil

      def self.context__ ()
        @@context__
      end

      # @private
      def setup__ (window)
        @@context__ = self

        @window__ = window
        @image__  = @window__.canvas
        super @window__.canvas_painter.paint {background 0.8}

        @loop__         = true
        @redraw__       = false
        @frameCount__   = 0
        @mousePos__     =
        @mousePrevPos__ = Rays::Point.new 0
        @mousePressed__ = false
        @touches__      = []

        @window__.before_draw = proc {beginDraw}
        @window__.after_draw  = proc {endDraw}

        drawFrame = -> {
          @image__   = @window__.canvas
          @painter__ = @window__.canvas_painter
          begin
            push
            @drawBlock__.call if @drawBlock__
          ensure
            pop
            @frameCount__ += 1
          end
        }

        @window__.draw = proc do |e|
          if @loop__ || @redraw__
            @redraw__ = false
            drawFrame.call
          end
          @mousePrevPos__ = @mousePos__
        end

        updatePointerStates = -> event, pressed = nil {
          @mousePos__     = event.pos
          @mousePressed__ = pressed if pressed != nil
          @touches__      = event.positions.map {|pos| Touch.new pos.x, pos.y}
        }

        @window__.pointer_down = proc do |e|
          updatePointerStates.call e, true
          (@touchStartedBlock__ || @mousePressedBlock__)&.call
        end

        @window__.pointer_up = proc do |e|
          updatePointerStates.call e, false
          (@touchEndedBlock__ || @mouseReleasedBlock__)&.call
        end

        @window__.pointer_move = proc do |e|
          updatePointerStates.call e
          (@touchMovedBlock__ || @mouseMovedBlock__)&.call
        end

        @window__.pointer_drag = proc do |e|
          updatePointerStates.call e
          (@touchMovedBlock__ || @mouseDraggedBlock__)&.call
        end
      end

      # Define setup block.
      #
      def setup (&block)
        @window__.setup = block
        nil
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

      def mousePressed (&block)
        @mousePressedBlock__ = block if block
        @mousePressed__
      end

      def mouseReleased (&block)
        @mouseReleasedBlock__ = block if block
        nil
      end

      def mouseMoved (&block)
        @mouseMovedBlock__ = block if block
        nil
      end

      def mouseDragged (&block)
        @mouseDraggedBlock__ = block if block
        nil
      end

      def touchStarted (&block)
        @touchStartedBlock__ = block if block
        nil
      end

      def touchEnded (&block)
        @touchEndedBlock__ = block if block
        nil
      end

      def touchMoved (&block)
        @touchMovedBlock__ = block if block
        nil
      end

      # @private
      private def size__ (width, height)
        raise 'size() must be called on startup or setup block' if @started__

        @painter__.__send__ :end_paint
        @window__.__send__ :reset_canvas, width, height
        @painter__.__send__ :begin_paint

        @auto_resize__ = false
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
        @mousePos__.x
      end

      # Returns mouse y position
      #
      # @return [Numeric] vertical position of mouse
      #
      def mouseY ()
        @mousePos__.y
      end

      # Returns mouse x position in previous frame
      #
      # @return [Numeric] horizontal position of mouse
      #
      def pmouseX ()
        @mousePrevPos__.x
      end

      # Returns mouse y position in previous frame
      #
      # @return [Numeric] vertical position of mouse
      #
      def pmouseY ()
        @mousePrevPos__.y
      end

      # Returns array of touches
      #
      # @return [Array] Touch objects
      #
      def touches ()
        @touches__
      end

      # Enables calling draw block on every frame.
      #
      # @return [nil] nil
      #
      def loop ()
        @loop__ = true
      end

      # Disables calling draw block on every frame.
      #
      # @return [nil] nil
      #
      def noLoop ()
        @loop__ = false
      end

      # Calls draw block to redraw frame.
      #
      # @return [nil] nil
      #
      def redraw ()
        @redraw__ = true
      end

      module_function

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
      def dist (*args)
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

      # Returns the sine of an angle.
      #
      # @param angle [Numeric] angle in radians
      #
      # @return [Numeric] the sine
      #
      def sin (angle)
        Math.sin angle
      end

      # Returns the cosine of an angle.
      #
      # @param angle [Numeric] angle in radians
      #
      # @return [Numeric] the cosine
      #
      def cos (angle)
        Math.cos angle
      end

      # Returns the ratio of the sine and cosine of an angle.
      #
      # @param angle [Numeric] angle in radians
      #
      # @return [Numeric] the tangent
      #
      def tan (angle)
        Math.tan angle
      end

      # Returns the inverse of sin().
      #
      # @param value [Numeric] value for calculation
      #
      # @return [Numeric] the arc sine
      #
      def asin (value)
        Math.asin value
      end

      # Returns the inverse of cos().
      #
      # @param value [Numeric] value for calculation
      #
      # @return [Numeric] the arc cosine
      #
      def acos (value)
        Math.acos value
      end

      # Returns the inverse of tan().
      #
      # @param value [Numeric] value for valculation
      #
      # @return [Numeric] the arc tangent
      #
      def atan (value)
        Math.atan value
      end

      # Returns the angle from a specified point.
      #
      # @param y [Numeric] y of the point
      # @param x [Numeric] x of the point
      #
      # @return [Numeric] the angle in radians
      #
      def atan2 (y, x)
        Math.atan2 y, x
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

      # Returns a random number in range low...high
      #
      # @overload random(high)
      # @overload random(low, high)
      #
      # @param low  [Numeric] lower limit
      # @param high [Numeric] upper limit
      #
      # @return [Float] random number
      #
      def random (low = nil, high)
        rand (low || 0).to_f...high.to_f
      end

      # Creates a new vector.
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
      def createVector (*args)
        Vector.new *args
      end

      # Creates a new off-screen graphics context object.
      #
      # @param width  [Numeric] width of graphics image
      # @param height [Numeric] height of graphics image
      #
      # @return [Graphics] graphics object
      #
      def createGraphics (width, height)
        Graphics.new width, height
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

    end# Context


  end# Processing


end# RubySketch
