String getDateFromString(String input) {
  /// الفاصل -
  DateTime now = DateTime.now();
  List<String> parts = input.split('-');

  if (parts.length == 3) {
    // صيغة اليوم-الشهر-السنة: 15-5-2023
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day).toString().split(" ")[0];
  } else if (parts.length == 2) {
    // صيغة اليوم-الشهر: 15-5
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = now.year;
    return DateTime(year, month, day).toString().split(" ")[0];
  } else if (parts.length == 1) {
    // صيغة اليوم فقط: 15
    int day = int.parse(parts[0]);
    int month = now.month;
    int year = now.year;
    return DateTime(year, month, day).toString().split(" ")[0];
  } else {
    // throw const FormatException("صيغة غير صحيحة");
    return DateTime.now().toString().split(" ")[0];
  }
}