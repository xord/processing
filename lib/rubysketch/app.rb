module RubySketch


  class App < Reflex::Application

    def on_motion (e)
      RubySketch.instance_variable_get(:@window)&.on_motion e
    end

  end# App


end# RubySketch
