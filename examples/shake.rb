%w[xot rays reflex processing]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'processing'
using Processing

shake = 0

draw do
  background 100

  v = Vector.random2D * shake
  translate v.x, v.y
  shake *= 0.8

  textSize 50
  text 'hello, world!', 30, 50
  rect 100, 100, 200, 100
end

mouseClicked do
  shake = 10
end
