module Processing


  # Camera object.
  #
  class Capture

    # Returns a list of available camera device names
    #
    # @return [Array] device name list
    #
    def self.list()
      Rays::Camera.device_names
    end

    # Initialize camera object.
    #
    # @overload Capture.new()
    # @overload Capture.new(cameraName)
    # @overload Capture.new(requestWidth, requestHeight)
    # @overload Capture.new(requestWidth, requestHeight, cameraName)
    #
    # @param requestWidth  [Integer] captured image width
    # @param requestHeight [Integer] captured image height
    # @param cameraName    [String]  camera device name
    #
    def initialize(*args)
      width, height, name =
        if args.empty?
          [-1, -1, nil]
        elsif args[0].kind_of?(String)
          [-1, -1, args[0]]
        elsif args[0].kind_of?(Numeric) && args[1].kind_of?(Numeric)
          [args[0], args[1], args[2]]
        else
          raise ArgumentError
        end
      @camera = Rays::Camera.new width, height, device_name: name
    end

    # Start capturing.
    #
    # @return [nil] nil
    #
    def start()
      raise "Failed to start capture" unless @camera.start
      nil
    end

    # Stop capturing.
    #
    # @return [nil] nil
    #
    def stop()
      @camera.stop
      nil
    end

    # Returns is the next captured image available?
    #
    # @return [Boolean] true means object has next frame
    #
    def available()
      @camera.active?
    end

    # Reads next frame image
    #
    def read()
      @camera.image
    end

    # Returns the width of captured image
    #
    # @return [Numeric] the width of captured image
    #
    def width()
      @camera.image&.width || 0
    end

    # Returns the height of captured image
    #
    # @return [Numeric] the height of captured image
    #
    def height()
      @camera.image&.height || 0
    end

    # Applies an image filter.
    #
    # overload filter(shader)
    # overload filter(type)
    # overload filter(type, param)
    #
    # @param shader [Shader]  a fragment shader to apply
    # @param type   [THRESHOLD, GRAY, INVERT, BLUR] filter type
    # @param param  [Numeric] a parameter for each filter
    #
    def filter(*args)
      @filter = Shader.createFilter__(*args)
    end

    # @private
    def getInternal__()
      @camera.image || (@dummyImage ||= Rays::Image.new 1, 1)
    end

    # @private
    def drawImage__(painter, *args, **states)
      shader = painter.shader || @filter&.getInternal__
      painter.push shader: shader, **states do |_|
        painter.image getInternal__, *args
      end
    end

  end# Capture


end# Processing
