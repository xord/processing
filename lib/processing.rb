require 'processing/all'


module Processing
  WINDOW  = Processing::Window.new {start}
  CONTEXT = Processing::Context.new WINDOW

  refine Object do
    (CONTEXT.methods - Object.instance_methods).each do |method|
      define_method method do |*args, **kwargs, &block|
        CONTEXT.__send__ method, *args, **kwargs, &block
      end
    end
  end
end# Processing


begin
  w, c = Processing::WINDOW, Processing::CONTEXT

  c.class.constants.each do |const|
    self.class.const_set const, c.class.const_get(const)
  end

  w.__send__ :begin_draw
  at_exit do
    w.__send__ :end_draw
    Processing::App.new {w.show}.start if c.hasDrawBlock__ && !$!
  end
end
