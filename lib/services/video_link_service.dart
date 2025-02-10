import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:naate/constant.dart';
import 'package:naate/model/video_link_model.dart';

class VideoLinkService {
  static Future<List<VideoLinkModel>> fetchVidoLink(int id) async {
    final response =
        await http.get(Uri.parse("$baseUrl/fetch_nasheed_link/$id"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      print(data);
      return data.map((json) => VideoLinkModel.fromJson(json)).toList();
    } else {
      print("Video Link not show");
      throw Exception("Api Failed");
    }
  }
}
