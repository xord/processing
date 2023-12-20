module Processing


  # Shape object.
  #
  class Shape

    # @private
    def initialize(polygon = nil, children = nil, context: nil)
      @polygon, @children = polygon, children
      @context            = context || Context.context__
      @visible, @matrix   = true, nil
      @mode = @points = @close = @colors = @texcoords = nil
      @fill = nil
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
      @mode        = mode
      @points    ||= []
      @close       = nil
      @colors    ||= []
      @texcoords ||= []
      clearCache__
      nil
    end

    def endShape(close = nil)
      raise "endShape() must be called after beginShape()" unless @points
      @close = close == GraphicsContext::CLOSE
      nil
    end

    def vertex(x, y, u = nil, v = nil)
      raise "vertex() must be called after beginShape()" unless @points
      raise "Either 'u' or 'v' is missing" if (u == nil) != (v == nil)
      @points    << x        << y
      @colors    << (@fill || @context.getFill__)
      @texcoords << (u || x) << (v || y)
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
          @mode, @points, @close, @colors, @texcoords)
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
      mode, points, close = false, colors = nil, texcoords = nil)

      kwargs = {colors: colors, texcoords: texcoords}
      g, p   = GraphicsContext, Rays::Polygon
      case mode
      when g::POINTS         then p.points(        *points)
      when g::LINES          then p.lines(         *points)
      when g::TRIANGLES      then p.triangles(     *points, **kwargs)
      when g::TRIANGLE_FAN   then p.triangle_fan(  *points, **kwargs)
      when g::TRIANGLE_STRIP then p.triangle_strip(*points, **kwargs)
      when g::QUADS          then p.quads(         *points, **kwargs)
      when g::QUAD_STRIP     then p.quad_strip(    *points, **kwargs)
      when g::TESS, nil      then p.new(           *points, **kwargs, loop: close)
      else raise ArgumentError, "invalid polygon mode '#{mode}'"
      end
    end

  end# Shape


end# Processing
