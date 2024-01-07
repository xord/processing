# 1. はじめに

この資料は、「2023 年度 Ruby アソシエーション開発助成金」制度で採択された「CRuby 用 Processing Gem の、本家 Processing との互換性向上に向けた取り組み」についての中間報告書になります。

# 2. プロジェクト概要

クリエイティブコーディングの世界では [Processing](https://processing.org/) や [p5.js](https://p5js.org/) のようなフレームワークが広く利用されています。これらを利用することで、フレームワーク利用者はグラフィックスと視覚的な表現を駆使したアートやインタラクティブなアプリケーションを簡単に作成することができます。

このプロジェクトではその Processing/p5.js の API と互換性のある CRuby 向けの Processing Gem をゼロから開発しており、現時点で Processing の主要な機能の約7割から8割を実装済みとしています。

本取り組みではその残りの未実装となっている機能を実装することで、Ruby プログラマーが、広く知られた Processing API を使用して手軽にグラフィックスプログラミングを行えるよう支援するものです。

# 3. 活動内容

Processing との互換性を向上させるために、本取り組みで実装する予定の具体的な開発項目を18に分け GitHub のイシューとしました。これらをさらにグルーピングし、GitHub の[マイルストーン](https://github.com/xord/processing/milestones)にまとめたのが以下になります。

- Milestone: [ProcessingAPI 実装 高難度グループ Shape 関連](https://github.com/xord/processing/milestone/3?closed=1) （✅ クローズ済）
  - Issue: [shape() と基本的な関数群](https://github.com/xord/processing/issues/19) （✅ クローズ済）
  - Issue: [PShape クラス](https://github.com/xord/processing/issues/20) （✅ クローズ済）
  - Issue: [texture() 関連と vertex(x, y, u, v)](https://github.com/xord/processing/issues/21) （✅ クローズ済）
  - Issue: [Shape に fill と stroke を含める](https://github.com/xord/processing/issues/22) （✅ クローズ済）

- Milestone: [ProcessingAPI 実装 高難度グループ その他](https://github.com/xord/processing/milestone/4?closed=1) （✅ クローズ済）
  - Issue: [begin/endContour() と bezier/curve/quadraticVertex()](https://github.com/xord/processing/issues/23) （✅ クローズ済）
  - Issue: [preload() と requestImage()](https://github.com/xord/processing/issues/18) （✅ クローズ済）
  - Issue: [loadFont() と Font.list()](https://github.com/xord/processing/issues/17) （✅ クローズ済）

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

# 4. 開発状況

ここからは開発項目個別の詳細と、その開発進捗状況を記載します。

## 4.1 [ProcessingAPI 実装 高難度グループ Shape 関連](https://github.com/xord/processing/milestone/3?closed=1)

このマイルストーンでは、Shape 描画関連の機能を実装します。

![](https://storage.googleapis.com/zenn-user-upload/95266ac5d6a5-20240104.png)

### 4.1.1 [shape() と基本的な関数群](https://github.com/xord/processing/issues/19)

このイシューでは [beginShape()](https://processing.org/reference/beginShape_.html)、[endShape()](https://processing.org/reference/endShape_.html)、[vertex()](https://processing.org/reference/vertex_.html) を実装しています。
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

### 4.1.2 [PShape クラス](https://github.com/xord/processing/issues/20)

このイシューでは [PShape](https://processing.org/reference/PShape.html) クラスを実装しています。
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

### 4.1.3 [texture() 関連と vertex(x, y, u, v)](https://github.com/xord/processing/issues/21)

このイシューでは [vertex()](https://processing.org/reference/vertex_.html) と [texture()](https://processing.org/reference/texture_.html) を実装しています。
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

### 4.1.4 [Shape に fill と stroke を含める](https://github.com/xord/processing/issues/22)

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

3. [Add setFill() to Shape class](https://github.com/xord/all/pull/18)<br>
Shape#setFill を追加し、あとから Shape の色を変更できるようにしました。

`fill()` と同様 `stroke()` の頂点色指定にも対応する予定でしたが、C++ レイヤーの内部構造的に現時点で実装が難しいことが判明したため一旦ここでは実装しないこととしました。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/22)をクローズしております。

## 4.2 [ProcessingAPI 実装 高難度グループ その他](https://github.com/xord/processing/milestone/4?closed=1)

このマイルストーンでは、本取り組みで開発予定のうち、難易度高めグループの残りの機能を実装します。

![](https://storage.googleapis.com/zenn-user-upload/8e9c9a96e7c1-20240104.png)

### 4.2.1 [begin/endContour() と bezier/curve/quadraticVertex()](https://github.com/xord/processing/issues/23)

このイシューでは [beginContour()](https://processing.org/reference/beginContour_.html) と [endContour()](https://processing.org/reference/PShape_endContour_.html) を実装しています。
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

また [curveVertex()](https://processing.org/reference/curveVertex_.html)、[bezierVertex()](https://processing.org/reference/bezierVertex_.html)、[quadraticVertex()](https://processing.org/reference/quadraticVertex_.html) も実装しています。
これらを使うことでそれぞれ、Catmull-Rom スプライン曲線、3次ベジェ曲線、2次ベジェ曲線を描画することができるようになりました。

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

### 4.2.2 [preload() と requestImage()](https://github.com/xord/processing/issues/18)

このイシューでは [requestImage()](https://processing.org/reference/requestImage_.html) を実装しています。
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

1. [Add requestImage()](https://github.com/xord/all/pull/25)
requestImage() を実装しました。

ただし `preload()` については、p5.js (JavaScript) 特有の事情で実装された機能であり、Ruby 版 Processing gem には不要と判断し実装をキャンセルしました。

以上の機能追加をもって[イシュー](https://github.com/xord/processing/issues/18)をクローズしております。

### 4.2.3 [loadFont() と Font.list()](https://github.com/xord/processing/issues/17)

このイシューでは [Font.list()](https://processing.org/reference/PFont_list_.html) を実装しています。
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

## 4.3 [ProcessingAPI 実装 中難度グループ](https://github.com/xord/processing/milestone/2)

![](https://storage.googleapis.com/zenn-user-upload/82bc6e08f7de-20240105.png)
![](https://storage.googleapis.com/zenn-user-upload/94a6bb29e6ce-20240105.png)

現在はこちらのマイルストーンに取り掛かっており、[Image のピクセル操作関数](https://github.com/xord/processing/issues/11) の実装中となります。

## 4.4 [ProcessingAPI 実装 低難度グループ](https://github.com/xord/processing/milestone/1)

こちらのマイルストーンは現在未着手となっております。

![](https://storage.googleapis.com/zenn-user-upload/fae81f8ee72a-20240105.png)

## 4.5 [ProcessingAPI 実装 低優先度グループ](https://github.com/xord/processing/milestone/5)

こちらのマイルストーンは現在未着手となっております。

![](https://storage.googleapis.com/zenn-user-upload/6716dd8eaeb7-20240105.png)

# 5. [p5.rb](https://github.com/ongaeshi/p5rb/) を利用した互換性検証について

本取り組みの初期において、開発効率改善のため Processing/p5.js との互換性をユニットテストで検証する仕組みを導入しました。

ユニットテストの中でヘッドレスブラウザを開き、[ruby.wasm](https://github.com/ruby/ruby.wasm) をベースにした [p5.rb](https://github.com/ongaeshi/p5rb/) を使い [p5.js](https://p5js.org/) を動かし、その描画結果と Processing gem の描画結果をピクセル単位で比較するというものです。

詳細については[自前 Processing 実装の互換性検証に p5.rb を使ってみた話](https://zenn.dev/tokujiros/articles/973815bce7afdc)を参照ください。

# 6. Ruby によるグラフィックスプログラミングを広める活動について

Ruby によるグラフィックスプログラミングを広めるために、以下の記事を本取り組み期間中に公開いたしました。

- [Processing ベースの2Dゲームエンジン for CRuby の紹介](https://zenn.dev/tokujiros/articles/7f0b44a6b7e2a6)<br>
本取り組みで開発する Processing gem をベースにしたゲームエンジンを別途開発しており、その紹介記事になります。Processing API を使ってゲーム開発をしてみようという内容となっています。

# 7. 開発スケジュールについて

この取り組みの前半を終えた現在、開発スケジュールとしては少し遅れ気味ではありますが、実装が難しい機能をおおむね実装完了としておりますので、ここから後半の開発スケジュールは問題なく進められる見込みです。