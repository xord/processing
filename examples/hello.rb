%w[xot rays reflex rubysketch]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rubysketch-processing'


RubySketch::Processing.start do
  draw do
    textSize 50
    text 'hello, world!', 10, 10
  end
end
