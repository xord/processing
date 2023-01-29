require 'processing/all'


module Processing
  WINDOW  = Processing::Window.new {start}
  context = Processing::Context.new WINDOW

  refine Object do
    (context.methods - Object.instance_methods).each do |method|
      define_method method do |*args, **kwargs, &block|
        context.__send__ method, *args, **kwargs, &block
      end
    end

    context.class.constants.each do |const|
      self.class.const_set const, context.class.const_get(const)
    end
  end
end# Processing


begin
  w = Processing::WINDOW
  w.__send__ :begin_draw
  at_exit do
    w.__send__ :end_draw
    Processing::App.new {w.show}.start unless $!
  end
end
