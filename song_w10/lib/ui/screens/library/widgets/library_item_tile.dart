import 'package:flutter/material.dart';
import '../view_model/library_item_data.dart';

class LibraryItemTile extends StatelessWidget {
  const LibraryItemTile({
    super.key,
    required this.data,
    required this.isPlaying,
    required this.onTap,
    required this.isLike,
  });

  final LibraryItemData data;
  final VoidCallback isLike;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          selectedTileColor: isPlaying? Colors.amber : Colors.white,
          onTap: onTap,
          title: Text(data.song.title),
          subtitle: Row(
            children: [
              Text("${data.song.duration.inMinutes} mins"),
              SizedBox(width: 20),
              Text(data.artist.name),
              SizedBox(width: 20),
              Text(data.artist.genre),
              SizedBox(width: 20),
              Text(data.song.totalLike.toString()),
            ],
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(data.song.imageUrl.toString()),
          ),
          trailing: IconButton(
            onPressed: isLike,
            icon: Icon(Icons.heart_broken),
            color: data.song.isLike ? Colors.red : Colors.grey,
          ),
        ),
      ),
    );
  }
}
