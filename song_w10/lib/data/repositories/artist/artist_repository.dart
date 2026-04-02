import 'package:song_w10/model/comment/comment.dart';
import 'package:song_w10/model/songs/song.dart';

import '../../../model/artist/artist.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists();

  Future<Artist?> fetchArtistById(String id);

  void clearCache();

  Future<List<Song>> fetchSongByArtist(String artistId);
  Future<List<Comment>> fetchCommentByArtist(String artistId);
  Future<void> addComment(String artistId, String content);
}
