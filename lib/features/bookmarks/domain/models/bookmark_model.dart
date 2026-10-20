/// A saved mushaf page, with what the saved-pages list shows about it.
class BookmarkModel {
  final int page;
  final String surahName;
  final int juz;
  final DateTime savedAt;

  /// The group it is saved in; null for the default group.
  final String? groupId;

  const BookmarkModel({
    required this.page,
    required this.surahName,
    required this.juz,
    required this.savedAt,
    this.groupId,
  });

  BookmarkModel inGroup(String? groupId) => BookmarkModel(
    page: page,
    surahName: surahName,
    juz: juz,
    savedAt: savedAt,
    groupId: groupId,
  );

  factory BookmarkModel.fromJson(Map<String, dynamic> json) => BookmarkModel(
    page: (json['page'] as num).toInt(),
    surahName: json['surah'] as String? ?? '',
    juz: (json['juz'] as num?)?.toInt() ?? 0,
    savedAt:
        DateTime.tryParse(json['savedAt'] as String? ?? '') ?? DateTime.now(),
    groupId: json['group'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'page': page,
    'surah': surahName,
    'juz': juz,
    'savedAt': savedAt.toIso8601String(),
    'group': ?groupId,
  };
}
