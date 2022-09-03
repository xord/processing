module RubySketch


  # @private
  class GLSL

    # @private
    def initialize(window)
      @window = window
    end

    def run(shader_source)
      shader = Rays::Shader.new shader_source
      start  = now__
      @window.draw = proc do |e|
        i, p = @window.canvas_image, @window.canvas_painter
        w, h = i.width, i.height
        p.shader shader, resolution: [w, h], time: now__ - start
        p.fill 1
        p.rect 0, 0, w, h
      end
    end

    private

    # @private
    def now__()
      Time.now.to_f
    end

  end# GLSL


end# RubySketch
