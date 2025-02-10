import 'dart:convert';
import 'package:naate/constant.dart';
import 'package:naate/model/lyrics_model.dart';
import 'package:http/http.dart' as http;

class LyricsService {
  Future<List<LyricsModel>> fetchLyrics() async {
    final response = await http.get(Uri.parse("$baseUrl/get_all_natte"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => LyricsModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load data ");
    }
  }

  Future<List<LyricsModel>> fetchLyricsByLyricist(int id) async {
    final response =
        await http.get(Uri.parse("$baseUrl/get_by_lyricist_id/$id"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => LyricsModel.fromJsonByLyricist(json)).toList();
    } else {
      throw Exception("Failed to load data ");
    }
  }

  Future<List<LyricsModel>> fetchBySearch(String value) async {
    final response =
        await http.get(Uri.parse("$baseUrl/fetchLyricsBySearch/$value"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => LyricsModel.fromJsonByLyricist(json)).toList();
    } else {
      throw Exception("Failed to load data ");
    }
  }

  Future<LyricsModel> getByIdLyrics(dynamic id) async {
    final response = await http.get(Uri.parse("$baseUrl/get_one_natte/$id"),
        headers: {"User-Agent": "mobileApp"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List && data.isNotEmpty) {
        return LyricsModel.fromJson(data[0]);
      } else if (data is Map<String, dynamic>) {
        return LyricsModel.fromJson(data);
      } else {
        throw Exception("Unexpected response format");
      }
    } else {
      throw Exception("Failed to load data ");
    }
  }
}
