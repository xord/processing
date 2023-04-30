# processing ChangeLog


## [v0.5.5] - 2023-04-30

- Update documents


## [v0.5.4] - 2023-04-25

- Update reflex to v0.1.34


## [v0.5.3] - 2023-04-22

- Delete RubyProcessing.podspec
- Do not depend on Beeps
- If there are no user blocks, the window is not displayed and exits


## [v0.5.2] - 2023-03-02

- delete rubysketch.rb and rubysketch-processing.rb


## [v0.5.1] - 2023-03-01

- requiring 'rubysketch-processing' is deprecated


## [v0.5.0] - 2023-02-09

- requiring 'processing/include' is deprecated
- require 'processing' and 'using Processing' is now required
- do not show the window if a draw block is not given


## [v0.4.0] - 2022-12-29

- renamed from rubysketch.gem to processing.gem
- renamed from RubySketch Pod to RubyProcessing Pod
- delete glsl mode


## [v0.3.22] - 2022-11-14

RubySketch::Processing
- add Shader class
- add shader(), resetShader(), createShader(), loadShader(), and filter()
- update the pixel density of context if the screen pixel density is changed
- setUniform() can also take array of numbers, vector, and texture image.
- pushStyle() manages states of textAlign, tint, and filter
- push/pushMatrix/pushStyle call pop() on ensure

RubySketch::GLSL
- displays with pixel density 1.0


## [v0.3.21] - 2022-09-05

- add rubysketch-glsl.rb
- add blend(), createImage(), setTitle(), tint() and noTint()
- add save() that saves screen image to file
- circle() function is affected by ellipseMode()
- point() draws by line(x, y, x, y)
- change initial values for strokeCap and strokeJoin to ROUND and MITER


## [v0.3.20] - 2022-07-24

- add mouseClicked()
- add blendMode()
- add clip() and noClip()
- translate() can take 'z' parameter
- fix that resizing canvas consumes too much memory


## [v0.3.19] - 2021-12-5

- fix runtime error


## [v0.3.18] - 2021-12-5

- add 'mouseButton'
- pointer cancel event calls pointer_up block


## [v0.3.17] - 2021-12-5

- add Touch#id


## [v0.3.16] - 2021-2-14

- add key, keyCode and keyPressed system values
- add keyPressed(), keyReleased() and keyTyped() functions
- add motionGravity value and motion() function


## [v0.3.15] - 2020-12-12

- delete temporary directory on launch


## [v0.3.14] - 2020-12-12

- fix loadImage() fails when Encoding.default_internal is not nil


## [v0.3.13] - 2020-12-12

- size(), createCanvas(): default pixelDensity is same as current value


## [v0.3.12] - 2020-12-10

- size() and createCanvas() take 'pixelDensity' parameter and default value is 1


## [v0.3.11] - 2020-12-9

- add size(), createCanvas() and pixelDensity()


## [v0.3.10] - 2020-12-1

- invert angle parameter value for arc() to fix compatibility to processing API


## [v0.3.9] - 2020-11-30

- Graphics#beginDraw() can take block to call endDraw automatically
- Capture#start() always returns nil
- add delay_camera.rb


## [v0.3.8] - 2020-11-27

- Capture#initialize() can take requestWidth, requestHeight and cameraName
- add Capture#width and Capture#height


## [v0.3.7] - 2020-11-18

- add Capture class
- add log(), exp(), sqrt() and PI
- add examples/camera.rb
- add examples/breakout.rb
- fix error on calling image()


## [v0.3.6] - 2020-08-02

- random() can take array or nothing
- use github actions to release gem package


## [v0.3.5] - 2020-08-02

- add random()
- add sin(), cos(), tan(), asin(), acos(), atan() and atan2()
- make Vector class accessible from user script context
- fix error on calling rotate()


## [v0.3.4] - 2020-08-02

- delete Utility module


## [v0.3.3] - 2020-08-01

- add Vector class


## [v0.3.2] - 2020-07-22

- text() draws to the baseline by default
- add textWidth(), textAscent(), textDescent() and textAlign()
- change initial color for fill() and stroke()
- change initial background color to grayscale 0.8


## [v0.3.1] - 2020-07-17

- add touchStarted(), touchEnded(), touchMoved() and touches()
- make all event handler drawable
- limit font max size to 256


## [v0.3.0] - 2020-05-21

- add createGraphics()


## [v0.2.7] - 2020-04-17

- add strokeCap() and strokeJoin()


## [v0.2.6] - 2020-04-17

- push(), pushMatrix() and pushStyle() take block to automatic pop
- refine startup process
- add curve() and bezier()
- add imageMode(), Image#resize(), Image#copy() and copy()
- add loop(), noLoop() and redraw()


## [v0.2.5] - 2020-03-29

- delete debug prints
- show unsupported image type
