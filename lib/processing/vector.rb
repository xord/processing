module Processing


  # Vector class.
  #
  # @see https://processing.org/reference/PVector.html
  # @see https://p5js.org/reference/#/p5.Vector
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
    # @see https://processing.org/reference/PVector.html
    # @see https://p5js.org/reference/#/p5.Vector
    #
    def initialize(x = 0, y = 0, z = 0, context: nil)
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
    def initialize_copy(o)
      @point = o.getInternal__.dup
    end

    # Copy vector object
    #
    # @return [Vector] duplicated vector object
    #
    # @see https://processing.org/reference/PVector_copy_.html
    # @see https://p5js.org/reference/#/p5.Vector/copy
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
    # @see https://processing.org/reference/PVector_set_.html
    # @see https://p5js.org/reference/#/p5.Vector/set
    #
    def set(*args)
      initialize(*args)
      self
    end

    # Gets x value.
    #
    # @return [Numeric] x value of vector
    #
    # @see https://processing.org/reference/PVector_x.html
    # @see https://p5js.org/reference/#/p5.Vector/x
    #
    def x()
      @point.x
    end

    # Gets y value.
    #
    # @return [Numeric] y value of vector
    #
    # @see https://processing.org/reference/PVector_y.html
    # @see https://p5js.org/reference/#/p5.Vector/y
    #
    def y()
      @point.y
    end

    # Gets z value.
    #
    # @return [Numeric] z value of vector
    #
    # @see https://processing.org/reference/PVector_z.html
    # @see https://p5js.org/reference/#/p5.Vector/z
    #
    def z()
      @point.z
    end

    # Sets x value.
    #
    # @return [Numeric] x value of vector
    #
    # @see https://processing.org/reference/PVector_x.html
    # @see https://p5js.org/reference/#/p5.Vector/x
    #
    def x=(x)
      @point.x = x
    end

    # Sets y value.
    #
    # @return [Numeric] y value of vector
    #
    # @see https://processing.org/reference/PVector_y.html
    # @see https://p5js.org/reference/#/p5.Vector/y
    #
    def y=(y)
      @point.y = y
    end

    # Sets z value.
    #
    # @return [Numeric] z value of vector
    #
    # @see https://processing.org/reference/PVector_z.html
    # @see https://p5js.org/reference/#/p5.Vector/z
    #
    def z=(z)
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
    # @see https://processing.org/reference/PVector_lerp_.html
    # @see https://p5js.org/reference/#/p5.Vector/lerp
    #
    def lerp(*args, amount)
      v      = toVector__(*args)
      self.x = x + (v.x - x) * amount
      self.y = y + (v.y - y) * amount
      self.z = z + (v.z - z) * amount
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
    # @see https://processing.org/reference/PVector_lerp_.html
    # @see https://p5js.org/reference/#/p5.Vector/lerp
    #
    def self.lerp(v1, v2, amount)
      v1.dup.lerp v2, amount
    end

    # Returns x, y, z as an array
    #
    # @param n [Numeric] number of dimensions
    #
    # @return [Array] array of x, y, z
    #
    # @see https://processing.org/reference/PVector_array_.html
    # @see https://p5js.org/reference/#/p5.Vector/array
    #
    def array(n = 3)
      @point.to_a n
    end

    alias to_a array

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
    # @see https://processing.org/reference/PVector_add_.html
    # @see https://p5js.org/reference/#/p5.Vector/add
    #
    def add(*args)
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
    # @see https://processing.org/reference/PVector_sub_.html
    # @see https://p5js.org/reference/#/p5.Vector/sub
    #
    def sub(*args)
      @point -= toVector__(*args).getInternal__
      self
    end

    # Multiplies a vector by scalar.
    #
    # @param num [Numeric] number to multiply the vector
    #
    # @return [Vector] multiplied vector
    #
    # @see https://processing.org/reference/PVector_mult_.html
    # @see https://p5js.org/reference/#/p5.Vector/mult
    #
    def mult(num)
      @point *= num
      self
    end

    # Divides a vector by scalar.
    #
    # @param num [Numeric] number to divide the vector
    #
    # @return [Vector] divided vector
    #
    # @see https://processing.org/reference/PVector_div_.html
    # @see https://p5js.org/reference/#/p5.Vector/div
    #
    def div(num)
      @point /= num
      self
    end

    # Adds a vector.
    #
    # @param v [Vector] vector to add
    #
    # @return [Vector] added vector
    #
    # @see https://processing.org/reference/PVector_add_.html
    # @see https://p5js.org/reference/#/p5.Vector/add
    #
    def +(v)
      dup.add v
    end

    # Subtracts a vector.
    #
    # @param v [Vector] vector to subtract
    #
    # @return [Vector] subtracted vector
    #
    # @see https://processing.org/reference/PVector_sub_.html
    # @see https://p5js.org/reference/#/p5.Vector/sub
    #
    def -(v)
      dup.sub v
    end

    # Multiplies a vector by scalar.
    #
    # @param num [Numeric] number to multiply the vector
    #
    # @return [Vector] multiplied vector
    #
    # @see https://processing.org/reference/PVector_mult_.html
    # @see https://p5js.org/reference/#/p5.Vector/mult
    #
    def *(num)
      dup.mult num
    end

    # Divides a vector by scalar.
    #
    # @param num [Numeric] number to divide the vector
    #
    # @return [Vector] divided vector
    #
    # @see https://processing.org/reference/PVector_div_.html
    # @see https://p5js.org/reference/#/p5.Vector/div
    #
    def /(num)
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
    # @see https://processing.org/reference/PVector_add_.html
    # @see https://p5js.org/reference/#/p5.Vector/add
    #
    def self.add(v1, v2, target = nil)
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
    # @see https://processing.org/reference/PVector_sub_.html
    # @see https://p5js.org/reference/#/p5.Vector/sub
    #
    def self.sub(v1, v2, target = nil)
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
    # @see https://processing.org/reference/PVector_mult_.html
    # @see https://p5js.org/reference/#/p5.Vector/mult
    #
    def self.mult(v1, num, target = nil)
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
    # @see https://processing.org/reference/PVector_div_.html
    # @see https://p5js.org/reference/#/p5.Vector/div
    #
    def self.div(v1, num, target = nil)
      v = v1 / num
      target.set v if self === target
      v
    end

    # Returns the length of the vector.
    #
    # @return [Numeric] length
    #
    # @see https://processing.org/reference/PVector_mag_.html
    # @see https://p5js.org/reference/#/p5.Vector/mag
    #
    def mag()
      @point.length
    end

    # Returns squared length of the vector.
    #
    # @return [Numeric] squared length
    #
    # @see https://processing.org/reference/PVector_magSq_.html
    # @see https://p5js.org/reference/#/p5.Vector/magSq
    #
    def magSq()
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
    # @see https://processing.org/reference/PVector_setMag_.html
    # @see https://p5js.org/reference/#/p5.Vector/setMag
    #
    def setMag(target = nil, len)
      (target || self).set @point.normal * len
    end

    # Changes the length of the vector to 1.0.
    #
    # @param target [Vector] vector to store the normalized vector
    #
    # @return [Vector] normalized vector
    #
    # @see https://processing.org/reference/PVector_normalize_.html
    # @see https://p5js.org/reference/#/p5.Vector/normalize
    #
    def normalize(target = nil)
      (target || self).set @point.normal
    end

    # Changes the length of the vector if it's length is greater than the max value.
    #
    # @param max [Numeric] max length
    #
    # @return [Vector] new vector
    #
    # @see https://processing.org/reference/PVector_limit_.html
    # @see https://p5js.org/reference/#/p5.Vector/limit
    #
    def limit(max)
      setMag max if magSq > max ** 2
      self
    end

    # Returns the distance of 2 vectors.
    #
    # @param v [Vector] a vector
    #
    # @return [Numeric] the distance
    #
    # @see https://processing.org/reference/PVector_dist_.html
    # @see https://p5js.org/reference/#/p5.Vector/dist
    #
    def dist(v)
      (self - v).mag
    end

    # Returns the distance of 2 vectors.
    #
    # @param v1 [Vector] a vector
    # @param v2 [Vector] another vector
    #
    # @return [Numeric] the distance
    #
    # @see https://processing.org/reference/PVector_dist_.html
    # @see https://p5js.org/reference/#/p5.Vector/dist
    #
    def self.dist(v1, v2)
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
    # @see https://processing.org/reference/PVector_dot_.html
    # @see https://p5js.org/reference/#/p5.Vector/dot
    #
    def dot(*args)
      Rays::Point::dot getInternal__, toVector__(*args).getInternal__
    end

    # Calculates the dot product of 2 vectors.
    #
    # @param v1 [Vector] a vector
    # @param v2 [Vector] another vector
    #
    # @return [Numeric] result of dot product
    #
    # @see https://processing.org/reference/PVector_dot_.html
    # @see https://p5js.org/reference/#/p5.Vector/dot
    #
    def self.dot(v1, v2)
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
    # @see https://processing.org/reference/PVector_cross_.html
    # @see https://p5js.org/reference/#/p5.Vector/cross
    #
    def cross(a, *rest)
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
    # @see https://processing.org/reference/PVector_cross_.html
    # @see https://p5js.org/reference/#/p5.Vector/cross
    #
    def self.cross(v1, v2, target = nil)
      v1.cross v2, target
    end

    # Rotate the vector.
    #
    # @param angle [Numeric] the angle of rotation
    #
    # @return [Vector] rotated this object
    #
    # @see https://processing.org/reference/PVector_rotate_.html
    # @see https://p5js.org/reference/#/p5.Vector/rotate
    #
    def rotate(angle)
      deg = @context ?
        @context.toDegrees__(angle) : angle * GraphicsContext::RAD2DEG__
      @point.rotate! deg
      self
    end

    # Returns the angle of rotation for this vector.
    #
    # @return [Numeric] the angle in radians
    #
    # @see https://processing.org/reference/PVector_heading_.html
    # @see https://p5js.org/reference/#/p5.Vector/heading
    #
    def heading()
      Math.atan2 y, x
    end

    # Returns rotated new vector.
    #
    # @param angle  [Numeric] the angle of rotation
    # @param target [Vector]  vector to store new vector
    #
    # @return [Vector] rotated vector
    #
    # @see https://processing.org/reference/PVector_fromAngle_.html
    # @see https://p5js.org/reference/#/p5.Vector/fromAngle
    #
    def self.fromAngle(angle, target = nil)
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
    # @see https://processing.org/reference/PVector_angleBetween_.html
    # @see https://p5js.org/reference/#/p5.Vector/angleBetween
    #
    def self.angleBetween(v1, v2)
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
    # @see https://processing.org/reference/PVector_random2D_.html
    # @see https://p5js.org/reference/#/p5.Vector/random2D
    #
    def self.random2D(target = nil)
      v = self.new(1, 0, 0)
      v.getInternal__.rotate! rand 0.0...360.0
      target.set v if target
      v
    end

    # Returns a new 3D unit vector with a random direction.
    #
    # @param target [Vector] a vector to store the new vector
    #
    # @return [Vector] a random vector
    #
    # @see https://processing.org/reference/PVector_random3D_.html
    # @see https://p5js.org/reference/#/p5.Vector/random3D
    #
    def self.random3D(target = nil)
      angle = rand 0.0...(Math::PI * 2)
      z     = rand(-1.0..1.0)
      z2    = z ** 2
      x     = Math.sqrt(1.0 - z2) * Math.cos(angle)
      y     = Math.sqrt(1.0 - z2) * Math.sin(angle)
      v     = self.new x, y, z
      target.set v if target
      v
    end

    # Returns a string containing a human-readable representation of object.
    #
    # @return [String] inspected text
    #
    def inspect()
      "#<#{self.class.name}: #{x}, #{y}, #{z}>"
    end

    # @private
    def <=>(o)
      @point <=> o&.getInternal__
    end

    # @private
    def getInternal__()
      @point
    end

    # @private
    private def toVector__(*args)
      self.class === args.first ? args.first : self.class.new(*args)
    end

  end# Vector


end# Processing
