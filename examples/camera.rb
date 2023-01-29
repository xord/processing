%w[xot rays reflex processing]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'processing'
using Processing


cam = Capture.new 300, 300
cam.start

draw do
  background 0
  image cam, 0, 0
end
