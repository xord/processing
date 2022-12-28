%w[xot rays reflex processing]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'processing/include'


draw do
  background 0, 10
  textSize 50
  text 'hello, world!', mouseX, mouseY
end
