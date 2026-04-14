class BibleVerse {
  final String bookId;
  final String bookName;
  final int chapter;
  final int verse;
  final String text;

  BibleVerse({
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  factory BibleVerse.fromJson(Map<String, dynamic> json) {
    return BibleVerse(
      bookId: json['book_id'] as String? ?? '',
      bookName: json['book_name'] as String? ?? '',
      chapter: json['chapter'] as int? ?? 0,
      verse: json['verse'] as int? ?? 0,
      text: json['text'] as String? ?? '',
    );
  }
}

class BiblePassageResponse {
  final String reference;
  final List<BibleVerse> verses;
  final String text;
  final String translationId;
  final String translationName;
  final String translationNote;

  BiblePassageResponse({
    required this.reference,
    required this.verses,
    required this.text,
    required this.translationId,
    required this.translationName,
    required this.translationNote,
  });

  factory BiblePassageResponse.fromJson(Map<String, dynamic> json) {
    var versesJson = json['verses'] as List? ?? [];
    List<BibleVerse> versesList = versesJson.map((v) => BibleVerse.fromJson(v as Map<String, dynamic>)).toList();

    return BiblePassageResponse(
      reference: json['reference'] as String? ?? '',
      verses: versesList,
      text: json['text'] as String? ?? '',
      translationId: json['translation_id'] as String? ?? '',
      translationName: json['translation_name'] as String? ?? '',
      translationNote: json['translation_note'] as String? ?? '',
    );
  }
}
