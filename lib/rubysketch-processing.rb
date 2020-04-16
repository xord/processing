require 'rubysketch'


begin
  context = RubySketch::Processing.new
  methods = context.class.instance_methods(false)
    .reject {|name| name =~ /__$/}
  consts  = context.class.constants
    .reject {|name| name =~ /__$/}
    .each_with_object({}) {|name, h| h[name] = context.class.const_get name}

  self.class.class_eval do
    methods.each do |name|
      define_method name do |*args, &block|
        context.__send__ name, *args, &block
      end
    end
    consts.each do |(name, value)|
      const_set name, value
    end
  end

  window = RubySketch::Window.new do |_|
    window.start
  end
  context.setup__ window

  window.canvas_painter.__send__ :begin_paint
  at_exit do
    window.canvas_painter.__send__ :end_paint
    Reflex.start {window.show}
  end
end
