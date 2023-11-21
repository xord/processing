module Processing


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
    def set(*args)
      initialize(*args)
      self
    end

    # Gets x value.
    #
    # @return [Numeric] x value of vector
    #
    def x()
      @point.x
    end

    # Gets y value.
    #
    # @return [Numeric] y value of vector
    #
    def y()
      @point.y
    end

    # Gets z value.
    #
    # @return [Numeric] z value of vector
    #
    def z()
      @point.z
    end

    # Sets x value.
    #
    # @return [Numeric] x value of vector
    #
    def x=(x)
      @point.x = x
    end

    # Sets y value.
    #
    # @return [Numeric] y value of vector
    #
    def y=(y)
      @point.y = y
    end

    # Sets z value.
    #
    # @return [Numeric] z value of vector
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
    def self.lerp(v1, v2, amount)
      v1.dup.lerp v2, amount
    end

    # Returns x, y, z as an array
    #
    # @param n [Numeric] number of dimensions
    #
    # @return [Array] array of x, y, z
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
    def +(v)
      dup.add v
    end

    # Subtracts a vector.
    #
    # @param v [Vector] vector to subtract
    #
    # @return [Vector] subtracted vector
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
    def *(num)
      dup.mult num
    end

    # Divides a vector by scalar.
    #
    # @param num [Numeric] number to divide the vector
    #
    # @return [Vector] divided vector
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
    def self.div(v1, num, target = nil)
      v = v1 / num
      target.set v if self === target
      v
    end

    # Returns the length of the vector.
    #
    # @return [Numeric] length
    #
    def mag()
      @point.length
    end

    # Returns squared length of the vector.
    #
    # @return [Numeric] squared length
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
    def setMag(target = nil, len)
      (target || self).set @point.normal * len
    end

    # Changes the length of the vector to 1.0.
    #
    # @param target [Vector] vector to store the normalized vector
    #
    # @return [Vector] normalized vector
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
    def self.cross(v1, v2, target = nil)
      v1.cross v2, target
    end

    # Rotate the vector.
    #
    # @param angle [Numeric] the angle of rotation
    #
    # @return [Vector] rotated this object
    #
    def rotate(angle)
      @point.rotate! @context.toDegrees__(angle)
      self
    end

    # Returns the angle of rotation for this vector.
    #
    # @return [Numeric] the angle in radians
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
