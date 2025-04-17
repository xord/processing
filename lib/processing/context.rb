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

    # Portrait for windowOrientation
    #
    PORTRAIT  = :portrait

    # Landscape for windowOrientation
    #
    LANDSCAPE = :landscape

    # @private
    @@rootContext__ = nil

    # @private
    @@context__     = nil

    # @private
    def self.context__()
      @@context__ || @@rootContext__
    end

    # @private
    def self.setContext__(context)
      @@context__ = context
    end

    # @private
    def initialize(window)
      @@rootContext__ = self

      tmpdir__.tap {|dir| FileUtils.rm_r dir.to_s if dir.directory?}

      @window__ = window
      init__(
        @window__.canvas.image,
        @window__.canvas.painter.paint {background 0.8})

      @smooth__           = true
      @loop__             = true
      @redraw__           = false
      @frameCount__       = 0
      @key__              = nil
      @keyCode__          = nil
      @keyRepeat__        = false
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

      @window__.instance_variable_set :@context__, self

      # @private
      def @window__.draw_screen(painter)
        @context__.drawImage__ painter, image__: canvas.render
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
        set          = @keysPressed__
        @key__       = event.chars
        @keyCode__   = event.key
        @keyRepeat__ = pressed && set.include?(@keyCode__)
        pressed ? set.add(@keyCode__) : set.delete(@keyCode__)
      }

      mouseButtonMap = {
        mouse_left:   LEFT,
        mouse_right:  RIGHT,
        mouse_middle: CENTER
      }

      updatePointerStates = -> event {
        pointer = event.find {|p| p.id == @pointer__&.id} || event.first
        if !mousePressed || pointer.id == @pointer__&.id
          @pointerPrev__, @pointer__ = @pointer__, pointer.dup
        end
        @touches__ = event.map {|p| Touch.new(p.id, *p.pos.to_a)}
      }

      updatePointersPressedAndReleased = -> event, pressed {
        event.map(&:types).flatten
          .tap {|types| types.delete :mouse}
          .map {|type| mouseButtonMap[type] || type}
          .each do |type|
            (pressed ? @pointersPressed__ : @pointersReleased__).push type
            if !pressed && index = @pointersPressed__.index(type)
              @pointersPressed__.delete_at index
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
        updatePointerStates.call e
        updatePointersPressedAndReleased.call e, true
        @mousePressedBlock__&.call if e.any? {|p| p.id == @pointer__.id}
        @touchStartedBlock__&.call
      end

      @window__.pointer_up = proc do |e|
        updatePointerStates.call e
        updatePointersPressedAndReleased.call e, false
        if e.any? {|p| p.id == @pointer__.id}
          @mouseReleasedBlock__&.call
          @mouseClickedBlock__&.call  if e.click_count > 0
          @doubleClickedBlock__&.call if e.click_count == 2
        end
        @touchEndedBlock__&.call
        @pointersReleased__.clear
      end

      @window__.pointer_move = proc do |e|
        updatePointerStates.call e
        mouseMoved = e.drag? ? @mouseDraggedBlock__ : @mouseMovedBlock__
        mouseMoved&.call if e.any? {|p| p.id == @pointer__.id}
        @touchMovedBlock__&.call
      end

      @window__.wheel = proc do |e|
        @mouseWheelBlock__&.call WheelEvent.new(e)
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
      @doubleClickedBlock__ ||
      @mouseWheelBlock__    ||
      @touchStartedBlock__  ||
      @touchEndedBlock__    ||
      @touchMovedBlock__    ||
      @windowMovedBlock__   ||
      @windowResizedBlock__ ||
      @motionBlock__
    end

    # Defines setup block.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/setup_.html
    # @see https://p5js.org/reference/p5/setup/
    #
    def setup(&block)
      @window__.setup = block if block
      nil
    end

    # Defines draw block.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/draw_.html
    # @see https://p5js.org/reference/p5/draw/
    #
    def draw(&block)
      @drawBlock__ = block if block
      nil
    end

    # Defines keyPressed block.
    #
    # @return [Boolean] is any key pressed or not
    #
    # @see https://processing.org/reference/keyPressed_.html
    # @see https://p5js.org/reference/p5/keyPressed/
    #
    def keyPressed(&block)
      @keyPressedBlock__ = block if block
      keyIsPressed
    end

    # Defines keyReleased block.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/keyReleased_.html
    # @see https://p5js.org/reference/p5/keyReleased/
    #
    def keyReleased(&block)
      @keyReleasedBlock__ = block if block
      nil
    end

    # Defines keyTyped block.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/keyTyped_.html
    # @see https://p5js.org/reference/p5/keyTyped/
    #
    def keyTyped(&block)
      @keyTypedBlock__ = block if block
      nil
    end

    # Defines mousePressed block.
    #
    # @return [Boolean] is any mouse button pressed or not
    #
    # @see https://processing.org/reference/mousePressed_.html
    # @see https://processing.org/reference/mousePressed.html
    # @see https://p5js.org/reference/p5/mousePressed/
    #
    def mousePressed(&block)
      @mousePressedBlock__ = block if block
      not @pointersPressed__.empty?
    end

    # Defines mouseReleased block.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/mouseReleased_.html
    # @see https://p5js.org/reference/p5/mouseReleased/
    #
    def mouseReleased(&block)
      @mouseReleasedBlock__ = block if block
      nil
    end

    # Defines mouseMoved block.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/mouseMoved_.html
    # @see https://p5js.org/reference/p5/mouseMoved/
    #
    def mouseMoved(&block)
      @mouseMovedBlock__ = block if block
      nil
    end

    # Defines mouseDragged block.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/mouseDragged_.html
    # @see https://p5js.org/reference/p5/mouseDragged/
    #
    def mouseDragged(&block)
      @mouseDraggedBlock__ = block if block
      nil
    end

    # Defines mouseClicked block.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/mouseClicked_.html
    # @see https://p5js.org/reference/p5/mouseClicked/
    #
    def mouseClicked(&block)
      @mouseClickedBlock__ = block if block
      nil
    end

    # Defines doubleClicked block.
    #
    # @return [nil] nil
    #
    # @see https://p5js.org/reference/p5/doubleClicked/
    #
    def doubleClicked(&block)
      @doubleClickedBlock__ = block if block
      nil
    end

    # Defines mouseWheel block.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/mouseWheel_.html
    # @see https://p5js.org/reference/p5/mouseWheel/
    #
    def mouseWheel(&block)
      @mouseWheelBlock__ = block if block
      nil
    end

    # Defines touchStarted block.
    #
    # @return [nil] nil
    #
    # @see https://p5js.org/reference/p5/touchStarted/
    #
    def touchStarted(&block)
      @touchStartedBlock__ = block if block
      nil
    end

    # Defines touchEnded block.
    #
    # @return [nil] nil
    #
    # @see https://p5js.org/reference/p5/touchEnded/
    #
    def touchEnded(&block)
      @touchEndedBlock__ = block if block
      nil
    end

    # Defines touchMoved block.
    #
    # @return [nil] nil
    #
    # @see https://p5js.org/reference/p5/touchMoved/
    #
    def touchMoved(&block)
      @touchMovedBlock__ = block if block
      nil
    end

    # Defines windowMoved block.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/windowMoved_.html
    #
    def windowMoved(&block)
      @windowMovedBlock__ = block if block
      nil
    end

    # Defines windowResized block.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/windowResized_.html
    # @see https://p5js.org/reference/p5/windowResized/
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
    # @see https://processing.org/reference/size_.html
    #
    def size(width, height, pixelDensity: self.pixelDensity)
      windowResize width, height
      resizeCanvas__ width, height, pixelDensity
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
    # @see https://p5js.org/reference/p5/createCanvas/
    #
    def createCanvas(width, height, pixelDensity: self.pixelDensity)
      windowResize width, height
      resizeCanvas__ width, height, pixelDensity
      nil
    end

    # Changes title of window.
    #
    # @param title [String] new title
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/setTitle_.html
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
    # @see https://processing.org/reference/pixelDensity_.html
    # @see https://p5js.org/reference/p5/pixelDensity/
    #
    def pixelDensity(density = nil)
      resizeCanvas__ width, height, density if density
      @window__.canvas.pixel_density
    end

    # Toggles full-screen state or returns the current state.
    #
    # @param state [Boolean] Whether to display full-screen or not
    #
    # @return [Boolean] current state
    #
    # @see https://processing.org/reference/fullScreen_.html
    # @see https://p5js.org/reference/p5/fullscreen/
    #
    def fullscreen(state = nil)
      @window__.fullscreen = state if state != nil
      @window__.fullscreen?
    end

    alias fullScreen fullscreen

    # Enables anti-aliasing.
    # (Anti-aliasing is disabled on high DPI screen)
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/smooth_.html
    # @see https://p5js.org/reference/p5/smooth/
    #
    def smooth()
      @smooth__ = true
      resizeCanvas__ width, height, pixelDensity
      nil
    end

    # Disables anti-aliasing.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/noSmooth_.html
    # @see https://p5js.org/reference/p5/noSmooth/
    #
    def noSmooth()
      @smooth__ = false
      resizeCanvas__ width, height, pixelDensity
    end

    # @private
    def resizeCanvas__(width, height, pixelDensity)
      @window__.resize_canvas width, height, pixelDensity, antialiasing: @smooth__
      @window__.auto_resize = false
    end

    # Returns the width of the display.
    #
    # @return [Numeric] width
    #
    # @see https://processing.org/reference/displayWidth.html
    # @see https://p5js.org/reference/p5/displayWidth/
    #
    def displayWidth()
      @window__.screen.width
    end

    # Returns the height of the display.
    #
    # @return [Numeric] height
    #
    # @see https://processing.org/reference/displayHeight.html
    # @see https://p5js.org/reference/p5/displayHeight/
    #
    def displayHeight()
      @window__.screen.height
    end

    # Returns the pixel density of the display.
    #
    # @return [Numeric] pixel density
    #
    # @see https://processing.org/reference/displayDensity_.html
    # @see https://p5js.org/reference/p5/displayDensity/
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
    # @see https://processing.org/reference/windowMove_.html
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
    # @see https://processing.org/reference/windowResize_.html
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
    # @see https://processing.org/reference/windowResizable_.html
    #
    def windowResizable(resizable)
      @window__.resizable = resizable
      nil
    end

    # Sets window orientation mask
    #
    # @param [PORTRAIT, LANDSCAPE] orientations orientations that window can rotate to
    #
    # @return [nil] nil
    #
    def windowOrientation(*orientations)
      @window__.orientations = orientations.flatten.uniq
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
    # @see https://p5js.org/reference/p5/windowWidth/
    #
    def windowWidth()
      @window__.width
    end

    # Returns the height of the window.
    #
    # @return [Numeric] window height
    #
    # @see https://p5js.org/reference/p5/windowHeight/
    #
    def windowHeight()
      @window__.height
    end

    # Returns whether the window is active or not.
    #
    # @return [Boolean] active or not
    #
    # @see https://processing.org/reference/focused.html
    # @see https://p5js.org/reference/p5/focused/
    #
    def focused()
      @window__.active?
    end

    # Returns the number of frames since the program started.
    #
    # @return [Integer] total number of frames
    #
    # @see https://processing.org/reference/frameCount.html
    # @see https://p5js.org/reference/p5/frameCount/
    #
    def frameCount()
      @frameCount__
    end

    # Returns the number of frames per second.
    #
    # @return [Float] frames per second
    #
    # @see https://processing.org/reference/frameRate.html
    # @see https://p5js.org/reference/p5/frameRate/
    #
    def frameRate()
      @window__.event.fps
    end

    # Returns the elapsed time after previous drawing event
    #
    # @return [Float] elapsed time in milliseconds
    #
    # @see https://p5js.org/reference/p5/deltaTime/
    #
    def deltaTime()
      @window__.event.dt * 1000
    end

    # Returns the last key that was pressed or released.
    #
    # @return [String] last key
    #
    # @see https://processing.org/reference/key.html
    # @see https://p5js.org/reference/p5/key/
    #
    def key()
      @key__
    end

    # Returns the last key code that was pressed or released.
    #
    # @return [Symbol] last key code
    #
    # @see https://processing.org/reference/keyCode.html
    # @see https://p5js.org/reference/p5/keyCode/
    #
    def keyCode()
      @keyCode__
    end

    # Returns whether or not any key is pressed.
    #
    # @return [Boolean] is any key pressed or not
    #
    # @see https://p5js.org/reference/p5/keyIsPressed/
    #
    def keyIsPressed()
      not @keysPressed__.empty?
    end

    # Returns whether or not the key is currently pressed.
    #
    # @param keyCode [Numeric] code for the key
    #
    # @return [Boolean] is the key pressed or not
    #
    # @see https://p5js.org/reference/p5/keyIsDown/
    #
    def keyIsDown(keyCode)
      @keysPressed__.include? keyCode
    end

    # Returns whether the current key is repeated or not.
    #
    # @return [Boolean] is the key repeated or not
    #
    def keyIsRepeated()
      @keyRepeat__
    end

    # Returns mouse x position
    #
    # @return [Numeric] horizontal position of mouse
    #
    # @see https://processing.org/reference/mouseX.html
    # @see https://p5js.org/reference/p5/mouseX/
    #
    def mouseX()
      @pointer__&.x || 0
    end

    # Returns mouse y position
    #
    # @return [Numeric] vertical position of mouse
    #
    # @see https://processing.org/reference/mouseY.html
    # @see https://p5js.org/reference/p5/mouseY/
    #
    def mouseY()
      @pointer__&.y || 0
    end

    # Returns mouse x position in previous frame
    #
    # @return [Numeric] horizontal position of mouse
    #
    # @see https://processing.org/reference/pmouseX.html
    # @see https://p5js.org/reference/p5/pmouseX/
    #
    def pmouseX()
      @pointerPrev__&.x || 0
    end

    # Returns mouse y position in previous frame
    #
    # @return [Numeric] vertical position of mouse
    #
    # @see https://processing.org/reference/pmouseY.html
    # @see https://p5js.org/reference/p5/pmouseY/
    #
    def pmouseY()
      @pointerPrev__&.y || 0
    end

    # Returns which mouse button was pressed
    #
    # @return [Numeric] LEFT, RIGHT, CENTER or 0
    #
    # @see https://processing.org/reference/mouseButton.html
    # @see https://p5js.org/reference/p5/mouseButton/
    #
    def mouseButton()
      ((@pointersPressed__ + @pointersReleased__) & [LEFT, RIGHT, CENTER]).last
    end

    # Returns array of touches
    #
    # @return [Array] Touch objects
    #
    # @see https://p5js.org/reference/p5/touches/
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
    # @see https://processing.org/reference/loop_.html
    # @see https://p5js.org/reference/p5/loop/
    #
    def loop()
      @loop__ = true
    end

    # Disables calling draw block on every frame.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/noLoop_.html
    # @see https://p5js.org/reference/p5/noLoop/
    #
    def noLoop()
      @loop__ = false
    end

    # Calls draw block to redraw frame.
    #
    # @return [nil] nil
    #
    # @see https://processing.org/reference/redraw_.html
    # @see https://p5js.org/reference/p5/redraw/
    #
    def redraw()
      @redraw__ = true
    end

  end# Context


end# Processing
