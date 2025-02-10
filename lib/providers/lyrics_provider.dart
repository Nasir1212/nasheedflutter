import 'dart:io';
import 'package:flutter/material.dart';
import 'package:naate/model/lyrics_model.dart';
import 'package:naate/services/lyrics_service.dart';

class LyricsProvider with ChangeNotifier{
 List <LyricsModel> _lyrics =[];
 List <LyricsModel> _searchLyric = [];
bool _isLoading = false;
String _searchValue = "";
String get  searchValue => _searchValue;
LyricsModel? _oneLyric  ;
LyricsModel? get oneLyric => _oneLyric;
List get searchLyric => _searchLyric;
List get Lyrics => _lyrics;
bool get isLoading => _isLoading;
 final LyricsService lyricsService;
LyricsProvider({required this.lyricsService});

 Future<void> fetchLyrics () async{
   _isLoading = true;
      try {
        _lyrics = await lyricsService.fetchLyrics();
        notifyListeners();
      } catch (e) {
        print("The error is : $e");
      }finally {
      _isLoading = false;
      notifyListeners();
    }
 }

 Future<void> fetchLyricsByLyricist(int id)async {
   _isLoading = true;
   try {
     _lyrics = await lyricsService.fetchLyricsByLyricist(id);
     print("Not try fetch data ");
     notifyListeners();
   }on SocketException catch (e){
     print("Network Failed $e");
   
    } catch (e) {
     print("The error is  from provider fetch catch: $e");
    
   }finally{
    _isLoading = false;
    notifyListeners();
   }
 }

 Future<void> getByLyricsId(dynamic id) async {
   _isLoading = true;
 try {
      _oneLyric = await lyricsService.getByIdLyrics(id);
       notifyListeners();
 } catch (e) {
     print("Error fetching lyrics: $e");
     _oneLyric = null;
 }
 
 finally {
      _isLoading = false;
      notifyListeners();
    }
 }

 Future<void> fetchBySearch(String value)async{
  if (value.isEmpty) {
        _searchLyric = [];
        notifyListeners();
        return;
      }
      _searchValue = value;
    _isLoading = true;
    try {
      _searchLyric = await lyricsService.fetchBySearch(value);
      notifyListeners();
    } catch (e) {
      print("error is $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

 }

}