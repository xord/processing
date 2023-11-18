module Processing


  # Shape object.
  #
  class Shape

    # @private
    def initialize(polygon = nil)
      @polygon, @visible = polygon, true
      @mode, @points     = nil, nil
    end

    # Gets width of shape.
    #
    # @return [Numeric] width of shape
    #
    def width()
      return 0 unless @polygon
      (@bounds ||= @polygon.bounds).width
    end

    # Gets height of shape.
    #
    # @return [Numeric] height of shape
    #
    def height()
      return 0 unless @polygon
      (@bounds ||= @polygon.bounds).height
    end

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
      @mode, @points = mode, []
      nil
    end

    def endShape(mode = nil)
      raise "endShape() must be called after beginShape()" unless @points
      close    = mode == GraphicsContext::CLOSE
      @polygon = self.class.createPolygon__ @mode, @points, close
      @mode = @points = nil
      nil
    end

    def vertex(x, y)
      raise "vertex() must be called after beginShape()" unless @points
      @points << x << y
    end

    def getChildCount = nil
    def getChild = nil
    def addChild = nil
    def getVertexCount = nil
    def getVertex = nil
    def setVertex = nil
    def translate = nil
    def rotateX = nil
    def rotateY = nil
    def rotateZ = nil
    def rotate = nil
    def scale = nil
    def resetMatrix = nil

    # @private
    def getInternal__()
      @polygon
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
      when g::TESS           then Rays::Polygon.new(*points, loop: close)
      else                        Rays::Polygon.new(*points, loop: close)
      end
    end

  end# Shape


end# Processing
