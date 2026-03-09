String padZero(int value, int width) {
  return value.toString().padLeft(width, '0');
}

String secondToMinuteFormat(int second) {
  return "${(second / 60).floor()}:${padZero((second % 60).toInt(), 2)}";
}

String dateToString(DateTime date) {
  return "${padZero(date.year, 4)}-${padZero(date.month, 2)}-${padZero(date.day, 2)}";
}
