import 'package:contacts_phone/features/contacts/data/models/contacts_model.dart';

import 'phone_format.dart';

class DialSearch {
  static bool isSavedUz9<T>({
    required List<T> contacts,
    required String inputDigits,
    required String Function(T c) getPhone,
  }) {
    final in9 = PhoneFormat.last9(inputDigits);
    if (in9.length < 9) return false;

    for (final c in contacts) {
      final p9 = PhoneFormat.last9(getPhone(c));
      if (p9 == in9) return true;
    }
    return false;
  }

  static List<ContactsModel> searchContacts({
    required List<ContactsModel> contacts,
    required String queryDigits,
  }) {
    final q = PhoneFormat.digitsOnly(queryDigits);
    if (q.isEmpty) return <ContactsModel>[];

    final qLocal = q.length > 9 ? PhoneFormat.last9(q) : q;

    final byPhone = <ContactsModel>[];
    final byName = <ContactsModel>[];

    for (final c in contacts) {
      final p = PhoneFormat.digitsOnly(c.phoneNumber);
      if (p.isNotEmpty) {
        final local = p.startsWith('998') ? p.substring(3) : PhoneFormat.last9(p);
        if (local.startsWith(qLocal)) {
          byPhone.add(c);
          continue;
        }
      }

      final name = ('${c.firstName} ${c.lastName}').trim();
      if (name.isNotEmpty) {
        final t9 = _t9Digits(name);
        if (t9.startsWith(q)) byName.add(c);
      }
    }

    final merged = <ContactsModel>[];
    merged.addAll(byPhone);
    for (final c in byName) {
      if (!merged.contains(c)) merged.add(c);
    }
    return merged.take(12).toList();
  }

  static String _t9Digits(String name) {
    final s = name.toLowerCase();
    final buf = StringBuffer();
    for (final r in s.runes) {
      final ch = String.fromCharCode(r);
      final d = _t9Map[ch];
      if (d != null) buf.write(d);
    }
    return buf.toString();
  }

  static const Map<String, String> _t9Map = {
    'a': '2',
    'b': '2',
    'c': '2',
    'd': '3',
    'e': '3',
    'f': '3',
    'g': '4',
    'h': '4',
    'i': '4',
    'j': '5',
    'k': '5',
    'l': '5',
    'm': '6',
    'n': '6',
    'o': '6',
    'p': '7',
    'q': '7',
    'r': '7',
    's': '7',
    't': '8',
    'u': '8',
    'v': '8',
    'w': '9',
    'x': '9',
    'y': '9',
    'z': '9',
  };
}
