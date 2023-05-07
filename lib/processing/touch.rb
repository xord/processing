module Processing


  # Touch object.
  #
  class Touch

    # Identifier of each touch
    #
    attr_reader :id

    # Horizontal position of touch
    #
    # @return [Numeric] position x
    #
    attr_reader :x

    # Vertical position of touch
    #
    # @return [Numeric] position y
    #
    attr_reader :y

    # @private
    def initialize(id, x, y)
      @id, @x, @y = id, x, y
    end

    # Returns a string containing a human-readable representation of object.
    #
    # @return [String] inspected text
    #
    def inspect()
      "#<Processing::Touch: id:#{id} x:#{x} y:#{y}>"
    end

  end# Touch


end# Processing
