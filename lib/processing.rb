require 'processing/all'


module Processing
  WINDOW__, CONTEXT__ = Processing.setup__ Processing

  refine Object do
    context = CONTEXT__
    Processing.funcs__(context).each do |func|
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

    refine Object do
      context = Processing::CONTEXT__
      Processing.funcs__(context).each do |func|
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
    Processing.events__(c).each do |event|
      m = begin method event; rescue NameError; nil end
      c.__send__(event) {__send__ event} if m
    end

    w.__send__ :end_draw
    Processing::App.new {w.show}.start if c.hasUserBlocks__ && !$!
  end
end
