class Song {
  final String id;
  final String title;
  final String artistId;
  final Duration duration;
  final Uri imageUrl;
  bool isLike;
  int totalLike;

  Song({
    required this.id,
    required this.title,
    required this.artistId,
    required this.duration,
    required this.imageUrl,
    required this.isLike,
    required this.totalLike,
  });

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artist id: $artistId, duration: $duration, isLike: $isLike, totalLike: $totalLike)';
  }

  Song copyWith({
    String? id,
    String? title,
    String? artistId,
    int? likes,
    Duration? duration,
    Uri? imageUrl,
    bool? isLike,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artistId: artistId ?? this.artistId,
      totalLike: likes ?? totalLike,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
      isLike: isLike ?? this.isLike,
    );
  }
}
