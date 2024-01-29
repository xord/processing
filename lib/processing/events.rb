module Processing


  # Mouse wheel event object.
  #
  class WheelEvent

    # @private
    def initialize(event)
      @event = event
    end

    def delta()
      @event.dy
    end

    alias getCount delta

  end# WheelEvent


end# Processing
