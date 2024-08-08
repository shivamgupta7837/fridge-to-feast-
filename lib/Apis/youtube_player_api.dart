import 'dart:convert';

import 'package:fridge_to_feast/keys/api_keys.dart';
import 'package:fridge_to_feast/models/youtube_player_model.dart';
import 'package:http/http.dart' as http;

class YoutubePlayerApi {
  final ApiKey _apiKey = ApiKey();
  Future<YoutubePlayerModel> getVideoSearch(
      {required String searchVideoTitle}) async {
    final key = _apiKey.getYoutubeKey();
    final response = await http.get(Uri.parse(
        "https://www.googleapis.com/youtube/v3/search?key=$key&q=$searchVideoTitle&type=video&part=snippet&maxResults=50"));
    if (response.statusCode == 200) {
      return YoutubePlayerModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load YouTube data");
    }
  }
}
