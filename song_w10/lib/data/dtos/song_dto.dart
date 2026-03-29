import '../../model/songs/song.dart';

class SongDto {
  static const String titleKey = 'title';
  static const String durationKey = 'duration'; // in ms
  static const String artistIdKey = 'artistId';
  static const String imageUrlKey = 'imageUrl';
  static const String isLike = 'isLike';
  static const String totalLike = 'totalLike';

  static Song fromJson(String id, Map<String, dynamic> json) {
    assert(json[titleKey] is String);
    assert(json[durationKey] is int);
    assert(json[artistIdKey] is String);
    assert(json[imageUrlKey] is String);
    assert(json[isLike] is bool);
    assert(json[totalLike] is int);

    return Song(
      id: id,
      title: json[titleKey],
      artistId: json[artistIdKey],
      duration: Duration(milliseconds: json[durationKey]),
      imageUrl: Uri.parse(json[imageUrlKey]), 
      isLike: json[isLike], 
      totalLike: json[totalLike],
    );
  }

  /// Convert Song to JSON
  Map<String, dynamic> toJson(Song song) {
    return {
      titleKey: song.title,
      artistIdKey: song.artistId,
      durationKey: song.duration.inMilliseconds,
      imageUrlKey: song.imageUrl.toString(),
      isLike: song.isLike,
      totalLike: song.totalLike
    };
  }
}
