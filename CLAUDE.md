# Processing

Processing/p5.js 互換の Ruby クリエイティブコーディングフレームワーク。

## Dual API

- デフォルト: Processing 互換の camelCase (`colorMode`, `ellipseMode`)
- オプション: `Processing(snake_case: true)` で snake_case エイリアスも利用可能

## 命名規約

- 内部メソッドは `__` サフィックス（例: `init__`, `beginDraw__`, `@context__`）
- `/__[!?]?$/` にマッチするメソッドは API から除外される

## ビジュアル回帰テスト

`TEST_WITH_BROWSER=1` で Ferrum によるブラウザベースの描画テストが有効になる。
`assert_p5_draw` でスクリーンショット比較を行う。

## GraphicsContext

描画ロジックは `GraphicsContext` モジュールに集約され、`Context`（トップレベル）と `Graphics`（オフスクリーンバッファ）の両方にミックスインされる。
