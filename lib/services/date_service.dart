class DateService {
  String getPrintableDate(DateTime date) {
    return '${date.year}/${date.month}${date.day}';
  }

  String getAgeFromDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    final days = diff.inDays;

    if (days < 365) {
      if (days < 93) {
        return '$days ${days == 1 ? 'day' : 'days'} old';
      }

      final months = days ~/ 30;
      return '$months ${months == 1 ? 'month' : 'months'} old';
    }

    final years = days ~/ 365;
    return '$years ${years == 1 ? 'year' : 'years'} old';
  }
}
