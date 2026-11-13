/// Options controlling math parsing behaviour.
class CmarkMathOptions {
  const CmarkMathOptions({
    this.allowBlockDoubleDollar = true,
    this.allowBracketDelimiters = false,
    this.allowSingleDollar = true,
  });

  final bool allowBlockDoubleDollar;
  final bool allowBracketDelimiters;
  final bool allowSingleDollar;
}

/// Options controlling parser behaviour.
class CmarkParserOptions {
  const CmarkParserOptions({
    this.enableMath = true,
    this.mathOptions = const CmarkMathOptions(),
    this.maxReferenceSize,
    this.enableAutolinkExtension = true,
    this.singleTildeStrikethrough = true,
    this.allowExtraTableDelimiters = true,
    this.keepUndefinedFootnoteReferences = false,
  });

  final bool enableMath;
  final CmarkMathOptions mathOptions;
  final int? maxReferenceSize;

  /// Link bare URLs, www domains, and email addresses as in GFM. Enabled by
  /// default; set false to keep bare addresses as plain text.
  final bool enableAutolinkExtension;

  /// Ignore surplus delimiter cells after the last header cell. Generated
  /// Markdown often has extra `---` cells; body rows already allow differing
  /// cell counts. Set false to require the equal counts mandated by GFM.
  final bool allowExtraTableDelimiters;

  /// Whether single tilde `~like this~` creates strikethrough.
  ///
  /// When true (default), both `~single~` and `~~double~~` work.
  /// When false, only `~~double~~` creates strikethrough, and single
  /// tilde is treated as literal text (useful when `~` means "approximately").
  final bool singleTildeStrikethrough;

  /// Keep `[^label]` as a footnote reference when no definition has that
  /// label. GFM turns it back into text. A streaming renderer can enable this
  /// while definitions are still to come, so a reference does not appear as
  /// text and then change into a footnote.
  ///
  /// An undefined reference has [CmarkNode.footnoteReferenceIndex] 0, its
  /// label in [CmarkNode.footnoteDefLabel], and the occurrence of that label
  /// in [CmarkNode.footnoteRefIndex]. The HTML renderer writes it as text.
  final bool keepUndefinedFootnoteReferences;
}
