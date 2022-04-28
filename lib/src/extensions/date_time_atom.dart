extension DateTimeAtom on DateTime {
  String _fixedLength(int n, int count) => n.toString().padLeft(count, "0");

  String toAtom() {
    // return DateFormat('yyyy-MM-ddTHH:mm:ss+00:00').format(this);
    var zoneMark = timeZoneOffset.inHours > (-1) ? '+' : '';
    return '$year-${_fixedLength(month, 2)}-${_fixedLength(day, 2)}T${_fixedLength(hour, 2)}:${_fixedLength(minute, 2)}:${_fixedLength(second, 2)}$zoneMark${_fixedLength(timeZoneOffset.inHours, 2)}:00';
  }
}
