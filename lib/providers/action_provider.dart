import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:naate/constant.dart';

class ActionProvider with ChangeNotifier {
  late bool _isShowVideo = false;
  bool _isLoved = false;

  bool get isShowVideo => _isShowVideo;
  bool get isLoved => _isLoved;

  Future<void> handleVideo() async {
    _isShowVideo = !isShowVideo;
    notifyListeners();
  }

  Future<void> handleLove(int nasheedId) async {
    _isLoved = !isLoved;
    if (_isLoved == true) {
      print("Love");
      final response = await http.post(
        Uri.parse("$baseUrl/nasheed/love"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nasheed_id': nasheedId, 'user_id': 1}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
      } else {
        print("Failed to love");
      }
    } else {
      final response = await http.post(
        Uri.parse("$baseUrl/nasheed/love/remove"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nasheed_id': nasheedId, 'user_id': 1}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
      } else {
        print("Failed to love");
      }
      print("Unlove");
    }
    notifyListeners();
  }

  Future<void> setLove(int nasheedId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/nasheed/love/check"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nasheed_id': nasheedId, 'user_id': 1}),
    );
    print("Status code is  ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _isLoved = data['loved'];
      notifyListeners();
    } else {
      print("Failed to love");
    }
  }
}
