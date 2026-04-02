import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:song_w10/data/dtos/song_dto.dart';
import 'package:song_w10/model/comment/comment.dart';
import 'package:song_w10/model/songs/song.dart';

import '../../../model/artist/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  final Uri artistsUri = Uri.https(
    'mytestdatabase-33021-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/artists.json',
  );

  final Uri songsUri = Uri.https(
    'mytestdatabase-33021-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/songs.json',
  );

  final Uri commentsUri = Uri.https(
    'mytestdatabase-33021-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/comments.json',
  );

  List<Artist>? _cachedArtists;

  @override
  Future<List<Artist>> fetchArtists() async {
    if (_cachedArtists != null) {
      return _cachedArtists!;
    }
    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      final dynamic decodedBody = json.decode(response.body);

      // Handle null response (no artists exist yet)
      if (decodedBody == null) {
        return [];
      }

      final Map<String, dynamic> artistsJson =
          decodedBody as Map<String, dynamic>;

      List<Artist> result = [];
      for (final entry in artistsJson.entries) {
        result.add(ArtistDto.fromJson(entry.key, entry.value));
      }
      _cachedArtists = result;
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load artists');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    // First try to find in cache
    if (_cachedArtists != null) {
      try {
        return _cachedArtists!.firstWhere((artist) => artist.id == id);
      } catch (e) {
        // Artist not found in cache, continue to fetch from server
      }
    }

    // Fetch from server
    final Uri artistUri = Uri.https(
      'w9-database-f4f07-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/artists/$id.json',
    );

    final http.Response response = await http.get(artistUri);

    if (response.statusCode == 200) {
      final dynamic decodedBody = json.decode(response.body);

      if (decodedBody == null) {
        return null; // Artist not found
      }

      final Map<String, dynamic> artistJson =
          decodedBody as Map<String, dynamic>;
      return ArtistDto.fromJson(id, artistJson);
    } else {
      throw Exception('Failed to load artist');
    }
  }

  @override
  Future<void> addComment(String artistId, String content) async {
    final newComment = {
      'artistId': artistId,
      'content': content,
      'createdAt': DateTime.now().toIso8601String(),
    };
    await http.post(commentsUri, body: json.encode(newComment));
  }

  @override
  Future<List<Comment>> fetchCommentByArtist(String artistId) async {
    final response = await http.get(commentsUri);

    if (response.statusCode == 200) {
      final dynamic decodedBody = json.decode(response.body);

      // Handle null response (no comments exist yet)
      if (decodedBody == null) {
        return [];
      }

      final Map<String, dynamic> commentsMap =
          decodedBody as Map<String, dynamic>;
      return commentsMap.entries
          .where((e) => e.value['artistId'] == artistId)
          .map(
            (e) => Comment(
              id: e.key,
              artistId: artistId,
              content: e.value['content'],
              createdAt: DateTime.parse(e.value['createdAt']),
            ),
          )
          .toList();
    } else {
      throw Exception("Failed to fetch comments by artist");
    }
  }

  @override
  Future<List<Song>> fetchSongByArtist(String artistId) async {
    final response = await http.get(songsUri);

    if (response.statusCode == 200) {
      final dynamic decodedBody = json.decode(response.body);

      // Handle null response (no songs exist yet)
      if (decodedBody == null) {
        return [];
      }

      final Map<String, dynamic> songsMap = decodedBody as Map<String, dynamic>;
      return songsMap.entries
          .where((e) => e.value['artistId'] == artistId)
          .map((e) => SongDto.fromJson(e.key, e.value))
          .toList();
    } else {
      throw Exception('Failed to fetch songs by artist');
    }
  }
  
  @override
  void clearCache() {
    // TODO: implement clearCache
  }
}
