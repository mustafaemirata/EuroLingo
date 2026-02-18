class WordItem {
  final String term;
  final List<String> meanings;

  const WordItem(this.term, this.meanings);

  String get firstLetter => term.isNotEmpty ? term[0].toUpperCase() : '';

  String get primaryMeaning => meanings.isNotEmpty ? meanings[0] : '';

  String get allMeanings => meanings.join(', ');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordItem &&
          runtimeType == other.runtimeType &&
          term == other.term;

  @override
  int get hashCode => term.hashCode;
}

class OxfordEntry {
  final String pronunciation;
  final List<String> examples;
  final List<String> translations;

  const OxfordEntry({
    this.pronunciation = '',
    this.examples = const [],
    this.translations = const [],
  });
}
