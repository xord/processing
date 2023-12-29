module Processing


  # Font object.
  #
  class Font

    # @private
    def initialize(font)
      @font = font
    end

    # Returns bounding box.
    #
    # @overload textBounds(str)
    # @overload textBounds(str, x, y)
    # @overload textBounds(str, x, y, fontSize)
    #
    # @param str      [String]  text to calculate bounding box
    # @param x        [Numeric] horizontal position of bounding box
    # @param y        [Numeric] vertical position of bounding box
    # @param fontSize [Numeric] font size
    #
    # @return [TextBounds] bounding box for text
    #
    def textBounds(str, x = 0, y = 0, fontSize = nil)
      f = fontSize ? Rays::Font.new(@font.name, fontSize) : @font
      TextBounds.new x, y, x + f.width(str), y + f.height
    end

    # Returns a string containing a human-readable representation of object.
    #
    # @return [String] inspected text
    #
    def inspect()
      "#<Processing::Font: name:'#{@font.name}' size:#{@font.size}>"
    end

    # @private
    def getInternal__()
      @font
    end

  end# Font


  # Bounding box for text.
  #
  class TextBounds

    # Horizontal position
    #
    attr_reader :x

    # Vertical position
    #
    attr_reader :y

    # Width of bounding box
    #
    attr_reader :w

    # Height of bounding box
    #
    attr_reader :h

    # @private
    def initialize(x, y, w, h)
      @x, @y, @w, @h = x, y, w, h
    end

    # Returns a string containing a human-readable representation of object.
    #
    # @return [String] inspected text
    #
    def inspect()
      "#<Processing::TextBounds: x:#{x} y:#{y} w:#{w} h:#{h}>"
    end

  end# TextBounds


end# Processing
