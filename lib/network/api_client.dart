import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:melomaniacs/models/api_status.dart';
import 'package:melomaniacs/models/song.dart';

import '../models/lyrics.dart';
import '../utils/constants.dart';



extension CheckStatusCode on http.Response{
  bool isSuccessful(){
    return statusCode >= 200 && statusCode <= 300;
  }
} 


class ApiClient{
  final String baseUrl = baseURL;
  final String songEndPoint = "/song";
  late final String searchSongEndPoint = "$songEndPoint/all";
  late final String lyricsSongEndPoint = "$songEndPoint/lyrics";


  Future<ApiResponse<List<Song>>> getSongs(String query) async{
    try {
      var url = Uri.https(baseUrl,searchSongEndPoint,{
        'search' : query
      });
      var response = await http.get(url);
      if(response.isSuccessful()){
        return Success(songFromJson(response.body));
      }else{
        return Failure(response.reasonPhrase);
      }

    }on HttpException{
      return Failure("No Internet");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResponse<List<Lyrics>>> getLyrics(String query) async{
    try {
      var url = Uri.https(baseUrl,lyricsSongEndPoint,{
        'link' : query
      });
      var response = await http.get(url);
      if(response.isSuccessful()){
        return Success(lyricsFromJson(response.body));
      }else{
        return Failure(response.reasonPhrase);
      }

    }on HttpException{
      return Failure("No Internet");
    } catch (e) {
      return Failure(e.toString());
    }
    
  }

  

}