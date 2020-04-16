module RubySketch


  # @private
  class GLSL

    def initialize (glsl)
      @shader = Reflex::Shader.new glsl
    end

    # @private
    def on_start__ (window)
      start = Time.now.to_f

      window.draw = proc do |e, painter|
        painter.paint do |p|
          c = window.canvas
          w = c.width
          h = c.height
          t = Time.now.to_f - start
          p.shader @shader, resolution: [w, h], time: t if @shader
          p.fill 1
          p.rect 0, 0, w, h
        end
      end
    end

  end# GLSL


end# RubySketch
