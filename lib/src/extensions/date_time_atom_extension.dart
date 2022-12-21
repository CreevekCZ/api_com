extension DateTimeAtomExtension on DateTime {
  String _fixedLength(int n, int count) => n.toString().padLeft(count, '0');

  String toAtom() {
    final zoneMark = timeZoneOffset.inHours > (-1) ? '+' : '';
    return '$year-${_fixedLength(month, 2)}-${_fixedLength(day, 2)}T${_fixedLength(hour, 2)}:${_fixedLength(minute, 2)}:${_fixedLength(second, 2)}$zoneMark${_fixedLength(timeZoneOffset.inHours, 2)}:00';
  }

  static DateTime parseWithTimeZone(String date) {
    final RegExp timeZoneExp = RegExp(r'\+(\d+)');
    final RegExpMatch? timeZoneMatch = timeZoneExp.firstMatch(date);
    final int timeZone = int.parse(timeZoneMatch?.group(1) ?? '0');

    return DateTime.parse(date).add(Duration(hours: timeZone));
  }
}
