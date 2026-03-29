import 'package:flutter/widgets.dart';

import '../../model/songs/song.dart';

class PlayerState extends ChangeNotifier {
  Song? _currentSong;

  Song? get currentSong => _currentSong;

  void like(Song song) {
    _currentSong = song;
    if (song.isLike) {
      song.totalLike -= 1;
      song.isLike == false;
      notifyListeners();
    } else {
      song.totalLike += 1;
      song.isLike == true;
      notifyListeners();
    }
    //notifyListeners();
  }

  void start(Song song) {
    _currentSong = song;

    notifyListeners();
  }

  void stop() {
    _currentSong = null;

    notifyListeners();
  }
}
