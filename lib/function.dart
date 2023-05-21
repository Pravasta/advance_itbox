import 'package:intl/intl.dart';

String formatDateTime(DateTime? dateTime) {
  if (dateTime == null) return '';
  // EEE => akan jadi Mondey, tuesday dll
  var format = DateFormat('EEE, dd-MM-yyyy');
  return format.format(dateTime);
}
