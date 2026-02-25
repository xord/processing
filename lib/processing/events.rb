module Processing


  # Mouse wheel event object.
  #
  class WheelEvent

    # @private
    def initialize(event)
      @event = event
    end

    def delta()
      [@event.dx, @event.dy]
    end

    def getCount()
      @event.dy
    end

  end# WheelEvent


end# Processing
