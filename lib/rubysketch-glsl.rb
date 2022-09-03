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


Warning.extend Module.new {
  def warn(*a, **k)
    super unless
      a.first =~ /redefining Object#method_missing may cause infinite loop/
  end
}

def method_missing(*); end
def (self.class).const_missing(*); end


run File.read($0).sub(/.*require[^\n]*\n/m, '')
