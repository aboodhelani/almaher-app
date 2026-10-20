/// A named group of saved pages (e.g. «ختمة التهجد»). Pages saved with no
/// group belong to the default group, which is not stored.
class BookmarkGroupModel {
  final String id;
  final String name;

  const BookmarkGroupModel({required this.id, required this.name});

  factory BookmarkGroupModel.fromJson(Map<String, dynamic> json) =>
      BookmarkGroupModel(id: json['id'] as String, name: json['name'] as String);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
