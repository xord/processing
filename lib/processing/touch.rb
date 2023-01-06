module Processing


  # Touch object.
  #
  class Touch

    # Identifier of each touch
    #
    attr_reader :id

    # Horizontal position of touch
    #
    attr_reader :x

    # Vertical position of touch
    #
    attr_reader :y

    # @private
    def initialize(id, x, y)
      @id, @x, @y = id, x, y
    end

  end# Touch


end# Processing
