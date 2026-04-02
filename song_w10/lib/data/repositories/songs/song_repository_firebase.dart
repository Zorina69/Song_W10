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

  List<Song>? _cachedSongs;

  @override
  Future<List<Song>> fetchSongs() async {
    if (_cachedSongs != null) {
      return _cachedSongs!;
    }
    final http.Response response = await http.get(songsUri());

    if (response.statusCode == 200) {
      final dynamic decodedBody = json.decode(response.body);

      // Handle null response (no songs exist yet)
      if (decodedBody == null) {
        return [];
      }

      final Map<String, dynamic> songsJson =
          decodedBody as Map<String, dynamic>;

      List<Song> result = [];
      for (final entry in songsJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      _cachedSongs = result;
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
    final newtotalLike = isLike ? currentLikes + 1 : currentLikes - 1;
    final newIsLike = isLike;

    // ✅ Patch only the specific song using its ID
    final http.Response response = await http.patch(
      songByIdUri(id),
      body: json.encode({'totalLike': newtotalLike, 'isLike': newIsLike}),
    );

    if (response.statusCode >= 400) {
      throw Exception('Failed to update like');
    }
  }

  @override
  void clearCache() {
    _cachedSongs = null;
    // TODO: implement clearCache
  }
}
