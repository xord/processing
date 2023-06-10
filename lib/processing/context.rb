module Processing


  # Processing context
  #
  class Context

    include Xot::Inspectable
    include GraphicsContext

    Capture    = Processing::Capture
    Font       = Processing::Font
    Graphics   = Processing::Graphics
    Image      = Processing::Image
    Shader     = Processing::Shader
    TextBounds = Processing::TextBounds
    Touch      = Processing::Touch
    Vector     = Processing::Vector

    # @private
    @@context__ = nil

    # @private
    def self.context__()
      @@context__
    end

    # @private
    def initialize(window)
      @@context__ = self

      tmpdir__.tap {|dir| FileUtils.rm_r dir.to_s if dir.directory?}

      @window__ = window
      init__(
        @window__.canvas_image,
        @window__.canvas_painter.paint {background 0.8})

      @loop__             = true
      @redraw__           = false
      @frameCount__       = 0
      @key__              = nil
      @keyCode__          = nil
      @keysPressed__      = Set.new
      @pointer__          = nil
      @pointerPrev__      = nil
      @pointersPressed__  = []
      @pointersReleased__ = []
      @touches__          = []
      @motionGravity__    = createVector 0, 0

      @window__.before_draw   = proc {beginDraw__}
      @window__.after_draw    = proc {endDraw__}
      @window__.update_canvas = proc {|i, p| updateCanvas__ i, p}

      @window__.instance_variable_set :@context, self

      # @private
      def @window__.draw_screen(painter)
        @context.drawImage__ painter
      end

      drawFrame = -> {
        begin
          push
          @drawBlock__.call if @drawBlock__
        ensure
          pop
          @frameCount__ += 1
        end
      }

      @window__.draw = proc do |e|
        if @loop__ || @redraw__
          @redraw__ = false
          drawFrame.call
        end
      end

      updateKeyStates = -> event, pressed {
        @key__     = event.chars
        @keyCode__ = event.key
        if pressed != nil
          set, key = @keysPressed__, event.key
          pressed ? set.add(key) : set.delete(key)
        end
      }

      mouseButtonMap = {
        mouse_left:   LEFT,
        mouse_right:  RIGHT,
        mouse_middle: CENTER
      }

      updatePointerStates = -> event, pressed = nil {
        pointer = event.find {|p| p.id == @pointer__&.id} || event.first
        if !mousePressed || pointer.id == @pointer__&.id
          @pointerPrev__, @pointer__ = @pointer__, pointer.dup
        end
        @touches__ = event.map {|p| Touch.new(p.id, *p.pos.to_a)}
        if pressed != nil
          event.types
            .tap {|types| types.delete :mouse}
            .map {|type| mouseButtonMap[type] || type}
            .each do |type|
              (pressed ? @pointersPressed__ : @pointersReleased__).push type
              @pointersPressed__.delete type unless pressed
            end
        end
      }

      @window__.key_down = proc do |e|
        updateKeyStates.call e, true
        @keyPressedBlock__&.call
        @keyTypedBlock__&.call if @key__ && !@key__.empty?
      end

      @window__.key_up = proc do |e|
        updateKeyStates.call e, false
        @keyReleasedBlock__&.call
      end

      @window__.pointer_down = proc do |e|
        updatePointerStates.call e, true
        @mousePressedBlock__&.call if e.any? {|p| p.id == @pointer__.id}
        @touchStartedBlock__&.call
      end

      @window__.pointer_up = proc do |e|
        updatePointerStates.call e, false
        @mouseReleasedBlock__&.call if e.any? {|p| p.id == @pointer__.id}
        @touchEndedBlock__&.call
        if (@pointer__.pos - @pointer__.down.pos).length < 3
          @mouseClickedBlock__&.call if e.any? {|p| p.id == @pointer__.id}
        end
        @pointersReleased__.clear
      end

      @window__.pointer_move = proc do |e|
        updatePointerStates.call e
        mouseMoved = e.drag? ? @mouseDraggedBlock__ : @mouseMovedBlock__
        mouseMoved&.call if e.any? {|p| p.id == @pointer__.id}
        @touchMovedBlock__&.call
      end

      @window__.move = proc do |e|
        @windowMovedBlock__&.call
      end

      @window__.resize = proc do |e|
        @windowResizedBlock__&.call
      end

      @window__.motion = proc do |e|
        @motionGravity__ = createVector(*e.gravity.to_a(3))
        @motionBlock__&.call
      end
    end

    # Defines setup block.
    #
    # @return [nil] nil
    #
    def setup(&block)
      @window__.setup = block
      nil
    end

    # @private
    def hasUserBlocks__()
      @drawBlock__          ||
      @keyPressedBlock__    ||
      @keyReleasedBlock__   ||
      @keyTypedBlock__      ||
      @mousePressedBlock__  ||
      @mouseReleasedBlock__ ||
      @mouseMovedBlock__    ||
      @mouseDraggedBlock__  ||
      @mouseClickedBlock__  ||
      @touchStartedBlock__  ||
      @touchEndedBlock__    ||
      @touchMovedBlock__    ||
      @windowMovedBlock__   ||
      @windowResizedBlock__ ||
      @motionBlock__
    end

    # Defines draw block.
    #
    # @return [nil] nil
    #
    def draw(&block)
      @drawBlock__ = block if block
      nil
    end

    # Defines keyPressed block.
    #
    # @return [Boolean] is any key pressed or not
    #
    def keyPressed(&block)
      @keyPressedBlock__ = block if block
      not @keysPressed__.empty?
    end

    # Defines keyReleased block.
    #
    # @return [nil] nil
    #
    def keyReleased(&block)
      @keyReleasedBlock__ = block if block
      nil
    end

    # Defines keyTyped block.
    #
    # @return [nil] nil
    #
    def keyTyped(&block)
      @keyTypedBlock__ = block if block
      nil
    end

    # Defines mousePressed block.
    #
    # @return [Boolean] is any mouse button pressed or not
    #
    def mousePressed(&block)
      @mousePressedBlock__ = block if block
      not @pointersPressed__.empty?
    end

    # Defines mouseReleased block.
    #
    # @return [nil] nil
    #
    def mouseReleased(&block)
      @mouseReleasedBlock__ = block if block
      nil
    end

    # Defines mouseMoved block.
    #
    # @return [nil] nil
    #
    def mouseMoved(&block)
      @mouseMovedBlock__ = block if block
      nil
    end

    # Defines mouseDragged block.
    #
    # @return [nil] nil
    #
    def mouseDragged(&block)
      @mouseDraggedBlock__ = block if block
      nil
    end

    # Defines mouseClicked block.
    #
    # @return [nil] nil
    #
    def mouseClicked(&block)
      @mouseClickedBlock__ = block if block
      nil
    end

    # Defines touchStarted block.
    #
    # @return [nil] nil
    #
    def touchStarted(&block)
      @touchStartedBlock__ = block if block
      nil
    end

    # Defines touchEnded block.
    #
    # @return [nil] nil
    #
    def touchEnded(&block)
      @touchEndedBlock__ = block if block
      nil
    end

    # Defines touchMoved block.
    #
    # @return [nil] nil
    #
    def touchMoved(&block)
      @touchMovedBlock__ = block if block
      nil
    end

    # Defines windowMoved block.
    #
    # @return [nil] nil
    #
    def windowMoved(&block)
      @windowMovedBlock__ = block if block
      nil
    end

    # Defines windowResized block.
    #
    # @return [nil] nil
    #
    def windowResized(&block)
      @windowResizedBlock__ = block if block
      nil
    end

    # Defines motion block.
    #
    # @return [nil] nil
    #
    def motion(&block)
      @motionBlock__ = block if block
      nil
    end

    # Changes canvas size.
    #
    # @param width        [Integer] new width
    # @param height       [Integer] new height
    # @param pixelDensity [Numeric] new pixel density
    #
    # @return [nil] nil
    #
    def size(width, height, pixelDensity: self.pixelDensity)
      resizeCanvas__ :size, width, height, pixelDensity
      nil
    end

    # Changes canvas size.
    #
    # @param width        [Integer] new width
    # @param height       [Integer] new height
    # @param pixelDensity [Numeric] new pixel density
    #
    # @return [nil] nil
    #
    def createCanvas(width, height, pixelDensity: self.pixelDensity)
      resizeCanvas__ :createCanvas, width, height, pixelDensity
      nil
    end

    # Changes title of window.
    #
    # @param title [String] new title
    #
    # @return [nil] nil
    #
    def setTitle(title)
      @window__.title = title
      nil
    end

    # Changes and returns canvas pixel density.
    #
    # @param density [Numeric] new pixel density
    #
    # @return [Numeric] current pixel density
    #
    def pixelDensity(density = nil)
      resizeCanvas__ :pixelDensity, width, height, density if density
      @painter__.pixel_density
    end

    # @private
    def resizeCanvas__(name, width, height, pixelDensity)
      raise '#{name}() must be called on startup or setup block' if @started__

      @window__.resize_canvas width, height, pixelDensity
      @window__.auto_resize = false
    end

    # Returns the width of the display.
    #
    # @return [Numeric] width
    #
    def displayWidth()
      @window__.screen.width
    end

    # Returns the height of the display.
    #
    # @return [Numeric] height
    #
    def displayHeight()
      @window__.screen.height
    end

    # Returns the pixel density of the display.
    #
    # @return [Numeric] pixel density
    #
    def displayDensity()
      @window__.painter.pixel_density
    end

    # Move the position of the window.
    #
    # @param [Numeric] x x position of the window
    # @param [Numeric] y y position of the window
    #
    # @return [nil] nil
    #
    def windowMove(x, y)
      @window__.pos = [x, y]
      nil
    end

    # Sets the size of the window.
    #
    # @param [Numeric] width  width of the window
    # @param [Numeric] height height of the window
    #
    # @return [nil] nil
    #
    def windowResize(width, height)
      @window__.size = [width, height]
      nil
    end

    # Makes the window resizable or not.
    #
    # @param [Boolean] resizable resizable or not
    #
    # @return [nil] nil
    #
    def windowResizable(resizable)
      @window__.resizable = resizable
      nil
    end

    # Returns the x position of the window.
    #
    # @return [Numeric] horizontal position of the window
    #
    def windowX()
      @window__.x
    end

    # Returns the y position of the window.
    #
    # @return [Numeric] vertical position of the window
    #
    def windowY()
      @window__.y
    end

    # Returns the width of the window.
    #
    # @return [Numeric] window width
    #
    def windowWidth()
      @window__.width
    end

    # Returns the height of the window.
    #
    # @return [Numeric] window height
    #
    def windowHeight()
      @window__.height
    end

    # Returns weather the window is active or not.
    #
    # @return [Boolean] active or not
    #
    def focused()
      @window__.active?
    end

    # Returns the number of frames since the program started.
    #
    # @return [Integer] total number of frames
    #
    def frameCount()
      @frameCount__
    end

    # Returns the number of frames per second.
    #
    # @return [Float] frames per second
    #
    def frameRate()
      @window__.event.fps
    end

    # Returns the last key that was pressed or released.
    #
    # @return [String] last key
    #
    def key()
      @key__
    end

    # Returns the last key code that was pressed or released.
    #
    # @return [Symbol] last key code
    #
    def keyCode()
      @keyCode__
    end

    # Returns mouse x position
    #
    # @return [Numeric] horizontal position of mouse
    #
    def mouseX()
      @pointer__&.x || 0
    end

    # Returns mouse y position
    #
    # @return [Numeric] vertical position of mouse
    #
    def mouseY()
      @pointer__&.y || 0
    end

    # Returns mouse x position in previous frame
    #
    # @return [Numeric] horizontal position of mouse
    #
    def pmouseX()
      @pointerPrev__&.x || 0
    end

    # Returns mouse y position in previous frame
    #
    # @return [Numeric] vertical position of mouse
    #
    def pmouseY()
      @pointerPrev__&.y || 0
    end

    # Returns which mouse button was pressed
    #
    # @return [Numeric] LEFT, RIGHT, CENTER or 0
    #
    def mouseButton()
      ((@pointersPressed__ + @pointersReleased__) & [LEFT, RIGHT, CENTER]).last
    end

    # Returns array of touches
    #
    # @return [Array] Touch objects
    #
    def touches()
      @touches__
    end

    # Returns vector for real world gravity
    #
    # @return [Vector] gravity vector
    #
    def motionGravity()
      @motionGravity__
    end

    # Enables calling draw block on every frame.
    #
    # @return [nil] nil
    #
    def loop()
      @loop__ = true
    end

    # Disables calling draw block on every frame.
    #
    # @return [nil] nil
    #
    def noLoop()
      @loop__ = false
    end

    # Calls draw block to redraw frame.
    #
    # @return [nil] nil
    #
    def redraw()
      @redraw__ = true
    end

  end# Context


end# Processing
