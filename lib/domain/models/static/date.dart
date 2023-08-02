abstract class MehDate {
  static String? getYYYYMMDD(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }
    String day = dateTime.day > 9 ? "${dateTime.day}" : "0${dateTime.day}";
    String month =
        dateTime.month > 9 ? "${dateTime.month}" : "0${dateTime.month}";
    String year = dateTime.year.toString();
    return "$day-$month-$year";
  }

  static DateTime? getDateTime(String? dateString) {
    if (dateString == null) {
      return null;
    }
    return DateTime(
      int.parse(dateString.substring(0, 4)),
      int.parse(dateString.substring(5, 7)),
      int.parse(dateString.substring(8, 10)),
    ); //01-34-6789
  }
}
