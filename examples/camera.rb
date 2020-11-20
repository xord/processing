%w[xot rays reflex rubysketch]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rubysketch-processing'


cam = Capture.new 300, 200, Capture.list.last
cam.start

draw do
  background 0
  image cam, 0, 0
end
