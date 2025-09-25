import 'package:intl/intl.dart';

String formatDateByDMMMYYYYY(DateTime dateTime) {
  return DateFormat("d MMM, yyyy").format(dateTime);
}
