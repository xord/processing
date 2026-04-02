# Processing

Processing/p5.js-compatible creative coding framework for Ruby.

## Dual API

- Default: Processing-compatible camelCase (`colorMode`, `ellipseMode`)
- Optional: `Processing(snake_case: true)` enables snake_case aliases

## Naming Convention

- Internal methods use `__` suffix (e.g., `init__`, `beginDraw__`, `@context__`)
- Methods matching `/__[!?]?$/` are excluded from the public API

## Visual Regression Testing

Set `TEST_WITH_BROWSER=1` to enable browser-based drawing tests via Ferrum.
`assert_p5_draw` performs screenshot comparison.

## GraphicsContext

Drawing logic is concentrated in the `GraphicsContext` module, mixed into both `Context` (top-level) and `Graphics` (offscreen buffer).
