require 'rubysketch'


begin
  window  = RubySketch::Window.new {start}
  context = RubySketch::Processing::Context.new window

  (context.methods - Object.instance_methods).each do |method|
    define_method method do |*args, **kwargs, &block|
      context.__send__ method, *args, **kwargs, &block
    end
  end

  context.class.constants.each do |const|
    self.class.const_set const, context.class.const_get(const)
  end

  window.__send__ :begin_draw
  at_exit do
    window.__send__ :end_draw
    RubySketch::App.new {window.show}.start unless $!
  end
end
