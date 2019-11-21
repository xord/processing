%w[xot rays reflex rubysketch]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rubysketch'


RubySketch::GLSL.start <<END
  varying vec4 v_TexCoord;
  uniform vec2 resolution;
  uniform float time;
  void main ()
  {
    vec2 pos = v_TexCoord.xy / resolution;
    gl_FragColor = vec4(pos, float(mod(time, 1.0)), 1);
  }
END
