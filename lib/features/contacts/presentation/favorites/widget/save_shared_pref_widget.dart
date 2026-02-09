import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveSharedPrefWidget {
  static const _key = 'favorite_contact_ids';

  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  static Future<Set<String>> getIds() async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList(_key) ?? <String>[];
    return list.toSet();
  }

  static Future<bool> isFav(String id) async {
    if (id.isEmpty) return false;
    final ids = await getIds();
    return ids.contains(id);
  }

  static Future<void> add(String id) async {
    if (id.isEmpty) return;

    final sp = await SharedPreferences.getInstance();
    final ids = (sp.getStringList(_key) ?? <String>[]).toSet();

    final before = ids.length;
    ids.add(id);
  
    if (ids.length != before) {
      await sp.setStringList(_key, ids.toList());
      changes.value++;
    }
  }

  static Future<void> remove(String id) async {
    if (id.isEmpty) return;

    final sp = await SharedPreferences.getInstance();
    final ids = (sp.getStringList(_key) ?? <String>[]).toSet();

    final changed = ids.remove(id);
    if (changed) {
      await sp.setStringList(_key, ids.toList());
      changes.value++;
    }
  }

  static Future<void> toggle(String id) async {
    if (id.isEmpty) return;

    final sp = await SharedPreferences.getInstance();
    final ids = (sp.getStringList(_key) ?? <String>[]).toSet();

    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }

    await sp.setStringList(_key, ids.toList());
    changes.value++;
  }

  static Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_key);
    changes.value++;
  }
}
