%w[xot rays reflex rubysketch]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rubysketch-processing'


icon = loadImage 'https://xord.org/rubysketch/rubysketch.png'

draw do
  background 0, 10
  image icon, mouseX, mouseY, icon.width / 10, icon.height / 10
end
