require 'rubysketch'


begin
  window  = RubySketch::Window.new(title: 'RubySketch') {start}
  context = RubySketch::GLSL.new window

  define_method :run do |shader_source|
    context.run shader_source
  end

  at_exit do
    RubySketch::App.new {window.show}.start unless $!
  end
end
