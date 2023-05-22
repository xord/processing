%w[xot rays reflex processing]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'processing'
using Processing


icon = loadImage 'https://xord.org/rubysketch/images/rubysketch128.png'

draw do
  background 0, 10
  image icon, 100, 100
  filter INVERT
end
