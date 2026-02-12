import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_phone/features/contacts/presentation/favorites/widget/empty_favorite.dart';
import 'package:contacts_phone/features/contacts/presentation/favorites/widget/favorite_list.dart';
import 'package:flutter/material.dart';

import 'package:contacts_phone/app/theme.dart';
import 'package:contacts_phone/features/contacts/presentation/favorites/widget/save_shared_pref_widget.dart';
import 'package:contacts_phone/features/contacts/presentation/favorites/page/favorite_picker_page.dart';

import '../../../data/models/contacts_model.dart';

class FavoritePage extends StatefulWidget {
  final String title;
  const FavoritePage({super.key, required this.title});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool _editing = false;
  Set<String> _favIds = {};

  late final VoidCallback _favListener;

  @override
  void initState() {
    super.initState();
    _loadFavs();
    _favListener = () => _loadFavs();
    SaveSharedPrefWidget.changes.addListener(_favListener);
  }

  @override
  void dispose() {
    SaveSharedPrefWidget.changes.removeListener(_favListener);
    super.dispose();
  }

  Future<void> _loadFavs() async {
    final ids = await SaveSharedPrefWidget.getIds();
    if (!mounted) return;
    setState(() => _favIds = ids);
  }

  Future<void> _removeFav(String id) async {
    await SaveSharedPrefWidget.remove(id);
  }

  Future<void> _openPicker() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const FavoritePickerPage()),
    );
    if (changed == true) {
      await _loadFavs();
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final textMain = p.text;
    final background = p.bg;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('contacts')
              .orderBy('firstName')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: textMain),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data!.docs;
            final all = docs
                .map(
                  (d) => ContactsModel.fromJson(
                    d.data() as Map<String, dynamic>,
                    d.id,
                  ),
                )
                .toList();

            final favorites = all.where((c) => _favIds.contains(c.id)).toList();
            final isEmpty = favorites.isEmpty;

            return isEmpty
                ? EmptyFavoritesView(onAdd: _openPicker)
                : FavoritesListView(
                    favorites: favorites,
                    editing: _editing,
                    onToggleEdit: () => setState(() => _editing = !_editing),
                    onRemoveFav: _removeFav,
                    onOpenPicker: _openPicker,
                  );
          },
        ),
      ),
    );
  }
}
