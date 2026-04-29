class AppDateUtils {
  static String dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static String formatDate(DateTime date) {
    return '${date.month}月${date.day}日';
  }

  static String formatDateTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.month}月${date.day}日 $hour:$minute';
  }

  static String weekdayLabel(DateTime date) {
    const labels = ['一', '二', '三', '四', '五', '六', '日'];
    return '周${labels[date.weekday - 1]}';
  }

  static int daysBetween(DateTime from, DateTime to) {
    return startOfDay(to).difference(startOfDay(from)).inDays;
  }
}
