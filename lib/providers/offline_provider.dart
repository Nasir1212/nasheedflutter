import 'package:flutter/foundation.dart';
import 'package:naate/db/database_helper.dart';
import 'package:naate/model/lyrics_model.dart';

class OfflineProvider with ChangeNotifier{
   List<LyricsModel> _offlineData = [];
  List<LyricsModel> get offlineData => _offlineData;
 late bool _isDownloaded  = false   ;
  bool get  isDownloaded => _isDownloaded;


Future<void> fetchItem() async{

  final items  =  await DatabaseHelper().fetchItems();
   _offlineData = items.map((item) => LyricsModel.fromJson(item)).toList();
   notifyListeners();
}

Future<void> notDownload (int id) async{
  _isDownloaded   =  await DatabaseHelper().notDownload(id);
  
  notifyListeners();
}

}