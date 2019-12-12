module RubySketch


  extend module Functions

    def start (context, start_at_exit: false, &block)
      window = Window.new do
        context.instance_eval &block if block
      end

      context.on_start__ window

      start = proc do
        Reflex.start {window.show}
      end

      if start_at_exit
        at_exit {start.call unless $!}
      else
        start.call
      end

      window
    end

    private

    def start_on_object_at_exit (object, context)
      klass   = context.class
      methods = klass.instance_methods(false)
        .reject {|name| name =~ /__$/}
      consts  = klass.constants
        .reject {|name| name =~ /__$/}
        .each_with_object({}) {|name, h| h[name] = klass.const_get name}

      object.class.class_eval do
        methods.each do |name|
          define_method name do |*args, &block|
            context.__send__ name, *args, &block
          end
        end
        consts.each do |(name, value)|
          const_set name, value
        end
      end

      window = start context, start_at_exit: true

      window.canvas_painter.__send__ :begin_paint
      at_exit {window.canvas_painter.__send__ :end_paint}
    end

    self

  end# Functions


  module Starter

    def start (*args, &block)
      RubySketch.start self.new(*args), start_at_exit: true, &block
    end

  end# Starter


end# RubySketch
