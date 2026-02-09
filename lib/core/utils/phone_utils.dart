class PhoneUtils {
  static String digitsOnly(String v) => v.replaceAll(RegExp(r'\D'), '');

  static String last9(String v) {
    final d = digitsOnly(v);
    if (d.length <= 9) return d;
    return d.substring(d.length - 9);
  }

  static bool isSavedUz9({
    required List<dynamic> contacts,
    required String input,
    required String Function(dynamic c) getPhone,
  }) {
    final in9 = last9(input);
    if (in9.length < 9) return false;

    for (final c in contacts) {
      final p9 = last9(getPhone(c));
      if (p9 == in9) return true;
    }
    return false;
  }
}
