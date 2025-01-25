require 'processing/all'


module Processing
  Processing.alias_snake_case_methods__ Processing

  WINDOW__, CONTEXT__, funcs, events = Processing.setup__ Processing

  refine Object do
    funcs.each do |func|
      define_method func do |*args, **kwargs, &block|
        CONTEXT__.__send__ func, *args, **kwargs, &block
      end
    end

    event_names = events.keys
    Object.singleton_class.define_method :method_added do |method|
      if event_names.include? method
        caller = events[method]
        CONTEXT__.__send__(method) {caller.call} if caller
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
