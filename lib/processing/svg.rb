module Processing


  # @private
  class SVGLoader

    def initialize(context)
      @c, @cc = context, context.class
    end

    def load(filename)
      svg = REXML::Document.new File.read filename
      addGroup nil, svg.elements.first
    end

    def addGroup(parent, e)
      group = @c.createShape @cc::GROUP
      e.elements.each do |child|
        case child.name.to_sym
        when :g, :a    then addGroup    group, child
        when :line     then addLine     group, child
        when :rect     then addRect     group, child
        when :circle   then addCircle   group, child
        when :ellipse  then addEllipse  group, child
        when :polyline then addPolyline group, child
        when :polygon  then addPolyline group, child, true
        when :path     then addPath     group, child
        end
      end
      parent.addChild group if parent
      group
    end

    def addLine(parent, e)
      x1, y1 = float(e, :x1), float(e, :y1)
      x2, y2 = float(e, :x2), float(e, :y2)
      s = @c.createLineShape__ x1, y1, x2, y2
      apply_attribs s, e
      parent.addChild s
    end

    def addRect(parent, e)
      x, y = float(e, :x),     float(e, :y)
      w, h = float(e, :width), float(e, :height)
      s = @c.createRectShape__ x, y, w, h, @cc::CORNER
      apply_attribs s, e
      parent.addChild s
    end

    def addCircle(parent, e)
      cx, cy = float(e, :cx), float(e, :cy)
      r      = float(e, :r)
      s = @c.createEllipseShape__ cx, cy, r, r, @cc::CENTER
      apply_attribs s, e
      parent.addChild s
    end

    def addEllipse(parent, e)
      cx, cy = float(e, :cx), float(e, :cy)
      rx, ry = float(e, :rx), float(e, :ry)
      s = @c.createEllipseShape__ cx, cy, rx, ry, @cc::CENTER
      apply_attribs s, e
      parent.addChild s
    end

    def addPolyline(parent, e, close = false)
      points  = e[:points] or raise Error, "missing 'points'"
      scanner = StringScanner.new points
      child   = @c.createShape
      child.beginShape

      skipSpaces scanner
      until scanner.empty?
        child.vertex(*nextPos(scanner))
        skipSpaces scanner
      end

      child.endShape close ? @cc::CLOSE : @cc::OPEN
      apply_attribx child, e
      parent.addChild child
    end

    def apply_attribs(shape, e)
      shape.setFill         e[:fill]           || :none
      shape.setStroke       e[:stroke]         || :none
      shape.setStrokeWeight e[:'stroke-width'] || 1
    end

    def int(e, key, defval = 0)
      e[key]&.to_i || defval
    end

    def float(e, key, defval = 0)
      e[key]&.to_f || defval
    end

    def addPath(parent, e)
      data    = e[:d] or raise Error, "missing 'd'"
      scanner = StringScanner.new data
      skipSpaces scanner

      child      = nil
      close      = false
      beginChild = -> {
        close = false
        child = @c.createShape
        child.beginShape
      }
      endChild   = -> {
        if child# && child.getVertexCount >= 2
          child.endShape close ? @cc::CLOSE : @cc::OPEN
          apply_attribs child, e
          parent.addChild child
        end
      }

      lastCommand    = nil
      lastX,  lastY  = 0, 0
      lastCX, lastCY = 0, 0
      until scanner.empty?
        command = nextCommand scanner
        if command =~ /^[Mm]$/
          endChild.call
          beginChild.call
        end
        raise Error, "no leading 'M' or 'm'" unless child

        command ||= lastCommand
        case command
        when 'M', 'm'
          lastX, lastY = nextPos scanner, lastX, lastY, command == 'm'
          child.vertex lastX, lastY
        when 'L', 'l'
          lastX, lastY = nextPos scanner, lastX, lastY, command == 'l'
          child.vertex lastX, lastY
        when 'H', 'h'
          lastX = nextNum scanner, lastX, command == 'h'
          child.vertex lastX, lastY
        when 'V', 'v'
          lastY = nextNum scanner, lastY, command == 'v'
          child.vertex lastX, lastY
        when 'Q', 'q'
          relative       = command == 'q'
          lastCX, lastCY = nextPos scanner, lastX, lastY, relative
          lastX,  lastY  = nextPos scanner, lastX, lastY, relative
          child.quadraticVertex lastCX, lastCY, lastX, lastY
        when 'T', 't'
          lastCY, lastCY =
            if lastCommand =~ /[QqTt]/
              [lastX + (lastX - lastCX), lastY + (lastY - lastCY)]
            else
              [lastX, lastY]
            end
          lastX, lastY = nextPos scanner, lastX, lastY, command == 't'
          child.quadraticVertex lastCX, lastCY, lastX, lastY
        when 'C', 'c'
          relative       = command == 'c'
              cx,     cy = nextPos scanner, lastX, lastY, relative
          lastCX, lastCY = nextPos scanner, lastX, lastY, relative
          lastX,  lastY  = nextPos scanner, lastX, lastY, relative
          child.bezierVertex cx, cy, lastCX, lastCY, lastX, lastY
        when 'S', 's'
          cx, cy =
            if lastCommand =~ /[CcSs]/
              [lastX + (lastX - lastCX), lastY + (lastY - lastCY)]
            else
              [lastX, lastY]
            end
          relative       = command == 's'
          lastCX, lastCY = nextPos scanner, lastX, lastY, relative
          lastX,  lastY  = nextPos scanner, lastX, lastY, relative
          child.bezierVertex cx, cy, lastCX, lastCY, lastX, lastY
        when 'A', 'a'
          rx, ry       = nextPos scanner
          a, b, c      = nextNum(scanner), nextNum(scanner), nextNum(scanner)
          lastX, lastY = nextPos scanner, lastX, lastY, command == 'a'
          child.vertex lastX, lastY
        when 'Z', 'z'
          v0           = child.getVertex 0
          lastX, lastY = v0 ? [v0.x, v0.y] : [0, 0]
          close = true
        end
        lastCommand = command
      end
      endChild.call
    end

    def nextCommand(scanner)
      w = scanner.scan(/[[:alpha:]]/)
      skipSpaces scanner
      w
    end

    def nextNum(scanner, base = 0, relative = true)
      n = scanner.scan(/(?:[\+\-]\s*)?\d*(?:\.\d+)?/)&.strip&.to_f
      raise Error, 'invalid path' unless n
      skipSpaces scanner
      n + (relative ? base : 0)
    end

    def nextPos(scanner, baseX = 0, baseY = 0, relative = true)
      [nextNum(scanner, baseX, relative), nextNum(scanner, baseY, relative)]
    end

    def skipSpaces(scanner)
      scanner.scan /\s*,?\s*/
    end

    class Error < StandardError
      def initialize(message = "error")
        super "SVG: #{message}"
      end
    end# Error

  end# SVG


end# Processing
