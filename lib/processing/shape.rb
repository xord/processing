module Processing


  # Shape object.
  #
  class Shape

    # @private
    def initialize(polygon = nil)
      @polygon = polygon
      @visible = true
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

    def beginShape = nil
    def endShape = nil
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

  end# Shape


end# Processing
