%w[xot rays reflex processing]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'processing'

COLORS = %w[ #F99292 #FFBC61 #FFC679 #FFF4E0 ]

def now ()
  Time.now.to_f
end

start = now

setup do
  colorMode RGB, 1
  angleMode DEGREES
end

draw do
  background 0

  pushMatrix do
    translate width / 2, height / 2

    pushMatrix do
      fill COLORS[0]
      ellipse 0, 0, 20, 20
      rotate (now - start) / 60.0 * 360
      stroke COLORS[0]
      strokeWeight 5
      line 0, 0, 200, 0
      fill 1
    end

    pushMatrix do
      strokeWeight 3
      60.times do
        rotate 6
        stroke COLORS[1]
        line 200, 0, 210, 0
      end
    end

    pushMatrix do
      strokeWeight 5
      12.times do
        rotate 30
        stroke COLORS[3]
        line 190, 0, 210, 0
      end
    end
  end

  textSize 20
  text "#{frameRate.to_i} FPS", 10, 10
end
