require 'rubysketch'


begin
  include RubySketch::Processing::Context

  window = RubySketch::Window.new {start}
  setup__ window

  window.__send__ :begin_draw
  at_exit do
    window.__send__ :end_draw
    Reflex.start {window.show} unless $!
  end
end
