require 'processing/all'


module Processing
  WINDOW__              = Processing.setup__ Processing
  $processing_context__ = WINDOW__.context

  refine Object do
    Processing.funcs__(WINDOW__.context).each do |func|
      define_method func do |*args, **kwargs, &block|
        $processing_context__.__send__ func, *args, **kwargs, &block
      end
    end
  end
end# Processing


def Processing(snake_case: false)
  return Processing unless snake_case

  $processing_refinements_with_snake_case ||= Module.new do
    Processing.alias_snake_case_methods__ Processing

    refine Object do
      Processing.funcs__(Processing::WINDOW__.context).each do |func|
        define_method func do |*args, **kwargs, &block|
          $processing_context__.__send__ func, *args, **kwargs, &block
        end
      end
    end
  end
end


begin
  w = Processing::WINDOW__

  w.context.class.constants
    .reject {_1 =~ /__$/}
    .each   {self.class.const_set _1, w.context.class.const_get(_1)}

  w.__send__ :begin_draw
  at_exit do
    Processing.events__(w.context).each do |event|
      m = begin method event; rescue NameError; nil end
      w.context.__send__(event) {__send__ event} if m
    end

    w.__send__ :end_draw
    Processing::App.new {w.show}.start if w.context.hasUserBlocks__ && !$!
  end
end
