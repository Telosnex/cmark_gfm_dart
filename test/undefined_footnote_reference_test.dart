import 'package:cmark_gfm_dart/cmark_gfm_dart.dart';
import 'package:test/test.dart';

const _keep = CmarkParserOptions(keepUndefinedFootnoteReferences: true);

List<CmarkNode> _references(CmarkNode root) {
  final found = <CmarkNode>[];
  void walk(CmarkNode node) {
    if (node.type == CmarkNodeType.footnoteReference) found.add(node);
    for (var c = node.firstChild; c != null; c = c.next) {
      walk(c);
    }
  }

  walk(root);
  return found;
}

void main() {
  group('keepUndefinedFootnoteReferences', () {
    test('is off by default: an undefined reference is text, as in GFM', () {
      final doc = (CmarkParser()..feed('Claim[^1].\n')).finish();
      expect(_references(doc), isEmpty);
      expect(HtmlRenderer().render(doc), '<p>Claim[^1].</p>\n');
    });

    test('keeps an undefined reference as a reference without a number', () {
      final doc = (CmarkParser(options: _keep)
            ..feed('A[^x], b[^1], c[^x].\n\n[^1]: one\n'))
          .finish();
      final refs = _references(doc);
      expect(refs.map((r) => r.footnoteDefLabel), ['x', '1', 'x']);
      expect(refs.map((r) => r.footnoteReferenceIndex), [0, 1, 0]);
      // Occurrences count per label, as for defined footnotes.
      expect(refs.map((r) => r.footnoteRefIndex), [1, 1, 2]);
      // Only the defined footnote is listed.
      expect(doc.lastChild!.type, CmarkNodeType.footnoteDefinition);
      expect(doc.lastChild!.previous!.type, CmarkNodeType.paragraph);
    });

    test('renders an undefined reference as its source text in HTML', () {
      final doc =
          (CmarkParser(options: _keep)..feed('Claim[^a<b].\n')).finish();
      expect(HtmlRenderer().render(doc), '<p>Claim[^a&lt;b].</p>\n');
    });

    test('a definition in a code block does not define the reference', () {
      final doc = (CmarkParser(options: _keep)
            ..feed('Claim[^1].\n\n```\n[^1]: https://example.com\n```\n'))
          .finish();
      final refs = _references(doc);
      expect(refs, hasLength(1));
      expect(refs.single.footnoteReferenceIndex, 0);
    });

    test('streaming: a reference stays one until its definition arrives', () {
      const text =
          'Claim[^1].\n\n```dart\nx\n```\n\n[^1]: https://example.com\n';
      final parser = CmarkParser(options: _keep);
      var fed = 0;
      for (var end = 'Claim[^1]'.length; end <= text.length; end++) {
        parser.feed(text.substring(fed, end));
        fed = end;
        final refs = _references(parser.finishClone());
        expect(refs, hasLength(1), reason: text.substring(0, end));
        expect(refs.single.footnoteDefLabel, '1');
      }
      expect(_references(parser.finish()).single.footnoteReferenceIndex, 1);
    });
  });
}
