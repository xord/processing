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
    events  = to_snake_case__(EVENT_NAMES__).flatten.uniq
      .each.with_object({}) {|event, hash| hash[event] = -> {__send__ event}}

    return window, context, funcs, events
  end

  # @private
  def self.alias_snake_case_methods__(klass, recursive = 1)
    to_snake_case__(klass.instance_methods false)
      .reject {|camel, snake| camel =~ /__$/}
      .reject {|camel, snake| klass.method_defined? snake}
      .each   {|camel, snake| klass.alias_method snake, camel}
    if recursive > 0
      klass.constants.map {klass.const_get _1}
        .flatten
        .select {_1.class == Module || _1.class == Class}
        .each {|inner_class| alias_snake_case_methods__ inner_class, recursive - 1}
    end
  end

  # @private
  def self.to_snake_case__(camel_case_names)
    camel_case_names.map do |camel|
      snake = camel.to_s.gsub(/([a-z])([A-Z])/) {"#{$1}_#{$2.downcase}"}
      [camel, snake].map(&:to_sym)
    end
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
