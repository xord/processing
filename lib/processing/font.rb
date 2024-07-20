module Processing


  # Font object.
  #
  # @see https://processing.org/reference/PFont.html
  # @see https://p5js.org/reference/p5/p5.Font/
  #
  class Font

    # @private
    def initialize(font)
      @font        = font or raise ArgumentError
      @cachedSizes = {}
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
    # @see https://p5js.org/reference/p5.Font/textBounds/
    #
    def textBounds(str, x = 0, y = 0, fontSize = nil)
      font = getInternal__ fontSize
      TextBounds.new x, y, x + font.width(str), y + font.height
    end

    # Returns a string containing a human-readable representation of object.
    #
    # @return [String] inspected text
    #
    def inspect()
      "#<Processing::Font: name:'#{@font.name}' size:#{@font.size}>"
    end

    # Returns available font names
    #
    # @return [String] font names
    #
    # @see https://processing.org/reference/PFont_list_.html
    #
    def self.list()
      Rays::Font.families.values.flatten
    end

    # @private
    def getInternal__(size = nil)
      if size
        @cachedSizes[size.to_f] ||= @font.dup.tap {|font| font.size = size}
      else
        @font
      end
    end

    # @private
    def setSize__(size)
      return if size == @font.size
      @cachedSizes[@font.size] = @font
      @font = getInternal__ size
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
