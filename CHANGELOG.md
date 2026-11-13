## 1.0.1

- `CmarkParserOptions.keepUndefinedFootnoteReferences`: keep `[^label]` as a
  footnote reference when no definition has that label, so a streamed
  reference does not show as text until its definition arrives. Off by
  default, which keeps GFM's behavior.

## 1.0.0

- First stable release. Requires perf_tester 1.0.0 for its tests.
- A usage example. The code passes the recommended lints.

## 0.1.1

- No changes to the package. The perf tests use package:perf_tester, and
  releases are published from CI.

## 0.1.0

- First release on pub.dev, as cmark_gfm_dart: a pure Dart port of the
  cmark-gfm Markdown parser with streaming support.
