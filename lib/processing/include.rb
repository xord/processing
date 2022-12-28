require 'processing'


begin
  window  = Processing::Window.new {start}
  context = Processing::Processing::Context.new window

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
    Processing::App.new {window.show}.start unless $!
  end

  PROCESSING_WINDOW = window
end
