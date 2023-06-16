import 'package:intl/intl.dart';

extension Demask on String {
  String removeMaskElement() {
    return replaceAll("(", "")
      ..replaceAll(")", "")
      ..replaceAll(" ", "");
  }

  String addMaskElement() {
    String a, b, c, d, e;
    a = substring(0, 1);
    b = substring(1, 4);
    c = substring(4, 7);
    d = substring(7, 9);
    e = substring(9, 11);

    return a + " (" + b + ") " + c + " " + d + " " + e;
  }

  bool isNumeric() {
    // ignore: unnecessary_null_comparison
    if (this == null) {
      return false;
    }
    return double.tryParse(this) != null;
  }

  String capitalize() {
    // ignore: unnecessary_this
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String convertDayYearFormat() {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var date1 = inputFormat.parse(this);

    var outputFormat = DateFormat('dd-MM-yyyy');
    var date2 = outputFormat.format(date1);

    return date2;
  }

  String convertDayYearFormatWithDot() {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var date1 = inputFormat.parse(this);

    var outputFormat = DateFormat('dd.MM.yyyy');
    var date2 = outputFormat.format(date1);

    return date2;
  }

  String convertYearDayFormat() {
    var inputFormat = DateFormat('dd-MM-yyyy');
    var date1 = inputFormat.parse(this);

    var outputFormat = DateFormat('yyyy-MM-dd');
    var date2 = outputFormat.format(date1);

    return (date2);
  }

  String convertCurrency() {
    return NumberFormat.currency(
      locale: "tr_TR",
      symbol: "₺",
    )
        .format(double.tryParse(this))
        .substring(
            0,
            // ignore: unnecessary_this
            this.length)
        .replaceAll(",", "");
  }
}
