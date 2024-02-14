module Processing


  # Shape object.
  #
  # @see https://processing.org/reference/PShape.html
  #
  class Shape

    # @private
    def initialize(polygon = nil, children = nil, context: nil)
      @polygon, @children      = polygon, children
      @context                 = context || Context.context__
      @visible, @fill, @matrix = true, nil, nil
      @type = @points = @curvePoints = @colors = @texcoords = @close = nil
      @contours = @contourPoints = @contourColors = @contourTexCoords = nil
    end

    # Gets width of shape.
    #
    # @return [Numeric] width of shape
    #
    # @see https://processing.org/reference/PShape_width.html
    #
    def width()
      polygon = getInternal__ or return 0
      (@bounds ||= polygon.bounds).width
    end

    # Gets height of shape.
    #
    # @return [Numeric] height of shape
    #
    # @see https://processing.org/reference/PShape_height.html
    #
    def height()
      polygon = getInternal__ or return 0
      (@bounds ||= polygon.bounds).height
    end

    alias w width
    alias h height

    # Returns whether the shape is visible or not.
    #
    # @return [Boolean] visible or not
    #
    # @see https://processing.org/reference/PShape_isVisible_.html
    #
    def isVisible()
      @visible
    end

    alias visible? isVisible

    # Sets whether to display the shape or not.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_setVisible_.html
    #
    def setVisible(visible)
      @visible = !!visible
      nil
    end

    # Starts shape data definition.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_beginShape_.html
    #
    def beginShape(type = nil)
      raise "beginShape() cannot be called twice" if drawingShape__
      @type        = type
      @points    ||= []
      @curvePoints = []
      @colors    ||= []
      @texcoords ||= []
      @close       = nil
      @contours  ||= []
      clearCache__
      nil
    end

    # Ends shape data definition.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_endShape_.html
    #
    def endShape(close = nil)
      raise "endShape() must be called after beginShape()" unless drawingShape__
      @close = close == GraphicsContext::CLOSE || @contours.size > 0
      if @close && @curvePoints.size >= 8
        x, y = @curvePoints[0, 2]
        2.times {curveVertex x, y}
      end
      @curvePoints = nil
      nil
    end

    # Starts a new contour definition.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_beginContour_.html
    #
    def beginContour()
      raise "beginContour() must be called after beginShape()" unless drawingShape__
      @contourPoints, @contourColors, @contourTexCoords = [], [], []
      nil
    end

    # Ends contour definition.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_endContour_.html
    #
    def endContour()
      raise "endContour() must be called after beginContour()" unless drawingContour__
      @contours << Rays::Polyline.new(
        *@contourPoints, colors: @contourColors, texcoords: @contourTexCoords,
        loop: true, hole: true)
      @contoursPoints = @contoursColors = @contoursTexCoords = nil
      nil
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
      raise "vertex() must be called after beginShape()" unless drawingShape__
      raise "Either 'u' or 'v' is missing" if (u == nil) != (v == nil)
      u   ||= x
      v   ||= y
      color = @fill || @context.getFill__
      if drawingContour__
        @contourPoints    << x << y
        @contourColors    << color
        @contourTexCoords << u << v
      else
        @points    << x << y
        @colors    << color
        @texcoords << u << v
      end
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
      raise "curveVertex() must be called after beginShape()" unless drawingShape__
      @curvePoints << x << y
      if @curvePoints.size >= 8
        Rays::Polygon.curve(*@curvePoints[-8, 8])
          .first.to_a.tap {|a| a.shift if @curvePoints.size > 8}
          .each {|p| vertex p.x, p.y}
      end
      nil
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
      raise "bezierVertex() must be called after beginShape()" unless drawingShape__
      x1, y1 = @points[-2, 2]
      raise "vertex() is required before calling bezierVertex()" unless x1 && y1
      Rays::Polygon.bezier(x1, y1, x2, y2, x3, y3, x4, y4)
        .first.to_a.tap {|a| a.shift}
        .each {|p| vertex p.x, p.y}
      nil
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
      x1, y1 = @points[-2, 2]
      raise "vertex() is required before calling quadraticVertex()" unless x1 && y1
      bezierVertex(
        x1 + (cx - x1) * 2.0 / 3.0, y1 + (cy - y1) * 2.0 / 3.0,
        x3 + (cx - x3) * 2.0 / 3.0, y3 + (cy - y3) * 2.0 / 3.0,
        x3,                         y3)
      nil
    end

    # @private
    def drawingShape__()
      @curvePoints
    end

    # @private
    def drawingContour__()
      @contourPoints
    end

    # Sets fill color.
    #
    # @overload fill(gray)
    # @overload fill(gray, alpha)
    # @overload fill(r, g, b)
    # @overload fill(r, g, b, alpha)
    #
    # @param gray  [Integer]  gray value (0..255)
    # @param r     [Integer]   red value (0..255)
    # @param g     [Integer] green value (0..255)
    # @param b     [Integer]  blue value (0..255)
    # @param alpha [Integer] alpha value (0..255)
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/fill_.html
    # @see https://p5js.org/reference/#/p5/fill
    #
    def fill(*args)
      @fill = @context.rawColor__(*args)
      nil
    end

    # Sets the vertex at the index position.
    #
    # @overload setVertex(index, x, y)
    # @overload setVertex(index, vec)
    #
    # @param index [Integer] the index fo the vertex
    # @param x     [Numeric] x position of the vertex
    # @param y     [Numeric] y position of the vertex
    # @param vec   [Vector]  position for the vertex
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_setVertex_.html
    #
    def setVertex(index, point)
      return nil unless @points && @points[index * 2, 2]&.size == 2
      @points[index * 2, 2] = [point.x, point.y]
      nil
    end

    # Returns the vertex at the index position.
    #
    # @param index [Integer] the index fo the vertex
    #
    # @return [Vector] the vertex position
    #
    # @see https://processing.org/reference/PShape_getVertex_.html
    #
    def getVertex(index)
      return nil unless @points
      point = @points[index * 2, 2]
      return nil unless point&.size == 2
      @context.createVector(*point)
    end

    # Returns the total number of vertices.
    #
    # @return [Integer] vertex count
    #
    # @see https://processing.org/reference/PShape_getVertexCount_.html
    #
    def getVertexCount()
      return 0 unless @points
      @points.size / 2
    end

    # Sets the fill color.
    #
    # @overload fill(gray)
    # @overload fill(gray, alpha)
    # @overload fill(r, g, b)
    # @overload fill(r, g, b, alpha)
    #
    # @param gray  [Integer]  gray value (0..255)
    # @param r     [Integer]   red value (0..255)
    # @param g     [Integer] green value (0..255)
    # @param b     [Integer]  blue value (0..255)
    # @param alpha [Integer] alpha value (0..255)
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_setFill_.html
    #
    def setFill(*args)
      color = @context.rawColor__(*args)
      count = getVertexCount
      if count > 0
        if @colors
          @colors.fill color
        else
          @colors = [color] * count
        end
        clearCache__
      elsif @polygon
        @polygon = @polygon.transform do |polylines|
          polylines.map {|pl| pl.with colors: pl.points.map {color}}
        end
      end
    end

    # Adds a new child shape.
    #
    # @param child [Shape]   child shape
    # @param index [Integer] insert position
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_addChild_.html
    #
    def addChild(child, index = -1)
      return unless @children
      if index < 0
        @children.push child
      else
        @children.insert index, child
      end
      nil
    end

    # Returns a child shape at the index position.
    #
    # @param index [Integer] child index
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_getChild_.html
    #
    def getChild(index)
      @children&.[](index)
    end

    # Returns the number of children.
    #
    # @return [Integer] child count
    #
    # @see https://processing.org/reference/PShape_getChildCount_.html
    #
    def getChildCount()
      @children&.size || 0
    end

    # Applies translation matrix to the shape.
    #
    # @overload translate(x, y)
    # @overload translate(x, y, z)
    #
    # @param x [Numeric] left/right translation
    # @param y [Numeric] up/down translation
    # @param z [Numeric] forward/backward translation
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_translate_.html
    #
    def translate(x, y, z = 0)
      matrix__.translate! x, y, z
      nil
    end

    # Applies rotation matrix to the shape.
    #
    # @param angle [Numeric] angle for rotation
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_rotate_.html
    #
    def rotate(angle)
      matrix__.rotate! @context.toDegrees__(angle)
      nil
    end

    # Applies scale matrix to the shape.
    #
    # @overload scale(s)
    # @overload scale(x, y)
    # @overload scale(x, y, z)
    #
    # @param s [Numeric] horizontal and vertical scale
    # @param x [Numeric] horizontal scale
    # @param y [Numeric] vertical scale
    # @param z [Numeric] depth scale
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_scale_.html
    #
    def scale(x, y = nil, z = 1)
      matrix__.scale! x, (y || x), z
      nil
    end

    # Reset the transformation matrix.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_resetMatrix_.html
    #
    def resetMatrix()
      @matrix = nil
    end

    # Applies rotation around the x-axis to the shape.
    #
    # @param angle [Numeric] angle for rotation
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_rotateX_.html
    #
    def rotateX(angle)
      matrix__.rotate! @context.toDegrees__(angle), 1, 0, 0
    end

    # Applies rotation around the y-axis to the shape.
    #
    # @param angle [Numeric] angle for rotation
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_rotateY_.html
    #
    def rotateY(angle)
      matrix__.rotate! @context.toDegrees__(angle), 0, 1, 0
    end

    # Applies rotation around the z-axis to the shape.
    #
    # @param angle [Numeric] angle for rotation
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/PShape_rotateZ_.html
    #
    def rotateZ(angle)
      matrix__.rotate! @context.toDegrees__(angle), 0, 0, 1
    end

    # @private
    def clearCache__()
      @polygon = nil# clear cache
    end

    # @private
    def matrix__()
      @matrix ||= Rays::Matrix.new
    end

    # @private
    def getInternal__()
      unless @polygon
        return nil unless @points && @close != nil
        @polygon = self.class.createPolygon__(
          @type, @points, @close, @colors, @texcoords)
        @polygon += @contours if @polygon
      end
      @polygon
    end

    # @private
    def draw__(painter, x, y, w = nil, h = nil)
      poly = getInternal__

      backup = nil
      if @matrix && (poly || @children)
        backup = painter.matrix
        painter.matrix = backup * @matrix
      end

      if poly
        if w || h
          painter.polygon poly, x, y, w,h
        else
          painter.polygon poly, x, y
        end
      end
      @children&.each {|o| o.draw__ painter, x, y, w, h}

      painter.matrix = backup if backup
    end

    # @private
    def self.createPolygon__(
      type, points, close = false, colors = nil, texcoords = nil)

      kwargs = {colors: colors, texcoords: texcoords}
      g, p   = GraphicsContext, Rays::Polygon
      case type
      when g::POINTS         then p.points(        *points)
      when g::LINES          then p.lines(         *points)
      when g::TRIANGLES      then p.triangles(     *points, **kwargs)
      when g::TRIANGLE_FAN   then p.triangle_fan(  *points, **kwargs)
      when g::TRIANGLE_STRIP then p.triangle_strip(*points, **kwargs)
      when g::QUADS          then p.quads(         *points, **kwargs)
      when g::QUAD_STRIP     then p.quad_strip(    *points, **kwargs)
      when g::TESS, nil      then p.new(           *points, **kwargs, loop: close)
      else raise ArgumentError, "invalid polygon type '#{type}'"
      end
    end

  end# Shape


end# Processing
