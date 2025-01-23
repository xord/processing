require 'processing/all'


module Processing
  w         = (ENV['WIDTH']  || 500).to_i
  h         = (ENV['HEIGHT'] || 500).to_i
  WINDOW__  = Processing::Window.new(w, h) {start}
  CONTEXT__ = Processing::Context.new WINDOW__
  BINDING__ = binding

  refine Object do
    (CONTEXT__.methods - Object.instance_methods)
      .reject {_1 =~ /__$/} # methods for internal use
      .each do |method|
        define_method method do |*args, **kwargs, &block|
          CONTEXT__.__send__ method, *args, **kwargs, &block
        end
      end

    def Object.method_added(method)
      if Processing::Context::EVENT_NAMES__.include? method
        CONTEXT__.__send__(method) {BINDING__.eval method.to_s}
      end
    end
  end
end# Processing


begin
  w, c = Processing::WINDOW__, Processing::CONTEXT__

  c.class.constants.reject {_1 =~ /__$/}.each do |const|
    self.class.const_set const, c.class.const_get(const)
  end

  w.__send__ :begin_draw
  at_exit do
    w.__send__ :end_draw
    Processing::App.new {w.show}.start if c.hasUserBlocks__ && !$!
  end
end
