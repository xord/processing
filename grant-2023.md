# 2023 年度 Ruby アソシエーション開発助成金 最終報告

## 1. はじめに

この資料は、「2023 年度 Ruby アソシエーション開発助成金」制度で採択された「CRuby 用 Processing Gem の、本家 Processing との互換性向上に向けた取り組み」についての最終報告書になります。

## 2. プロジェクト概要

クリエイティブコーディングの世界では [Processing](https://processing.org/) や [p5.js](https://p5js.org/) のようなフレームワークが広く利用されています。これらを利用することで、フレームワーク利用者はグラフィックスと視覚的な表現を駆使したアートやインタラクティブなアプリケーションを簡単に作成することができます。

このプロジェクトではその Processing/p5.js の API と互換性のある CRuby 向けの Processing Gem をゼロから開発しており、現時点で Processing の主要な機能の約7割から8割を実装済みとしています。

本取り組みではその残りの未実装となっている機能を実装することで、Ruby プログラマーが、広く知られた Processing API を使用して手軽にグラフィックスプログラミングを行えるよう支援するものです。

## 3. 開発計画

Processing との互換性を向上させるため、まずは本取り組みで実装する予定の具体的な開発項目を18に分け GitHub のイシューとしました。これらをさらにグルーピング＆優先度付けし、GitHub の[マイルストーン](https://github.com/xord/processing/milestones)にまとめたのが以下になります。

- Milestone: [ProcessingAPI 実装 高難度グループ Shape 関連](https://github.com/xord/processing/milestone/3?closed=1)
  - Issue: [shape() と基本的な関数群](https://github.com/xord/processing/issues/19)
  - Issue: [Shape クラス](https://github.com/xord/processing/issues/20)
  - Issue: [texture() 関連と vertex(x, y, u, v)](https://github.com/xord/processing/issues/21)
  - Issue: [Shape に fill と stroke を含める](https://github.com/xord/processing/issues/22)

- Milestone: [ProcessingAPI 実装 高難度グループ その他](https://github.com/xord/processing/milestone/4?closed=1)
  - Issue: [begin/endContour() と bezier/curve/quadraticVertex()](https://github.com/xord/processing/issues/23)
  - Issue: [preload() と requestImage()](https://github.com/xord/processing/issues/18)
  - Issue: [loadFont() と Font.list()](https://github.com/xord/processing/issues/17)

- Milestone: [ProcessingAPI 実装 中難度グループ](https://github.com/xord/processing/milestone/2)
  - Issue: [Image のピクセル操作関数](https://github.com/xord/processing/issues/11)
  - Issue: [textLeading](https://github.com/xord/processing/issues/16)
  - Issue: [random と noise](https://github.com/xord/processing/issues/15)
  - Issue: [curve 関数](https://github.com/xord/processing/issues/14)
  - Issue: [bezier 関数](https://github.com/xord/processing/issues/13)
  - Issue: [smooth() と fullScreen()](https://github.com/xord/processing/issues/12)

- Milestone: [ProcessingAPI 実装 低難度グループ](https://github.com/xord/processing/milestone/1)
  - Issue: [座標変換関数](https://github.com/xord/processing/issues/10)
  - Issue: [マウス・キーボードイベント](https://github.com/xord/processing/issues/9)
  - Issue: [その他](https://github.com/xord/processing/issues/8)

- Milestone: [ProcessingAPI 実装 低優先度グループ](https://github.com/xord/processing/milestone/5)
  - Issue: [acceleration と rotation()](https://github.com/xord/processing/issues/24)
  - Issue: [loadShape()](https://github.com/xord/processing/issues/25)

マイルストーンは優先度の高い順で並べ、開発期間中は上から順に実装を進めました。

## 4. 開発の成果

現在は開発を終え、上記すべてのマイルストーンをクローズするに至っております。

ここからはその成果の報告として、各マイルストーンとイシュー個別の詳細を記載していきます。

### 4.1 [ProcessingAPI 実装 高難度グループ Shape 関連](https://github.com/xord/processing/milestone/3?closed=1)

このマイルストーンでは、Shape 描画関連の機能を実装しています。

![](https://storage.googleapis.com/zenn-user-upload/95266ac5d6a5-20240104.png)

#### 4.1.1 [shape() と基本的な関数群](https://github.com/xord/processing/issues/19)

このイシューでは [beginShape()](https://processing.org/reference/beginShape_.html)、[endShape()](https://processing.org/reference/endShape_.html)、[vertex()](https://processing.org/reference/vertex_.html) を実装しました。
これらを使うことで、任意の数の頂点を指定して形状を描画することができるようになりました。

```ruby
setup do
  createCanvas(256, 256)
end
draw do
  background(100)

  # 形状の描画を開始
  beginShape(TRIANGLE_STRIP)

  # 7頂点の指定
  vertex(30, 75)
  vertex(40, 20)
  vertex(50, 75)
  vertex(60, 20)
  vertex(70, 75)
  vertex(80, 20)
  vertex(90, 75)

  # 描画処理ここまで
  endShape()
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/57184fabd863-20240104.png" width="200"> _Ruby 版 Processing gem の描画結果_

<img src="https://storage.googleapis.com/zenn-user-upload/3a79b2d5def4-20240104.png" width="200"> _Java 版 Processing の描画結果_

また [createShape()](https://processing.org/reference/createShape_.html) と [shape()](https://processing.org/reference/shape_.html) も実装しています。
これらを使うことで、予め形状データを作成することができ、形状をグルーピングしたり任意のタイミングで描画することができるようになりました。

```ruby
setup do
  createCanvas(256, 256)
end
draw do
  background(100)

  # 親グループを作成
  group = createShape(GROUP)
  
  # 子形状を作成
  shape1 = createShape(RECT, 10, 10, 50, 50)
  shape2 = createShape(ELLIPSE, 20, 20, 50, 50)

  # 親グループに追加
  group.addChild(shape1)
  group.addChild(shape2)

  # グループを指定して描画
  shape(group, 100, 100)
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/9aceeb9123d6-20240104.png" width="200"> _Ruby 版 Processing gem の描画結果_

<img src="https://storage.googleapis.com/zenn-user-upload/a8a3b2f6b5eb-20240104.png" width="200"> _Java 版 Processing の描画結果_

実装は以下の順で進めました。

1. [Rays::Polygon.new() can take DrawMode](https://github.com/xord/all/pull/2)<br>
Processing gem は Ruby で実装されていますが、依存ライブラリとして C++ で実装したレイヤーがあり、その C++ 実装部分に [beginShape()](https://processing.org/reference/beginShape_.html), [endShape()](https://processing.org/reference/endShape_.html), [vertex()](https://processing.org/reference/vertex_.html) を実装するために必要な機能を実装しました。

2. [Add beginShape(), endShape(), and vertex(x, y)](https://github.com/xord/all/pull/3)<br>
1 で実装した機能をベースに Processing gem に beginShape()、endShape()、vertex(x, y) を追加しました。

3. [Add shape(), createShape(), shapeMode(), and Shape class](https://github.com/xord/all/pull/7)<br>
shape()、shapeMode()、createShape() を実装しました。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/19)をクローズしております。

#### 4.1.2 [Shape クラス](https://github.com/xord/processing/issues/20)

このイシューでは [PShape](https://processing.org/reference/PShape.html) クラスを実装しました。
[PShape](https://processing.org/reference/PShape.html) クラスの [beginShape()](https://processing.org/reference/beginShape_.html)、[endShape()](https://processing.org/reference/endShape_.html)、[vertex()](https://processing.org/reference/vertex_.html) を使うことで任意の形状を [PShape](https://processing.org/reference/PShape.html) クラスのインスタンスとして使い回す事ができるようになりました。

```ruby
setup do
  createCanvas(256, 256)
end
draw do
  background(100)

  # 形状オブジェクトを作成
  s = createShape()

  # 形状データの指定を開始
  s.beginShape(TRIANGLE_STRIP)

  # 7頂点の指定
  s.vertex(30, 75)
  s.vertex(40, 20)
  s.vertex(50, 75)
  s.vertex(60, 20)
  s.vertex(70, 75)
  s.vertex(80, 20)
  s.vertex(90, 75)

  # 形状データの指定ここまで
  s.endShape()

  # 座標を変えて2回描画
  shape(s, 0, 0)
  shape(s, 100, 100)
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/a399a4399a8e-20240104.png" width="200"> _Ruby 版 Processing gem の描画結果_

<img src="https://storage.googleapis.com/zenn-user-upload/777550cb356d-20240104.png" width="200"> _Java 版 Processing の描画結果_

実装は以下の順で進めました。

1. [Add shape(), createShape(), shapeMode(), and Shape class](https://github.com/xord/all/pull/7)<br>
createShape() して shape() で描画するために最低限の Shape クラスを実装しました。

2. [Add Shape's beginShape(), endShape(), ane vertex(x, y)](https://github.com/xord/all/pull/8)<br>
Shape クラスに beginShape()、endShape()、vertex(x, y) を実装しました。

3. [Add Shape's setVertex(), getVertex(), and getVertexCount()](https://github.com/xord/all/pull/9)<br>
Shape クラスに setVertex()、getVertex()、getVertexCount() を実装しました。

4. [Shape grouping](https://github.com/xord/all/pull/10)<br>
Shape のグルーピングに対応しました。

5. [Shape transformation()](https://github.com/xord/all/pull/11)<br>
Shape クラスに translate()、rotate()、scale()、resetMatrix() を追加しました。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/20)をクローズしております。

#### 4.1.3 [texture() 関連と vertex(x, y, u, v)](https://github.com/xord/processing/issues/21)

このイシューでは [vertex()](https://processing.org/reference/vertex_.html) と [texture()](https://processing.org/reference/texture_.html) を実装しました。
[vertex()](https://processing.org/reference/vertex_.html) にテクスチャ座標を、[texture()](https://processing.org/reference/texture_.html) にテクスチャ画像を指定してテクスチャを描画することができるようになりました。

```ruby
tex = nil
setup do
  createCanvas(256, 256)

  # 画像を読み込む
  tex = loadImage("texture.png")
end
draw do
  background(100)

  # 形状の描画を開始
  beginShape(QUADS)

  # テクスチャに画像を指定
  texture(tex)

  # 頂点の座標とテクスチャ座標を指定
  vertex(50,  50,  261, 87)
  vertex(150, 50,  547, 87)
  vertex(200, 200, 547, 325)
  vertex(100, 200, 261, 325)

  # 描画処理ここまで
  endShape()
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/0ec9ae73600b-20240104.png" width="200"> _Ruby 版 Processing gem の描画結果_

<img src="https://storage.googleapis.com/zenn-user-upload/62328f1f48ef-20240104.png" width="200"> _Java 版 Processing の描画結果_

実装は以下の順で進めました。

1. [Use earcut.hpp for polygon triangulation](https://github.com/xord/all/pull/12)<br>
準備として、C++ レイヤーで使用していた三角形分割ライブラリを poly2tri から earcut.hpp に変更しました。

2. [Polygon with colors and texcoords](https://github.com/xord/all/pull/15)<br>
Shape の内部実装として使っている C++ の Polygon クラスにテクスチャ座標（と色）情報を追加しました。

3. [Add textureMode() and textureWrap()](https://github.com/xord/all/pull/16)<br>
テクスチャ座標と座標範囲外の設定を追加しました。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/21)をクローズしております。

#### 4.1.4 [Shape に fill と stroke を含める](https://github.com/xord/processing/issues/22)

このイシューでは [vertex()](https://processing.org/reference/vertex_.html) を修正しており、頂点を登録する時にあらかじめ [fill()](https://processing.org/reference/fill_.html) を呼んでおくことで各頂点に個別に色を指定できるようになりました。

```ruby
setup do
  createCanvas(256, 256)
end
draw do
  background(100)

  # 形状の描画を開始
  beginShape(QUADS)

  # 頂点の色と座標を個別に指定
  fill(255, 0, 0)
  vertex(50,  50,  261, 87)

  fill(0, 255, 0)
  vertex(150, 50,  547, 87)

  fill(0, 0, 255)
  vertex(200, 200, 547, 325)

  fill(255, 255, 0)
  vertex(100, 200, 261, 325)

  # 描画処理ここまで
  endShape()
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/f264c90642b6-20240104.png" width="200"> _Ruby 版 Processing gem の描画結果_

<img src="https://storage.googleapis.com/zenn-user-upload/382c66366ee8-20240104.png" width="200"> _Java 版 Processing の描画結果_

実装は以下の順で進めました。

1. [vertex() records each color](https://github.com/xord/all/pull/17)<br>
vertex() が fill() の色を頂点色として保存するようになりました。

2. [Add Polyline#dup](https://github.com/xord/all/pull/19)<br>
Shape クラスが内部で使っている Polygon クラスに賢い dup() を追加し、dup(colors: [rgb, rgb, rgb, ...]) で色だけ差し替えられるように修正しました。
（こちらは後日 Polyline#with にリネームしています）

3. [Add setFill() to Shape class](https://github.com/xord/all/pull/18)<br>
Shape#setFill を追加し、あとから Shape の色を変更できるようにしました。

`fill()` と同様 `stroke()` の頂点色指定にも対応する予定でしたが、C++ レイヤーの内部構造的に現時点で実装が難しいことが判明したため一旦ここでは実装しないこととしました。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/22)をクローズしております。

### 4.2 [ProcessingAPI 実装 高難度グループ その他](https://github.com/xord/processing/milestone/4?closed=1)

このマイルストーンでは、本取り組みで開発予定のうち、難易度高めグループの残りの機能を実装しています。

![](https://storage.googleapis.com/zenn-user-upload/8e9c9a96e7c1-20240104.png)

#### 4.2.1 [begin/endContour() と bezier/curve/quadraticVertex()](https://github.com/xord/processing/issues/23)

このイシューでは [beginContour()](https://processing.org/reference/beginContour_.html) と [endContour()](https://processing.org/reference/PShape_endContour_.html) を実装しました。
これらを使うことで形状に穴を開けて描画することができるようになりました。

```ruby
setup do
  createCanvas(256, 256)
end
draw do
  background(100)

  # 形状の描画を開始
  beginShape()

  # 外枠の頂点を指定
  vertex(50,  50)
  vertex(150, 50)
  vertex(200, 200)
  vertex(100, 200)

  # 穴形状の指定を開始
  beginContour()

  # 穴形状の頂点を指定
  vertex(100, 70)
  vertex(100, 150)
  vertex(150, 180)
  vertex(150, 100)

  # 穴形状の指定ここまで
  endContour()

  # 描画処理ここまで
  endShape(CLOSE)
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/99c99f850f77-20240104.png" width="200"> _Ruby 版 Processing gem の描画結果_

<img src="https://storage.googleapis.com/zenn-user-upload/04f34b69aceb-20240104.png" width="200"> _Java 版 Processing の描画結果_

また [curveVertex()](https://processing.org/reference/curveVertex_.html)、[bezierVertex()](https://processing.org/reference/bezierVertex_.html)、[quadraticVertex()](https://processing.org/reference/quadraticVertex_.html) も実装しています。これらを使うことでそれぞれ、Catmull-Rom スプライン曲線、3次ベジェ曲線、2次ベジェ曲線を描画することができるようになりました。

```ruby
setup do
  createCanvas(256, 256)
end
draw do
  background(100)
  noFill()
  stroke(255)
  strokeWeight(10)

  # Catmull-Rom スプライン曲線を描画
  beginShape()
  curveVertex(10, 50)
  curveVertex(10, 50)
  curveVertex(50, 50)
  curveVertex(50, 200)
  curveVertex(10, 200)
  curveVertex(10, 200)
  endShape()

  # 3次ベジェ曲線を描画
  beginShape()
  vertex(110,  50)
  bezierVertex(150, 50, 150, 200, 110, 200)
  endShape()

  # 2次ベジェ曲線を描画
  beginShape()
  vertex(180, 50)
  quadraticVertex(240, 50, 240, 200)
  endShape()
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/9852c123c315-20240105.png" width="200"> _Ruby 版 Processing gem の描画結果_

<img src="https://storage.googleapis.com/zenn-user-upload/d5270ba340c3-20240105.png" width="200"> _Java 版 Processing の描画結果_

実装は以下の順で進めました。

1. [Changed Polygon#+ behavior](https://github.com/xord/all/pull/21)<br>
Shape クラスが内部で利用する C++ Polygon クラスを修正しています。ここでは `Polygon + Polygon` が 論理和演算の挙動だったのを、それぞれのポリゴン内部のポリラインリストを結合する処理となるように変更しました。

2. [Polyline.new() can take 'hole' parameter](https://github.com/xord/all/pull/22)<br>
Polyline.new() に今まで渡せなかった `hole` 引数を渡せるようにしました。
これと 1. の変更とあわせて、`Polygon(...) + Polyline(..., hole: true)` という書き方ができるようになりました。

3. [Add beginContour() and endContour()](https://github.com/xord/all/pull/23)<br>
beginContour() と endContour() をどこからでも呼べる関数 （GraphicsContext モジュールに定義）と Shape クラスのメソッドとして追加しました。

4. [Add curveVertex(), bezierVertex(), and quadraticVertex()](https://github.com/xord/all/pull/24)<br>
`curveVertex()`、`bezierVertex()`、`quadraticVertex()` を関数として、また Shape クラスにはメソッドとして追加しました。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/23)をクローズしております。

#### 4.2.2 [preload() と requestImage()](https://github.com/xord/processing/issues/18)

このイシューでは [requestImage()](https://processing.org/reference/requestImage_.html) を実装しました。

画像を読み込む関数としては [loadImage()](https://processing.org/reference/loadImage_.html) がありますが、同期処理のため画像読み込み処理中は描画が止まってしまいます。

[requestImage()](https://processing.org/reference/requestImage_.html) を使うことで別スレッドで読み込み処理を実行してくれるので、描画処理を止めずに画像を読み込むことができるようになりました。

```ruby
img = nil
setup do
  createCanvas(256, 256)

  # 別スレッドで画像をダウンロード＆読み込み
  img = requestImage('https://xord.org/rubysketch/images/rubysketch128.png')
end
draw do
  background(100)

  if img.width > 0
    # 画像が読み込み完了していたらそのまま描画する
    image(img, 10, 10, 200, 200)
  elsif img.width < 0
    # 画像の読み込みでエラーが発生した場合はエラーテキストを表示する
    text('Error!', 10, 100)
  else
    # 画像の読み込みが完了していない場合は読み込み中テキストを表示する
    text('Loading...', 10, 100)
  end
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/fdd65fdeda4d-20240104.png" width="200"> _読み込み中_

<img src="https://storage.googleapis.com/zenn-user-upload/793407d86ede-20240104.png" width="200"> _エラーが発生_

<img src="https://storage.googleapis.com/zenn-user-upload/aff9688d3403-20240104.png" width="200"> _画像が読み込めたらそのまま描画_

実装は以下の順で進めました。

1. [Add requestImage()](https://github.com/xord/all/pull/25)<br>
requestImage() を実装しました。

ただし `preload()` については、p5.js (JavaScript) 特有の事情で実装された機能であり、Ruby 版 Processing gem には不要と判断し実装をキャンセルしています。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/18)をクローズしております。

#### 4.2.3 [loadFont() と Font.list()](https://github.com/xord/processing/issues/17)

このイシューでは [Font.list()](https://processing.org/reference/PFont_list_.html) を実装しました。

これを使うことで、利用可能なフォント名の一覧を取得することができるようになりました。

```ruby
fonts = Font.list
setup do
  createCanvas(256, 256)
end
draw do
  background(100)
  fonts.each.with_index do |name, i|
    text(name, 10, 20 + i * 20)
  end
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/373b82a84bfc-20240105.png" width="200"> _利用可能なフォント一覧を表示_

また [loadFont()](https://processing.org/reference/loadFont_.html) も実装しています。

これを利用することで、システムに無いフォントでも TrueType や OpenType のフォントファイルからフォントを読み込んでテキストを描画できるようになりました。

```ruby
font = loadFont('KouzanBrushFontSousyo.ttf')
setup do
  createCanvas(256, 256)
end
draw do
  background(100)
  textFont(font, 32)
  text("はろーるびー", 10, 100)
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/c30276d7c130-20240105.png" width="200"> _衡山毛筆フォント草書でのテキスト描画_

実装は以下の順で進めました。

1. [Add Font.load()](https://github.com/xord/all/pull/26)<br>
C++ レイヤーのフォントクラスにフォントファイル読み込み機能を実装しました。

2. [Add Font#size=](https://github.com/xord/all/pull/27)<br>
次の textFont() と textSize() の再実装で必要になり、内部のフォントクラスのサイズを変更するメソッドを追加しました。

3. [Reimplement textFont() and textSize()](https://github.com/xord/all/pull/29)<br>
textFont() と textSize() の実装が微妙だったので再実装しました。

4. [Add Rays::Font.families() and Processing::Font.list()](https://github.com/xord/all/pull/30)<br>
Font.list() を実装しました。

5. [Add loadFont()](https://github.com/xord/all/pull/33)<br>
loadFont() を実装しました。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/18)をクローズしております。

### 4.3 [ProcessingAPI 実装 中難度グループ](https://github.com/xord/processing/milestone/2)

このマイルストーンでは、本取り組みで開発予定のうち実装難度が中程度の機能をまとめて実装しています。

![](https://storage.googleapis.com/zenn-user-upload/82bc6e08f7de-20240105.png)
![](https://storage.googleapis.com/zenn-user-upload/94a6bb29e6ce-20240105.png)

#### 4.3.1 [Image のピクセル操作関数](https://github.com/xord/processing/issues/11)

このイシューでは Image のピクセル操作関数を実装しました。

これを使うことで、画像データのピクセルを直接読み書きすることができるようになりました。

```ruby
# 画像オブジェクトを作成
img = createImage(100, 100)

setup do
  createCanvas(100, 100)
end

draw do
  background(255)
  # 画像を表示
  image(img, 0, 0)
end

mouseDragged do
  # 画像のピクセル更新開始
  img.loadPixels()

  # 画像のマウス座標のピクセルを赤に更新
  img.pixels[mouseY.to_i * img.width + mouseX.to_i] = color(255, 0, 0)

  # 更新したピクセル情報を画像に反映
  img.updatePixels()
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/4a6213aed2c5-20240314.png" width="200">_ピクセル単位で書き換え_

実装は以下の順で進めました。

1. [Add Rays::Bitmap#pixels=](https://github.com/xord/all/pull/31)<br>
内部クラスの Bitmap に、配列を渡して全ピクセルを更新するメソッドを追加しました。

2. [Add loadPixels(), updatePixels(), and pixels() to GraphicsContext module and Image class](https://github.com/xord/all/pull/32)<br>
1 の機能をベースにして、loadPixels()、updatePixels()、pixels() を実装しました。

3. [Fixed a bug that updatePixels() was sometimes ignored](https://github.com/xord/all/pull/34)<br>
Image クラスは内部で Texture と Bitmap を持っており、OpenGL での描画は Texture に、直のピクセル操作は Bitmap を更新する形になっています。Texture と Bitmap はそれぞれの更新フラグを持っていて Texture を更新した場合は次回 Bitmap 取得時に Texture -> Bitmap の反映を、Bitmap を更新した場合は次回 Texture 取得時に Bitmap -> Texture の反映をするようになっています。<br>
このプルリクではその相互反映が期待通りに動かないケースがあったので修正しています。これによって draw do〜end ブロック内で loadPixels()、updatePixels() を使った時に期待した結果にならなかった不具合を修正しています。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/11)をクローズしております。

#### 4.3.2 [smooth() と fullScreen()](https://github.com/xord/processing/issues/12)

このイシューでは smooth() と fullScreen() 関数を実装しました。

smooth()/noSmooth() はアンチエイリアシングの有効・無効を設定し、fullScreen() はフルスクリーンとウィンドウ表示を切り替えることができるようになっています。

```ruby
setup do
  createCanvas(200, 200, pixelDensity: 1)

  # アンチエイリアシングの有効化と無効化
  smooth() # or noSmooth()
end
draw do
  background(100)
  noStroke
  ellipseMode(CORNER)

  # アンチエイリアシングが有効だと円のエッジが滑らかになる
  ellipse(0, 0, 200, 200)
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/a9c613610868-20240314.png" width="200">_アンチエイリアシング無し_

<img src="https://storage.googleapis.com/zenn-user-upload/3f04554ce030-20240314.png" width="200">_アンチエイリアシング有り_

実装は以下の順で進めました。

1. [Add smooth() and noSmooth()](https://github.com/xord/all/pull/35)<br>
smooth() が有効のときは、画面用のオフスクリーンバッファを2枚に増やして GL_TEXTURE_MIN_FILTER が GL_LINEAR なテクスチャとしてもう一枚のオフスクリーンバッファに縮小して描画するようにし、アンチエイリアシング的な描画結果になるようにしました。

2. [Add Window#fullscreen accessor](https://github.com/xord/all/pull/36)<br>
内部で C++/ObjC で実装している Window クラスにフルスクリーン表示のフラグを追加しました。

3. [Add fullscreen (fullScreen) function](https://github.com/xord/all/pull/37)<br>
2 で実装したウィンドウのフルスクリーンフラグを使って、Processing の fullScreen() 関数（p5.js だと fullscreen() 関数）を実装しました。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/12)をクローズしております。

#### 4.3.3 [curve 関数](https://github.com/xord/processing/issues/14)、[bezier 関数](https://github.com/xord/processing/issues/13)

このイシューでは曲線の補完をする関数を実装しました。

```ruby
draw do
  background(200)

  w, h = width, height

  # 0.0〜1.0 の範囲を 0.02 刻みでループ
  (0.0..1.0).step(0.02) do |t|

    # x と y 座標を bezierPoint() で求める
    x = bezierPoint(50, w - 50, 50,      w - 50, t)
    y = bezierPoint(50, 50,      h - 50, h - 50, t)

    # 求めた座標に円を描画する
    circle(x, y, 10)
  end
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/0aae7e0dc90a-20240314.png" width="200">_ベジェ曲線を点で描画_

実装は以下の順で進めました。

1. ['nsegment' paramer for curves](https://github.com/xord/all/pull/38)<br>
curveDetail()、bezierDetail() 実装のため、C++ 実装レイヤーでも曲線の分割数を指定できるようにしました。

2. [Add curveDetail() and bezierDetail()](https://github.com/xord/all/pull/39)<br>
1 で実装した機能を利用し curveDetail() と bezierDetail() を実装しました。

3. [Add curvePoint(), curveTangent(), curveTightness(), bezierPoint(), and bezierTangent()](https://github.com/xord/all/pull/40)<br>
curvePoint()、curveTangent()、curveTightness()、bezierPoint()、bezierTangent() を実装しました。
ただし curveTightness() は現実装では curve() と curveVertex() に影響与えない作りとなっており、こちらは今後の実装予定としています。

以上の機能追加をもって [curve 関数](https://github.com/xord/processing/issues/14)、[bezier 関数](https://github.com/xord/processing/issues/13)のイシューをクローズしております。

#### 4.3.4 [random と noise](https://github.com/xord/processing/issues/15)

このイシューでは乱数とノイズ関数を実装しました。

```ruby
draw do
  background(200)
  noFill()

  beginShape()
  (0..width).each do |x|
    # noise() 関数で Perlin ノイズを生成する
    y = noise(x / 50.0) * height

    # 生成したノイズを y 座標として線を描画する
    vertex(x, height - y)
  end
  endShape()
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/d717d8d1be3f-20240314.png" width="200">_noise() 関数で Perlin ノイズを描画_

実装は以下の順で進めました。

1. [Add noiseSeed() and noiseDetail()](https://github.com/xord/all/pull/41)<br>
noiseSeed() と noiseDetail() を実装しました。
また、noise() はすでにありましたが Processing/p5.js と挙動が違っていたので修正し互換性を向上させました。

2. [Add randomSeed() and randomGaussian()](https://github.com/xord/all/pull/42)<br>
randomSeed() と randomGaussian() を実装しました。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/15)をクローズしております。

#### 4.3.5 [textLeading](https://github.com/xord/processing/issues/16)

このイシューではテキスト描画時の行間の幅を指定する textLeading() 関数を実装しました。

```ruby
draw do
  background(200)
  fill(0)
  textSize(36)

  # 行間の指定なし
  text("A1\nA2\nA3", 50,  100)

  # 行間の幅を 50 に変更
  textLeading(50)
  text("B1\nB2\nB3", 150, 100)

  # 行間の幅を 100 に変更
  textLeading(100)
  text("C1\nC2\nC3", 250, 100)
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/25bb862140a9-20240314.png" width="200">_行間の幅を指定している_

実装は以下の順で進めました。

1. [Add Painter#line_height accessor](https://github.com/xord/all/pull/43)<br>
C++ レイヤーのテキスト実装部分に line_height 属性を追加しました。

2. [Add textLeading()](https://github.com/xord/all/pull/44)<br>
1 の機能を使って textLeading() を実装しました。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/16)をクローズしております。

### 4.4 [ProcessingAPI 実装 低難度グループ](https://github.com/xord/processing/milestone/1)

このマイルストーンでは、実装難易度が低めの細かい関数を多数実装しています。

![](https://storage.googleapis.com/zenn-user-upload/fae81f8ee72a-20240105.png)

#### 4.4.1 [グループ1](https://github.com/xord/processing/issues/8)

このイシューでは以下の関数を実装しました。

- deltaTime()
- createFont()
- brightness()
- hue()
- saturation()
- applyMatrix()
- printMatrix()

実装は以下の順で進めました。

1. [Add deltaTime](https://github.com/xord/all/pull/47)<br>
deltaTime() を追加しました。

2. [Add Rays::Color.to_hsv()](https://github.com/xord/all/pull/48)<br>
内部で使っている Color クラスに HSV への変換機能を追加しました。

3. [Add hue(), saturation(), and brightness()](https://github.com/xord/all/pull/49)<br>
2 で追加した機能を利用して hue(), saturation(), brightness() を追加しました。

4. [Add Rays::Matrix#transpose](https://github.com/xord/all/pull/50)<br>
内部で使っている行列クラスに、行と列を入れ替える transpose() メソッドを追加しました。

5. [Add applyMatrix()](https://github.com/xord/all/pull/51)<br>
applyMatrix() を追加しました。
Java 版 Processing と p5.js では一部行列の仕様で違いがあったため、4 で追加した機能を使って挙動を切り替えられるようにしています。

6. [Add printMatrix()](https://github.com/xord/all/pull/52)<br>
printMatrix() を追加しました。

なお、createFont() は[フォント周りの実装](https://github.com/xord/processing/issues/17)の時に [Add createFont()](https://github.com/xord/all/pull/28) でうっかりついでに実装してしまいました。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/8)をクローズしております。

#### 4.4.2 [グループ2](https://github.com/xord/processing/issues/9)

このイシューでは以下の関数を実装しました。

- keyIsDown()
- keyIsPressed
- mouseWheel()
- doubleClicked()

実装は以下の順で進めました。

1. [Add keyIsPressed()](https://github.com/xord/all/pull/53)<br>
keyIsPressed() を追加しました。

2. [Add keyIsDown()](https://github.com/xord/all/pull/54)<br>
keyIsDown() を追加しました。

3. [Add mouseWheel()](https://github.com/xord/all/pull/55)<br>
mouseWheel() を追加しました。

4. [Add doubleClicked()](https://github.com/xord/all/pull/56)<br>
doubleClicked() を追加しました。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/9)をクローズしております。

#### 4.4.3 [グループ3](https://github.com/xord/processing/issues/10)

このイシューでは以下の関数を実装しました。

- rotateX()
- rotateY()
- rotateZ()
- Shape#rotateX()
- Shape#rotateY()
- Shape#rotateZ()
- shearX()
- shearY()

実装は以下の順で進めました。

1. [Use perspective() for projection matrix](https://github.com/xord/all/pull/58)<br>
View Projection 行列は今まで ortho() で指定していましたが、rotateX(), rotateY() 等でパースがつくよう perspective() で指定するように変更しました。
ortho() で指定していたときと多少描画結果が変わってしまう（描画位置がズレるなど）あるかと思って ortho() 指定と切り替えられるようにしようかと思ってましたが、perspective() 指定でも 2D 描画が全く同じになるように実装できたので一旦 perspective() 指定のみですべて賄うようにしました。

2. [Add rotateX(), rotateY(), and rotateZ()](https://github.com/xord/all/pull/59)<br>
1 の修正で、Z=0 以外の座標を指定するとパースがつくようになったので、それをベースに rotateX()、rotateY()、rotateZ() を追加しました。

3. [Add shearX() and shearY()](https://github.com/xord/all/pull/60)<br>
shearX() と shearY() を追加しました。

4. [Add rotateX(), rotateY(), and rotateZ() to Shape class](https://github.com/xord/all/pull/61)<br>
rotateX()、rotateY()、rotateZ() を Shape クラスに追加しました。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/10)をクローズしております。

なお、以下の関数も実装予定ではありましたが、具体的な実装方法を検討した結果、ライブラリ全体の描画のパフォーマンスを微妙に犠牲にする必要が可能性が高そうでしたので、今回は実装しないことにしました。

- modelX()
- modelY()
- modelZ()
- screenX()
- screenY()
- screenZ()

描画性能に微妙に影響しそうな点は以下のとおりです。
- 現在は Model View Projection を一つの行列でまとめて管理してしまってる
- modelX()、modelY()、modelZ で Model 座標だけを返すためには Model と View Projection の行列を分けて管理する必要がある
- Model 行列と View Projection 行列を分けると描画時の行列演算が増えてしまう

### 4.5 [ProcessingAPI 実装 低優先度グループ](https://github.com/xord/processing/milestone/5)

このマイルストーンは、本取り組みの終盤に時間的に余裕があれば実装しようという、優先度の低い機能をまとめています。

![](https://storage.googleapis.com/zenn-user-upload/6716dd8eaeb7-20240105.png)

#### 4.5.1 [acceleration と rotation()](https://github.com/xord/processing/issues/24)

このイシューでは以下の関数を実装する予定でしたが、再検討した結果実装しないこととしました。

- deviceOrientation()
- accelerationX, Y, Z()
- pAccelerationX, Y, Z()
- rotationX, Y, Z()
- pRotationX, Y, Z()
- turnAxis()
- deviceTurned()
- deviceMoved()
- deviceShaked()

実装するのを止めた理由は以下のとおりです。

- Java 版 Processing にはそもそもこれらの関数が無い
- p5.js は、Mac と iPhone 両環境で accelerationXYZ、rotateionXYZ 共に 0 しか返されずうまく動かせなかった（パーミッション関係の可能性が高そう）

以上、機能追加はしいませんでしたが、後日実装の予定も今のところ無いので[イシュー](https://github.com/xord/processing/issues/24)はクローズしております。

#### 4.5.2 [loadShape()](https://github.com/xord/processing/issues/25)

このイシューでは loadShape() 関数を実装しました。

```ruby
# .svg ファイルを Shape として読み込む
s = loadShape("Ghostscript_Tiger.svg")

draw do
  background(255)
  translate(200, 200)

  # 読み込んだ .svg を描画
  shape(s)
end
```

<img src="https://storage.googleapis.com/zenn-user-upload/92704d660937-20240314.png" width="500">_左が実行結果。右が正しいレンダリング結果_

実装は以下の順で進めました。

1. [Add loadShape()](https://github.com/xord/all/pull/63)<br>
loadShape() を実装しました。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/25)をクローズしております。

ここまでで、本取り組みで実装予定とした全てのイシューとマイルストーンをクローズできました。

## 5. その他の成果

ここでは、機能追加以外の成果をまとめます。

### 5.1 [p5.rb](https://github.com/ongaeshi/p5rb/) を利用した互換性検証について

本取り組みの初期において、開発効率改善のため Processing/p5.js との互換性をユニットテストで検証する仕組みを導入しました。

ユニットテストの中でヘッドレスブラウザを開き、[ruby.wasm](https://github.com/ruby/ruby.wasm) をベースにした [p5.rb](https://github.com/ongaeshi/p5rb/) を使い [p5.js](https://p5js.org/) を動かし、その描画結果と Processing gem の描画結果をピクセル単位で比較するというものです。

詳細については[自前 Processing 実装の互換性検証に p5.rb を使ってみた話](https://zenn.dev/tokujiros/articles/973815bce7afdc)を参照ください。

### 5.2 RubySketch iOS アプリのバージョンアップ

本件とは別に、[RubySketch](https://apps.apple.com/jp/app/rubysketch/id1491477639) という iOS アプリを Apple の AppStore で公開しています。このアプリには Processing gem も組み込んでおり、iOS アプリ単体でクリエイティブコーディングを楽しむことができるようになっています。

今回そのアプリの新バージョン v2.10 を公開しております。本取り組みで追加した新機能を反映し、アプリ利用者に最新の機能を提供することができました。

こちらはそのアプリの v2.10 更新情報になります。

```
RubySketch v2.10 更新情報

- Rubyアソシエーション開発助成金の支援を受け、以下の関数とクラスを追加しました
  - createShape()
  - shape()
  - shapeMode()
  - beginShape()
  - endShape()
  - beginContour()
  - endContour()
  - vertex()
  - curveVertex()
  - bezierVertex()
  - quadraticVertex()
  - texture()
  - textureMode()
  - textureWrap()
  - loadPixels()
  - updatePixels()
  - pixels()
  - textLeading()
  - createFont()
  - loadFont()
  - requestImage()
  - curveDetail()
  - curvePoint()
  - curveTangent()
  - curveTightness()
  - bezierDetail()
  - bezierPoint()
  - bezierTangent()
  - rotateX()
  - rotateY()
  - rotateZ()
  - shearX()
  - shearY()
  - applyMatrix()
  - printMatrix()
  - deltaTime
  - hue()
  - saturation()
  - brightness()
  - noiseSeed()
  - noiseDetail()
  - randomSeed()
  - randomGaussian()
  - fullscreen() (fullScreen())
  - smooth()
  - noSmooth()
  - keyIsDown()
  - keyIsPressed()
  - mouseWheel()
  - doubleClicked()
  - Font.list()
  - Graphics#clear()
  - Graphics#save()
  - Shape クラス
- 互換性向上のため noise() を再実装しました
- scale() に第3引数として z を渡せるようになりました
- loadImage() がエラー時に OpenURI::HTTPError ではなく Net::HTTPClientException を raise するようになりました
- pushStyle()/popStyle() が colorMode、angleMode、blendMode を正しく管理できていなかったので修正しました
```

### 5.3 Ruby によるグラフィックスプログラミングを広める活動について

Ruby によるグラフィックスプログラミングを広めるために、以下の記事を本取り組み期間中に公開いたしました。

- [Processing ベースの2Dゲームエンジン for CRuby の紹介](https://zenn.dev/tokujiros/articles/7f0b44a6b7e2a6)<br>
本取り組みで開発する Processing gem をベースにしたゲームエンジンを別途開発しており、その紹介記事になります。Processing API を使ってゲーム開発をしてみようという内容となっています。

## 6. 今後の課題

本取り組みにより、CRuby 用 Processing gem は本家 Processing との高い互換性を得ることができました。これにより、より実用性の高いライブラリとなることができたと思います。

しかしその代わりに見えてきた課題もありました。

### 6.1 Windows 対応

Processing gem は現時点では Mac と iOS で利用可能となっていますが、プラットフォームのシェアを考えるとやはり Windows 対応は必要になってくると思います。

今後より多くの利用者を獲得するためにも、なるべく早いタイミングで Windows 対応をする必要があると感じています。

### 6.2 描画性能の改善

Processing gem は描画性能がとても大事なライブラリでありつつも、実は、これまでパフォーマンスを最重要とはしてきていませんでした。本ライブラリが最優先とするのはライブラリ利用者がなるべく自然に違和感なく記述することができる API 設計を最重要としてきたためです。最適化を優先した結果、使いにくい API になることはできるだけ避けて来ました。

とは言え、今回グルーピング可能な Shape を実装したためさすがに描画処理の負荷が気になってきています。loadShape() の例で示したトラの SVG を1枚描画するだけでも環境によっては 60FPS 維持できないケースもありますので、複雑な SVG を描画するケースでもドローコールは1回で済むような性能改善は早いうちに実装しておきたいところです。

## 7. まとめ

当初計画していた開発内容はほぼ予定通り実装することができました。これによって、目的としていたとおり本家 Processing との高い互換性をもつライブラリとすることができました。

## 8. さいごに

ここまでの開発によって、Processing gem は Processing/p5.js との互換性において最低限必要な水準の機能がすべて実装された状態となったため、バージョン番号を v1.0 としめでたく[正式版としてリリース](https://rubygems.org/gems/processing/versions/1.0.1)することができました。

この成果を達成するためにサポートしてくださった Ruby アソシエーション様と、メンターとして支えてくださった須藤功平様に深く感謝いたします。