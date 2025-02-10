import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:naate/model/video_link_model.dart';
import 'package:naate/services/video_link_service.dart';

class VideoLinkProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<VideoLinkModel> _videoLink = [];
  List<VideoLinkModel> get videoLink => _videoLink;

  Future<void> fetchVideoLink(int id) async {
    _isLoading = true;
    try {
      _videoLink = await VideoLinkService.fetchVidoLink(id);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
