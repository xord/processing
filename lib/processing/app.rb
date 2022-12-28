module Processing


  class App < Reflex::Application

    def on_motion(e)
      Processing.instance_variable_get(:@window)&.on_motion e
    end

  end# App


end# Processing
