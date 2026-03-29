import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final String baseUrl =
      'mytestdatabase-33021-default-rtdb.asia-southeast1.firebasedatabase.app';

  Uri songsUri() => Uri.https(baseUrl, '/songs.json');

  // URI for a specific song by ID
  Uri songByIdUri(String id) => Uri.https(baseUrl, '/songs/$id.json');

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri());

    if (response.statusCode == 200) {
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      return result;
    } else {
      throw Exception('Failed to load songs');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    final http.Response response = await http.get(songByIdUri(id));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return SongDto.fromJson(id, data);
    } else {
      throw Exception('Failed to load song');
    }
  }

  @override
  Future<void> likeSong(String id, int currentLikes, bool isLike) async {
    final newLikes = isLike ? currentLikes - 1 : currentLikes + 1;
    final newIsLike = !isLike;

    // ✅ Patch only the specific song using its ID
    final http.Response response = await http.patch(
      songByIdUri(id),
      body: json.encode({'totalLike': newLikes, 'isLike': newIsLike}),
    );

    if (response.statusCode >= 400) {
      throw Exception('Failed to update like');
    }
  }
}
