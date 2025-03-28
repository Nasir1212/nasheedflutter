import 'dart:io';
import 'package:flutter/material.dart';
import 'package:naate/model/lyricist_model.dart';
import 'package:naate/services/lyricist_service.dart';

class LyricistPorvider with ChangeNotifier {
  bool _isLoading = false;
  List<LyricistModel> _lyricist = [];
  LyricistModel? _lyricistData;
  LyricistModel? get lyricistData => _lyricistData;
  bool get isLoading => _isLoading;
  List get lyricist => _lyricist;
  List<LyricistModel> _searchLyricist = [];
  List get searchLyricist => _searchLyricist;

  Future<void> fetchData() async {
    print("Test Provider");
    _isLoading = true;
    try {
      _lyricist = await LyricistService.fetchLyricist();
      print(
          "Shayer Result form provider ${await LyricistService.fetchLyricist()}");
      notifyListeners();
    } on SocketException catch (e) {
      print("Network Failed $e");
    } catch (e) {
      print("Failed data from provider  $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBySearch(String value) async {
    _isLoading = true;
    try {
      _searchLyricist = await LyricistService.fetchBySearch(value);
      notifyListeners();
    } on SocketException catch (e) {
      print("Network Failed $e");
    } catch (e) {
      print("Failed data from provider  $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchById(int id) async {
    _isLoading = true;
    try {
      _lyricistData = _lyricist.firstWhere((element) => element.id == id);

      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
