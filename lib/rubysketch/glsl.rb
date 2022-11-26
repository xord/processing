module RubySketch


  # OpenGL Shader Language
  #
  module GLSL


    # @private
    class Context

      # @private
      def initialize(window)
        @window = window
        @window.resize_canvas window.width, window.height, 1
      end

      def run(shader_source)
        shader = Rays::Shader.new(
          shader_source, ignore_no_uniform_location_error: true)
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

    end# Context


  end# GLSL


end# RubySketch
