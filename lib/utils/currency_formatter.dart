String formatRupiah(num value) {
  final valueString = value.toStringAsFixed(0);

  final formatted = valueString.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );

  return 'Rp $formatted';
}