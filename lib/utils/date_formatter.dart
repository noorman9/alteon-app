String formatOrderDate(DateTime date) {
  final parsedDate = date.toLocal();

  const months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final day = parsedDate.day;
  final month = months[parsedDate.month - 1];
  final year = parsedDate.year;

  final hour = parsedDate.hour.toString().padLeft(2, '0');
  final minute = parsedDate.minute.toString().padLeft(2, '0');

  return '$day $month $year, $hour:$minute';
}