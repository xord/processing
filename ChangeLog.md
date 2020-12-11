# RubySketch ChangeLog


## [0.3.13] - 2020-12-12

- size(), createCanvas(): default pixelDensity is same as current value


## [0.3.12] - 2020-12-10

- size() and createCanvas() take 'pixelDensity' parameter and default value is 1


## [0.3.11] - 2020-12-9

- add size(), createCanvas() and pixelDensity()


## [0.3.10] - 2020-12-1

- invert angle parameter value for arc() to fix compatibility to processing API


## [0.3.9] - 2020-11-30

- Graphics#beginDraw() can take block to call endDraw automatically
- Capture#start() always returns nil
- add delay_camera.rb


## [0.3.8] - 2020-11-27

- Capture#initialize() can take requestWidth, requestHeight and cameraName
- add Capture#width and Capture#height


## [0.3.7] - 2020-11-18

- add Capture class
- add log(), exp(), sqrt() and PI
- add examples/camera.rb
- add examples/breakout.rb
- fix error on calling image()


## [0.3.6] - 2020-08-02

- random() can take array or nothing
- use github actions to release gem package


## [0.3.5] - 2020-08-02

- add random()
- add sin(), cos(), tan(), asin(), acos(), atan() and atan2()
- make Vector class accessible from user script context
- fix error on calling rotate()


## [0.3.4] - 2020-08-02

- delete Utility module


## [0.3.3] - 2020-08-01

- add Vector class


## [0.3.2] - 2020-07-22

- text() draws to the baseline by default
- add textWidth(), textAscent(), textDescent() and textAlign()
- change initial color for fill() and stroke()
- change initial background color to grayscale 0.8


## [0.3.1] - 2020-07-17

- add touchStarted(), touchEnded(), touchMoved() and touches()
- make all event handler drawable
- limit font max size to 256


## [0.3.0] - 2020-05-21

- add createGraphics()


## [0.2.7] - 2020-04-17

- add strokeCap() and strokeJoin()


## [0.2.6] - 2020-04-17

- push(), pushMatrix() and pushStyle() take block to automatic pop
- refine startup process
- add curve() and bezier()
- add imageMode(), Image#resize(), Image#copy() and copy()
- add loop(), noLoop() and redraw()


## [0.2.5] - 2020-03-29

- delete debug prints
- show unsupported image type
