import 'package:intl/intl.dart';

class LocaleService {
  static final _groupFormat = NumberFormat('#,##0');
  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static final _timeFormat = DateFormat('HH:mm');

  // Thin space (U+202F) as thousands separator — XOF convention.
  String formatXof(int amount) =>
      '${_groupFormat.format(amount).replaceAll(',', ' ')} F';

  String formatDate(DateTime dt) => _dateFormat.format(dt);

  String formatTime(DateTime dt) => _timeFormat.format(dt);
}
