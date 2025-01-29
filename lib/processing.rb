require 'processing/all'


module Processing
  WINDOW__, CONTEXT__ = Processing.setup__ Processing

  context       = CONTEXT__
  funcs, events = Processing.funcs_and_events__ context
  event_names   = events.keys

  Object.singleton_class.define_method :method_added do |method|
    if event_names.include? method
      caller = events[method]
      context.__send__(method) {caller.call} if caller
    end
  end

  refine Object do
    funcs.each do |func|
      define_method func do |*args, **kwargs, &block|
        context.__send__ func, *args, **kwargs, &block
      end
    end
  end
end# Processing


def Processing(snake_case: false)
  return Processing unless snake_case

  $processing_refinements_with_snake_case ||= Module.new do
    Processing.alias_snake_case_methods__ Processing

    context       = Processing::CONTEXT__
    funcs, events = Processing.funcs_and_events__ context, snake_case: true
    event_names   = events.keys

    Object.singleton_class.define_method :method_added do |method|
      if event_names.include? method
        caller = events[method]
        context.__send__(method) {caller.call} if caller
      end
    end

    refine Object do
      funcs.each do |func|
        define_method func do |*args, **kwargs, &block|
          context.__send__ func, *args, **kwargs, &block
        end
      end
    end
  end
end


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
