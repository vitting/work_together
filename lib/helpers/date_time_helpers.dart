import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_i18n/flutter_i18n.dart';

class DateTimeHelpers {
  static int weekInYear(DateTime date) {
    return int.parse(formatDate(date, [W]));
  }

  static String ddmmyyyyHHnn(DateTime date) {
    try {
      return formatDate(date, [dd, "-", mm, "-", yyyy, "  ", HH, ":", nn]);
    } catch (e) {
      print("DateTimeHelpers.ddmmyyyyHHnn : $e");
      return "";
    }
  }

  // static String ddMMyyyyHHnn(BuildContext context, DateTime date) {
  //   try {
  //     return formatDate(date, [
  //       dd,
  //       ". ",
  //       FlutterI18n.translate(context, "monthsShort.${date.month}"),
  //       " ",
  //       yyyy,
  //       " ",
  //       HH,
  //       ":",
  //       nn
  //     ]);
  //   } catch (e) {
  //     print("DateTimeHelpers.ddMMyyyyHHnn : $e");
  //     return "";
  //   }
  // }

  static String ddmmyyyy(DateTime date) {
    return formatDate(date, [dd, "-", mm, "-", yyyy]);
  }

  // static String ddMMyyyy(BuildContext context, DateTime date) {
  //   // return formatDate(date, [dd, ". ", monthsShort[date.month], " ", yyyy]);
  //   return formatDate(date, [
  //     dd,
  //     ". ",
  //     FlutterI18n.translate(context, "monthsShort.${date.month}"),
  //     " ",
  //     yyyy
  //   ]);
  // }

  // static String dMMyyyy(BuildContext context, DateTime date) {
  //   // return formatDate(date, [d, ". ", monthsShort[date.month], " ", yyyy]);
  //   return formatDate(date, [
  //     d,
  //     ". ",
  //     FlutterI18n.translate(context, "monthsShort.${date.month}"),
  //     " ",
  //     yyyy
  //   ]);
  // }

  // static String ddMM(BuildContext context, DateTime date) {
  //   // return formatDate(date, [dd, ". ", monthsShort[date.month]]);
  //   return formatDate(date, [
  //     dd,
  //     ". ",
  //     FlutterI18n.translate(context, "monthsShort.${date.month}")
  //   ]);
  // }

  static String hhnn(dynamic date) {
    DateTime dateToFormat;
    if (date is TimeOfDay) {
      TimeOfDay tod = date;
      dateToFormat = DateTime(2000, 1, 1, tod.hour, tod.minute);
    } else {
      dateToFormat = date;
    }
    return formatDate(dateToFormat, [HH, ":", nn]);
  }

  static Duration totalTime(DateTime date1, DateTime date2) {
    return date2.difference(date1);
  }

  static bool dateCompare(DateTime date1, DateTime date2) {
    DateTime a = DateTime(date1.year, date1.month, date1.day);
    DateTime b = DateTime(date2.year, date2.month, date2.day);

    return a.compareTo(b) == 0 ? true : false;
  }

  static int getAge(DateTime birthdate) {
    if (birthdate == null) return 0;

    DateTime today = DateTime.now();
    int years = today.year - birthdate.year;
    int age;
    if (birthdate.month <= today.month) {
      if (today.day < birthdate.day) {
        age = years - 1;
      } else
        age = years;
    } else {
      age = years - 1;
    }

    return age;
  }

  static bool isVvalidDateFormat(String dateString) {
    RegExp reg = RegExp(r"^[0-3]\d-[0-1]\d-[1-2][09]\d\d$");
    return reg.hasMatch(dateString);
  }
}
