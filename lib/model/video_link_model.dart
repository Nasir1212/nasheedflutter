class VideoLinkModel {
  final int? id;
  final String? link;

  VideoLinkModel({
    this.id,
    this.link,
  });

  factory VideoLinkModel.fromJson(Map<String, dynamic> json) {
    return VideoLinkModel(
      id: json['id'] as int,
      link: json['link'] as String,
    );
  }
}
