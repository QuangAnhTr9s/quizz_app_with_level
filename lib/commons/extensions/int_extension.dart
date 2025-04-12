extension IntExtension on int {
  String formatSecondToStringTimer() {
    int input = this;
    int minutes = input ~/ 60;
    int seconds = input % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
