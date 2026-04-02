import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/comment/comment.dart';
import '../../../../model/songs/song.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';
import '../view_model/artist_detail_view_model.dart';
import 'comment_form.dart';
import 'comment_tile.dart';
import 'song_tile.dart';

class ArtistDetailContent extends StatelessWidget {
  const ArtistDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    ArtistDetailViewModel mv = context.watch<ArtistDetailViewModel>();

    final songsAsync = mv.songsValue;
    final commentsAsync = mv.commentsValue;

    return Scaffold(
      appBar: AppBar(
        title: Text("Artist Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Songs Section
            Text("Songs", style: AppTextStyles.heading),
            SizedBox(height: 16),
            Expanded(flex: 2, child: _buildSongsSection(songsAsync)),
            SizedBox(height: 24),

            // Comments Section
            Text("Comments", style: AppTextStyles.heading),
            SizedBox(height: 16),
            Expanded(flex: 2, child: _buildCommentsSection(commentsAsync)),
          ],
        ),
      ),
      bottomNavigationBar: CommentForm(
        onSubmit: (content) async {
          await mv.addComment(content);
        },
      ),
    );
  }

  Widget _buildSongsSection(AsyncValue<List<Song>> asyncValue) {
    switch (asyncValue.state) {
      case AsyncValueState.loading:
        return Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Center(
          child: Text(
            'Error loading songs: ${asyncValue.error}',
            style: TextStyle(color: Colors.red),
          ),
        );
      case AsyncValueState.success:
        final songs = asyncValue.data!;
        if (songs.isEmpty) {
          return Center(
            child: Text(
              'No songs available',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) => SongTile(song: songs[index]),
        );
    }
  }

  Widget _buildCommentsSection(AsyncValue<List<Comment>> asyncValue) {
    switch (asyncValue.state) {
      case AsyncValueState.loading:
        return Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Center(
          child: Text(
            'Error loading comments: ${asyncValue.error}',
            style: TextStyle(color: Colors.red),
          ),
        );
      case AsyncValueState.success:
        final comments = asyncValue.data!;
        if (comments.isEmpty) {
          return Center(
            child: Text(
              'No comments yet. Be the first to comment!',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) =>
              CommentTile(comment: comments[index]),
        );
    }
  }
}
