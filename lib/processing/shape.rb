module Processing


  # Shape object.
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
    def width()
      polygon = getInternal__ or return 0
      (@bounds ||= polygon.bounds).width
    end

    # Gets height of shape.
    #
    # @return [Numeric] height of shape
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
    def isVisible()
      @visible
    end

    alias visible? isVisible

    # Sets whether to display the shape or not.
    #
    # @return [nil] nil
    #
    def setVisible(visible)
      @visible = !!visible
      nil
    end

    def beginShape(type = nil)
      raise "beginShape() cannot be called twice" if drawingShape__
      @type          = type
      @points      ||= []
      @curvePoints   = []
      @colors      ||= []
      @texcoords   ||= []
      @close         = nil
      @contours    ||= []
      clearCache__
      nil
    end

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

    def beginContour()
      raise "beginContour() must be called after beginShape()" unless drawingShape__
      @contourPoints, @contourColors, @contourTexCoords = [], [], []
      nil
    end

    def endContour()
      raise "endContour() must be called after beginContour()" unless drawingContour__
      @contours << Rays::Polyline.new(
        *@contourPoints, colors: @contourColors, texcoords: @contourTexCoords,
        loop: true, hole: true)
      @contoursPoints = @contoursColors = @contoursTexCoords = nil
      nil
    end

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

    def bezierVertex(x2, y2, x3, y3, x4, y4)
      raise "bezierVertex() must be called after beginShape()" unless drawingShape__
      x1, y1 = @points[-2, 2]
      raise "vertex() is required before calling bezierVertex()" unless x1 && y1
      Rays::Polygon.bezier(x1, y1, x2, y2, x3, y3, x4, y4)
        .first.to_a.tap {|a| a.shift}
        .each {|p| vertex p.x, p.y}
      nil
    end

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
      @points && @close == nil
    end

    # @private
    def drawingContour__()
      @contourPoints
    end

    def fill(*args)
      @fill = @context.toRaysColor__(*args)
    end

    def setVertex(index, point)
      return nil unless @points && @points[index * 2, 2]&.size == 2
      @points[index * 2, 2] = [point.x, point.y]
    end

    def getVertex(index)
      return nil unless @points
      point = @points[index * 2, 2]
      return nil unless point&.size == 2
      @context.createVector(*point)
    end

    def getVertexCount()
      return 0 unless @points
      @points.size / 2
    end

    def setFill(*args)
      color = @context.toRaysColor__(*args)
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
          polylines.map {|pl| pl.dup colors: pl.points.map {color}}
        end
      end
    end

    def addChild(child)
      return unless @children
      @children.push child
      nil
    end

    def getChild(index)
      @children&.[](index)
    end

    def getChildCount()
      @children&.size || 0
    end

    def translate(x, y, z = 0)
      matrix__.translate x, y, z
      nil
    end

    def rotate(angle)
      matrix__.rotate @context.toDegrees__(angle)
      nil
    end

    def scale(x, y, z = 1)
      matrix__.scale x, y, z
      nil
    end

    def resetMatrix()
      @matrix = nil
    end

    def rotateX = nil
    def rotateY = nil
    def rotateZ = nil

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
