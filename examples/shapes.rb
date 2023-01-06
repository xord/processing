%w[xot rays reflex processing]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'processing'


setup do
  colorMode RGB, 1
  angleMode DEGREES
end

draw do
  background 0

  fill 1
  stroke 1, 0.5, 0.2

  translate 10, 10

  push

  text 'point', 0, 0
  point 0, 30

  translate 0, 100

  text 'point with strokeWeight', 0, 0
  strokeWeight 10
  point 0, 30
  strokeWeight 0

  translate 0, 100

  text 'line', 0, 0
  line 0, 30, 100, 50

  translate 0, 100

  text 'line with strokeWeight (very slow)', 0, 0
  strokeWeight 10
  line 0, 30, 100, 50
  strokeWeight 1

  translate 0, 100

  text 'rect with rectMode(CORNER)', 0, 0
  rectMode CORNER
  rect 20, 30, 100, 50

  translate 0, 100

  text 'rect with rectMode(CORNERS)', 0, 0
  rectMode CORNERS
  rect 20, 30, 120, 80

  translate 0, 100

  text 'rect with rectMode(CENTER)', 0, 0
  rectMode CENTER
  rect 70, 55, 100, 50

  translate 0, 100

  text 'rect with rectMode(RADIUS)', 0, 0
  rectMode RADIUS
  rect 70, 55, 50, 25

  pop
  translate 200, 0
  push

  text 'circle', 0, 0
  circle 70, 55, 25

  translate 0, 100

  text 'arc', 0, 0
  arc 70, 55, 100, 50, 45, 270

  translate 0, 100

  text 'square', 0, 0
  square 20, 30, 50

  translate 0, 100

  text 'triangle', 0, 0
  triangle 70, 30, 120, 80, 20, 80

  translate 0, 100

  text 'quad', 0, 0
  quad 20, 30, 120, 30, 150, 80, 50, 80

  translate 0, 100

  text 'ellipse with ellipseMode(CORNER)', 0, 0
  ellipseMode CORNER
  ellipse 20, 30, 100, 50

  translate 0, 100

  text 'ellipse with ellipseMode(CORNERS)', 0, 0
  ellipseMode CORNERS
  ellipse 20, 30, 120, 80

  translate 0, 100

  text 'ellipse with ellipseMode(CENTER)', 0, 0
  ellipseMode CENTER
  ellipse 70, 55, 100, 50

  translate 0, 100

  text 'ellipse with ellipseMode(RADIUS)', 0, 0
  ellipseMode RADIUS
  ellipse 70, 55, 50, 25

  pop
end
