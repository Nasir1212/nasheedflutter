import 'package:flutter/material.dart';
import 'package:naate/db/database_helper.dart';

class AuthProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  void loadToken() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final Map<String, dynamic>? user = await dbHelper.getUser();
    _token = user?['token'];
    print("Load Token: ${user?['token']}");
    notifyListeners();
  }
}
