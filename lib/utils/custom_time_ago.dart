
import 'package:timeago/timeago.dart' as timeago;

class CustomTimeAgo implements timeago.LookupMessages {
  @override
  String aDay(int hours) => '1 วัน';

  @override
  String aboutAMinute(int minutes) => '$minutes นาที';

  @override
  String aboutAMonth(int days) => '$days วัน';

  @override
  String aboutAYear(int year) => '$year ปี';

  @override
  String aboutAnHour(int minutes) => '$minutes นาที';

  @override
  String days(int days) => '$days วัน';

  @override
  String hours(int hours) => '$hours ชั่วโมง';

  @override
  String lessThanOneMinute(int seconds) => 'ตอนนี้';

  @override
  String minutes(int minutes) => '$minutes นาที';

  @override
  String months(int months) => '$months เดือน';

  @override
  String prefixAgo() => '';

  @override
  String prefixFromNow() => '';

  @override
  String suffixAgo() => 'ที่แล้ว';

  @override
  String suffixFromNow() => '';

  @override
  String wordSeparator() => '';

  @override
  String years(int years) => '$years ปี';
}