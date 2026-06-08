require 'set'
require 'strscan'
require 'digest/sha1'
require 'pathname'
require 'tmpdir'
require 'uri'
require 'rexml'
require 'xot/inspectable'
require 'xot/util'
require 'reflex'


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

  SUFFIX_PRIVATE = /__[!?]?$/

  $processing_context__ = nil

  # Returns current processing context.
  #
  # @return [Processing::Context] context
  #
  def self.context()
    $processing_context__
  end

  # @private
  def self.setup__(window_class, context_class)
    tmpdir__.tap {|dir| FileUtils.rm_r dir.to_s if dir.directory?} unless Xot.wasm?

    w = (ENV['WIDTH']  || 500).to_i
    h = (ENV['HEIGHT'] || 500).to_i
    window_class.new w, h, context_class: context_class
  end

  # @private
  def self.funcs__(context_class)
    (context_class.instance_methods - Object.instance_methods)
      .reject {_1 =~ SUFFIX_PRIVATE} # methods for internal use
  end

  # @private
  def self.events__(context_class)
    methods = context_class.instance_methods
    to_snake_case__(EVENT_NAMES__).flatten.uniq.select {methods.include? _1}
  end

  # @private
  def self.alias_snake_case_methods__(klass, recursive = 1)
    to_snake_case__(klass.instance_methods false)
      .reject {|camel, _|     camel =~ SUFFIX_PRIVATE}
      .reject {|camel, snake| camel == snake}
      .each do |camel, snake|
        klass.remove_method snake if klass.method_defined?(snake, false)
        klass.alias_method snake, camel
      end
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

  # @private
  def self.tmpdir__()
    Pathname(Dir.tmpdir) + Digest::SHA1.hexdigest(name)
  end

end# Processing


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
