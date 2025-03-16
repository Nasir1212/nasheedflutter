import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:naate/constant.dart';
import 'package:naate/db/database_helper.dart';

class ActionProvider with ChangeNotifier {
  DatabaseHelper dbHelper = DatabaseHelper();

  late bool _isShowVideo = false;
  bool _isLoved = false;

  bool get isShowVideo => _isShowVideo;
  bool get isLoved => _isLoved;

  get token => null;

  Future<void> handleVideo() async {
    _isShowVideo = !isShowVideo;
    notifyListeners();
  }

  Future<void> handleLove(dynamic nasheedId, dynamic userId) async {
    _isLoved = !isLoved;
    if (_isLoved == true) {
      final response = await http.post(
        Uri.parse("$baseUrl/nasheed/love"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await dbHelper.getToken()}',
        },
        body: jsonEncode({'nasheed_id': nasheedId, 'user_id': userId}),
      );
    } else {
      final response = await http.post(
        Uri.parse("$baseUrl/nasheed/love/remove"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await dbHelper.getToken()}',
        },
        body: jsonEncode({'nasheed_id': nasheedId, 'user_id': userId}),
      );
    }
    notifyListeners();
  }

  Future<void> setLove(dynamic nasheedId, dynamic userId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/nasheed/love/check"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await dbHelper.getToken()}',
      },
      body: jsonEncode({'nasheed_id': nasheedId, 'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _isLoved = data['loved'];
      notifyListeners();
    } else {
      print("Failed to love");
    }
  }
}
