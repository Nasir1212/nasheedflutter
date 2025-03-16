class LyricistModel {
  final int id;
  final String name;
  final String nateRasulsCount;
  final String profile;
  final String cover;
  final String about;
  final String email;
  final String phone;
  final String joinedSince;
  final String whatsapp;
  final String facebook;
  final String twitter;
  final String instagram;

  LyricistModel({
    required this.id,
    required this.name,
    required this.nateRasulsCount,
    required this.profile,
    required this.cover,
    required this.about,
    required this.email,
    required this.phone,
    required this.joinedSince,
    required this.whatsapp,
    required this.facebook,
    required this.twitter,
    required this.instagram,
  });

  factory LyricistModel.fromJson(Map<String, dynamic> json) {
    return LyricistModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nateRasulsCount: json['nate_rasuls_count']?.toString() ?? '0',
      profile: json['profile'] ?? '1cb4ada44775221798e204d1b09f1608.png',
      cover: json['cover'] ?? '1cb4ada44775221798e204d1b09f1608.png',
      about: json['about'] ?? '',
      email: json['email'] ?? 'No information available',
      phone: json['phone'] ?? 'No information available',
      joinedSince: json['created_at'] ?? 'No information available',
      whatsapp: json['whatsapp'] ?? 'No information available',
      facebook: json['facebook'] ?? 'https://www.facebook.com/',
      twitter: json['twitter'] ?? 'https://x.com/i/flow/login',
      instagram: json['instagram'] ?? 'https://www.instagram.com/',
    );
  }

  get profileImage => null;
}
