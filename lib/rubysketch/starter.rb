module RubySketch


  extend module Functions

    def start (context, start_at_exit: false, &block)
      start = proc do
        window = Window.new do
          context.on_start__ window
          context.instance_eval &block if block
        end
        Reflex.start {window.show}
      end

      if start_at_exit
        at_exit {start.call unless $!}
      else
        start.call
      end
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

      start context, start_at_exit: true
    end

    self

  end# Functions


  module Starter

    def start (*args, &block)
      RubySketch.start self.new(*args), start_at_exit: true, &block
    end

  end# Starter


end# RubySketch
