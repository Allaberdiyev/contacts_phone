class PhoneFormat {
  static String digitsOnly(String v) => v.replaceAll(RegExp(r'\D'), '');

  static String displayText(String dial) {
    if (dial.isEmpty) return '';
    if (dial.contains('*') || dial.contains('#')) return dial;

    final isPlus = dial.startsWith('+');
    final d = digitsOnly(dial);
    if (d.isEmpty) return dial;

    if (d.startsWith('998')) {
      final local = d.substring(3);
      final head = isPlus ? '+998' : '998';
      if (local.isEmpty) return head;

      final shownLocal = local.length <= 9 ? _uz9(local) : local;
      return '$head $shownLocal';
    }

    if (!isPlus && d.length <= 9) return _uz9(d);

    return dial;
  }

  static String last9(String v) {
    final d = digitsOnly(v);
    if (d.length <= 9) return d;
    return d.substring(d.length - 9);
  }

  static String last9UzHyphen(String input) {
    final d = digitsOnly(input);
    if (d.isEmpty) return '';
    if (d.length <= 9) return _uz9(d);

    final prefix = d.substring(0, d.length - 9);
    final last = d.substring(d.length - 9);
    return '$prefix-${_uz9(last)}';
  }

  static String toUzE164FromDigits(String inputDigits) {
    final d = digitsOnly(inputDigits);
    if (d.isEmpty) return '+998';

    if (d.startsWith('998')) {
      final local = d.substring(3);
      final last = local.length >= 9
          ? local.substring(local.length - 9)
          : local;
      return '+998$last';
    }

    final last = d.length >= 9 ? d.substring(d.length - 9) : d;
    return '+998$last';
  }

  static String formatUzWithCountry(String phone) {
    final d = digitsOnly(phone);

    if (d.startsWith('998')) {
      final local = d.substring(3);
      final local9 = local.length > 9
          ? local.substring(local.length - 9)
          : local;
      return '+998 ${_uz9(local9)}';
    }

    if (d.length >= 9) {
      final local9 = d.substring(d.length - 9);
      return '+998 ${_uz9(local9)}';
    }

    return phone;
  }

  static String _uz9(String n) {
    if (n.length <= 2) return n;
    if (n.length <= 5) return '${n.substring(0, 2)}-${n.substring(2)}';
    if (n.length <= 7) {
      return '${n.substring(0, 2)}-${n.substring(2, 5)}-${n.substring(5)}';
    }
    return '${n.substring(0, 2)}-${n.substring(2, 5)}-${n.substring(5, 7)}-${n.substring(7)}';
  }
}
