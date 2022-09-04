require 'rubysketch'


def (RubySketch::GLSL).run(
    shader_source,
    title: 'RubySketch',
    width: 500, height: 500)
  w = RubySketch::Window.new(title: title, w: width, h: height) {start}
  RubySketch::GLSL::Context.new w, shader_source
  at_exit {RubySketch::App.new {w.show}.start unless $!}
end
