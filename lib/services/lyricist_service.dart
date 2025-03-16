import 'dart:convert';

import 'package:naate/constant.dart';
import 'package:naate/model/lyricist_model.dart';
import 'package:http/http.dart' as http;

class LyricistService {
  static Future<List<LyricistModel>> fetchLyricist() async {
    final response = await http.get(Uri.parse("$baseUrl/lyricist"));
    print("Shayer Result  ${response.body}");
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => LyricistModel.fromJson(json)).toList();
    } else {
      print("Load Exception failed");
      throw Exception("Failled to load data");
    }
  }

  static Future<List<LyricistModel>> fetchBySearch(String value) async {
    final response =
        await http.get(Uri.parse("$baseUrl/fetchLyricistBySearch/$value"));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => LyricistModel.fromJson(json)).toList();
    } else {
      throw Exception("Failled to load data");
    }
  }
}
