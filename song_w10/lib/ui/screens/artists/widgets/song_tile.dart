import 'package:flutter/material.dart';
import '../../../../model/songs/song.dart';

class SongTile extends StatelessWidget {
  const SongTile({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(song.imageUrl.toString()),
          ),
          title: Text(song.title),
          subtitle: Text(
            "${song.duration.inMinutes}:${(song.duration.inSeconds % 60).toString().padLeft(2, '0')} mins",
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite, size: 16, color: Colors.pink),
              SizedBox(width: 4),
              Text("${song.totalLike}"),
            ],
          ),
        ),
      ),
    );
  }
}
