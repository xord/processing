%w[xot rays reflex rubysketch]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rubysketch-glsl'

run <<END
  uniform vec2 resolution;
  uniform float time;
  void main() {
    vec2 pos = gl_FragCoord.xy / resolution;
    gl_FragColor = vec4(pos * abs(sin(time)), 0, 1);
  }
END
