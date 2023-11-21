module Processing


  # Shape object.
  #
  class Shape

    # @private
    def initialize(polygon = nil, children = nil, context: nil)
      @polygon, @children, @visible = polygon, children, true
      @context                      = context || Context.context__
      @mode = @points = @closed = nil
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

    def beginShape(mode = nil)
      @mode     = mode
      @points ||= []
      @polygon  = nil# clear cache
      nil
    end

    def endShape(close = nil)
      raise "endShape() must be called after beginShape()" unless @points
      @closed = close == GraphicsContext::CLOSE
      nil
    end

    def vertex(x, y)
      raise "vertex() must be called after beginShape()" unless @points
      @points << x << y
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

    def addChild(child)
      return unless @children
      @children.push child
    end

    def getChild(index)
      @children&.[](index)
    end

    def getChildCount()
      @children&.size || 0
    end

    def translate = nil
    def rotateX = nil
    def rotateY = nil
    def rotateZ = nil
    def rotate = nil
    def scale = nil
    def resetMatrix = nil

    # @private
    def getInternal__()
      unless @polygon
        return nil unless @points && @closed != nil
        @polygon = self.class.createPolygon__ @mode, @points, @closed
      end
      @polygon
    end

    # @private
    def draw__(painter, x, y, w = nil, h = nil)
      if poly = getInternal__
        if w || h
          painter.polygon poly, x, y, w,h
        else
          painter.polygon poly, x, y
        end
      end
      @children&.each {|o| o.draw__ painter, x, y, w, h}
    end

    # @private
    def self.createPolygon__(mode, points, close = false)
      g = GraphicsContext
      case mode
      when g::POINTS         then Rays::Polygon.points(        *points)
      when g::LINES          then Rays::Polygon.lines(         *points)
      when g::TRIANGLES      then Rays::Polygon.triangles(     *points)
      when g::TRIANGLE_FAN   then Rays::Polygon.triangle_fan(  *points)
      when g::TRIANGLE_STRIP then Rays::Polygon.triangle_strip(*points)
      when g::QUADS          then Rays::Polygon.quads(         *points)
      when g::QUAD_STRIP     then Rays::Polygon.quad_strip(    *points)
      when g::TESS, nil      then Rays::Polygon.new(*points, loop: close)
      else raise ArgumentError, "invalid polygon mode '#{mode}'"
      end
    end

  end# Shape


end# Processing
