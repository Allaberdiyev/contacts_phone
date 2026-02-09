import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_phone/core/utils/colors/app_colors.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/pages/conatact_details_page.dart';
import 'package:contacts_phone/features/contacts/presentation/favorites/page/favorite_picker_page.dart';
import 'package:contacts_phone/features/contacts/presentation/favorites/widget/save_shared_pref_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

    /// ✅ favorit o'zgarsa avtomatik yangilanadi
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
    // ✅ listener o'zi _loadFavs() qiladi
  }

  Future<void> _openPicker() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FavoritePickerPage()),
    );

    /// Picker page true qaytarsa ham yangilaymiz
    if (changed == true) {
      await _loadFavs();
    }
  }

  Widget _circleButton({
    required bool isDark,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    final pillBg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);
    final pillBorder = isDark ? Colors.white24 : Colors.black26;
    final textMain = isDark ? Colors.white : Colors.black87;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: pillBg,
          shape: BoxShape.circle,
          border: Border.all(color: pillBorder, width: 1),
        ),
        child: Icon(icon, color: textMain, size: 22),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? AppColors.dark : Colors.white;
    final textMain = isDark ? Colors.white : Colors.black87;
    final pillBg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);
    final pillBorder = isDark ? Colors.white24 : Colors.black26;
    final dividerColor = isDark ? Colors.white12 : Colors.black12;

    return Scaffold(
      backgroundColor: bg,
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
                .map((d) => ContactsModel.fromJson(
                      d.data() as Map<String, dynamic>,
                      d.id,
                    ))
                .toList();

            final favorites = all.where((c) => _favIds.contains(c.id)).toList();
            final isEmpty = favorites.isEmpty;

            if (isEmpty) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                    child: SizedBox(
                      height: 44,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            'Favorites',
                            style: TextStyle(
                              color: textMain,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _circleButton(
                              isDark: isDark,
                              onTap: _openPicker,
                              icon: CupertinoIcons.plus,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'No Favorites',
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.black38,
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _editing = !_editing),
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: pillBg,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: pillBorder, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _editing ? 'Done' : 'Edit',
                            style: TextStyle(
                              color: textMain,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      _circleButton(
                        isDark: isDark,
                        onTap: _openPicker,
                        icon: CupertinoIcons.plus,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Favorites',
                      style: TextStyle(
                        color: textMain,
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: favorites.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      thickness: 0.6,
                      color: dividerColor,
                      indent: 76,
                    ),
                    itemBuilder: (context, index) {
                      final c = favorites[index];
                      return _FavTile(
                        contact: c,
                        isDark: isDark,
                        editing: _editing,
                        onRemove: () => _removeFav(c.id),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FavTile extends StatelessWidget {
  final ContactsModel contact;
  final bool isDark;
  final bool editing;
  final VoidCallback onRemove;

  const _FavTile({
    required this.contact,
    required this.isDark,
    required this.editing,
    required this.onRemove,
  });

  String get initials {
    final f = contact.firstName.trim();
    final l = contact.lastName.trim();
    return '${f.isNotEmpty ? f[0] : ''}${l.isNotEmpty ? l[0] : ''}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final name = '${contact.firstName} ${contact.lastName}'.trim();
    final title = name.isEmpty ? contact.phoneNumber : name;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ContactDetailsPage(contact: contact)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF75718C), Color(0xFF221E38)],
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  initials.isEmpty ? ' ' : initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.phone_fill,
                          size: 14,
                          color: isDark ? Colors.white54 : Colors.black45,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'mobile',
                          style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black45,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (editing)
                InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
                      border: Border.all(
                        color: isDark ? Colors.white12 : Colors.black12,
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      CupertinoIcons.minus,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                )
              else
                Icon(
                  CupertinoIcons.info_circle,
                  color: AppColors.blue,
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
