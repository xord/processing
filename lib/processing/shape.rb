module Processing


  # Shape object.
  #
  class Shape

    def initialize(polygon = nil)
      @polygon = polygon
      @visible = true
    end

    def width()
      return 0 unless @polygon
      (@bounds ||= @polygon.bounds).width
    end

    def height()
      return 0 unless @polygon
      (@bounds ||= @polygon.bounds).height
    end

    def isVisible()
      @visible
    end

    alias visible? isVisible

    def setVisible(visible)
      @visible = !!visible
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
