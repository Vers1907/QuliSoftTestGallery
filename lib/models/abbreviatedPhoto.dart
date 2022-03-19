
class AbbreviatedPhoto {
  final String authorName;
  final String full;
  final String small;
  final String title;

  const AbbreviatedPhoto({
    required this.authorName,
    required this.full,
    required this.small,
    required this.title,
  });

  factory AbbreviatedPhoto.fromJson(Map<String, dynamic> json) {
    return AbbreviatedPhoto(
      authorName: json['user']['name'],
      full: json['urls']['full'],
      small: json['urls']['small'],
      title: json['description'] ?? "",
    );
  }
}