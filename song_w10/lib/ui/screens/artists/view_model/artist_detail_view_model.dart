import 'package:flutter/material.dart';
import 'package:song_w10/model/comment/comment.dart';
import 'package:song_w10/model/songs/song.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../utils/async_value.dart';

class ArtistDetailViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;
  final String artistId;

  AsyncValue<Artist?> artistValue = AsyncValue.loading();
  AsyncValue<List<Song>> songsValue = AsyncValue.loading();
  AsyncValue<List<Comment>> commentsValue = AsyncValue.loading();

  ArtistDetailViewModel({
    required this.artistRepository,
    required this.artistId,
  }) {
    _init();
  }

  void _init() async {
    fetchData();
  }

  void fetchData() async {
    artistValue = AsyncValue.loading();
    songsValue = AsyncValue.loading();
    commentsValue = AsyncValue.loading();
    notifyListeners();

    try {
      Artist? artist = await artistRepository.fetchArtistById(artistId);
      List<Song> songs = await artistRepository.fetchSongByArtist(artistId);
      List<Comment> comments = await artistRepository.fetchCommentByArtist(
        artistId,
      );

      artistValue = AsyncValue.success(artist);
      songsValue = AsyncValue.success(songs);
      commentsValue = AsyncValue.success(comments);
    } catch (e) {
      artistValue = AsyncValue.error(e);
      songsValue = AsyncValue.error(e);
      commentsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> addComment(String content) async {
    if (content.isEmpty) return;

    try {
      await artistRepository.addComment(artistId, content);

      final comments = await artistRepository.fetchCommentByArtist(artistId);
      commentsValue = AsyncValue.success(comments);

      notifyListeners();
    } catch (e) {
      commentsValue = AsyncValue.error(e);
      notifyListeners();
    }
  }
}
