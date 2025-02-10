class LyricsModel {
  final int? id;
  final String? name;
  final String? title;
  final String? lyrics;
  LyricsModel(
      {required this.id,
      required this.name,
      required this.title,
      required this.lyrics});

  factory LyricsModel.fromJson(Map<String, dynamic> json) {
    return LyricsModel(
        id: json['id'] as int,
        name: json['name'] as String,
        title: json['title'] as String,
        lyrics: json['lyrics'] as String);
  }

  factory LyricsModel.fromJsonByLyricist(Map<String, dynamic> json) {
    return LyricsModel(
        id: json['id'] as int,
        name: null,
        title: json['title'] as String,
        lyrics: json['lyrics'] as String);
  }
}
