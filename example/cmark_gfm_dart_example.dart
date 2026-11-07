import 'package:cmark_gfm_dart/cmark_gfm_dart.dart';

/// Parses Markdown that arrives in chunks, as from a streaming source, and
/// renders it to HTML.
void main() {
  final parser = CmarkParser()
    ..feed('# Hello **World**\n\n')
    ..feed('| a | b |\n|---|---|\n')
    ..feed('| 1 | 2 |\n');
  print(HtmlRenderer().render(parser.finish()));
}
