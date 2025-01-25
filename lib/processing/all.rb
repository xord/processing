module Processing

  # @private
  EVENT_NAMES__ = %i[
    setup draw
    keyPressed keyReleased keyTyped
    mousePressed mouseReleased mouseMoved mouseDragged
    mouseClicked doubleClicked mouseWheel
    touchStarted touchEnded touchMoved
    windowMoved windowResized motion
  ]

  # @private
  def self.setup__(namespace)
    w = (ENV['WIDTH']  || 500).to_i
    h = (ENV['HEIGHT'] || 500).to_i

    window  = Processing::Window.new(w, h) {start}
    context = namespace::Context.new window
    funcs   = (context.methods - Object.instance_methods)
      .reject {_1 =~ /__$/} # methods for internal use
    events  = EVENT_NAMES__
      .each.with_object({}) {|event, hash| hash[event] = -> {__send__ event}}

    return window, context, funcs, events
  end

end# Processing


require 'set'
require 'strscan'
require 'digest/sha1'
require 'pathname'
require 'tmpdir'
require 'uri'
require 'rexml'
require 'net/http'
require 'xot/inspectable'
require 'reflex'

require 'processing/extension'
require 'processing/app'
require 'processing/window'

require 'processing/vector'
require 'processing/image'
require 'processing/font'
require 'processing/touch'
require 'processing/shape'
require 'processing/svg'
require 'processing/shader'
require 'processing/capture'
require 'processing/graphics_context'
require 'processing/graphics'
require 'processing/events'
require 'processing/context'
