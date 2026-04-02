import 'dart:async';

class DownloadProgress {
  final int progressInPerc;
  final DateTime timestamp;

  DownloadProgress({required this.progressInPerc, required this.timestamp});
}

class DownloadService {
  final StreamController<DownloadProgress> _controller =
      StreamController<DownloadProgress>();

  Stream<DownloadProgress> get stream => _controller.stream;

  void startDownload() async {
    for (int num = 0; num <= 100; num += 10) {
      await Future.delayed(Duration(milliseconds: 700));
      _controller.add(
        DownloadProgress(progressInPerc: num, timestamp: DateTime.now()),
      );
    }
    _controller.close();
  }
}

void main() {
  DownloadService service = DownloadService();

  service.stream.listen(
    (progress) {
      print('${progress.timestamp}: ${progress.progressInPerc}%');
    },
    onDone: () {
      print('Download complete!');
    },
  );

  service.startDownload();
}
