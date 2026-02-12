import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_phone/app/theme.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/avatar.dart';
import 'package:contacts_phone/features/contacts/presentation/favorites/widget/save_shared_pref_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/contacts_model.dart';

class FavoritePickerPage extends StatefulWidget {
  const FavoritePickerPage({super.key});

  @override
  State<FavoritePickerPage> createState() => _FavoritePickerPageState();
}

class _FavoritePickerPageState extends State<FavoritePickerPage> {
  final _searchCtrl = TextEditingController();
  String _q = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _match(ContactsModel c, String q) {
    final s = q.trim().toLowerCase();
    if (s.isEmpty) return true;
    final name = '${c.firstName} ${c.lastName}'.trim().toLowerCase();
    final phone = c.phoneNumber.toLowerCase();
    return name.contains(s) || phone.contains(s);
  }

  String _initials(ContactsModel c) {
    final f = c.firstName.trim();
    final l = c.lastName.trim();
    return '${f.isNotEmpty ? f[0] : ''}${l.isNotEmpty ? l[0] : ''}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final bg = p.bg;
    final pillBg = Theme.of(context).brightness == Brightness.dark
        ? p.surface2
        : p.surface;
    final pillBorder = p.keypadBorder;

    final titleColor = p.text;
    final subColor = p.text2;
    final hintColor = p.text3;
    final iconColor = p.text2;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 6),
            Text(
              'Choose a contact to add to Favorites',
              style: TextStyle(color: subColor, fontSize: 11),
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SizedBox(
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _CircleBtn(
                        icon: CupertinoIcons.back,
                        onTap: () => Navigator.pop(context, false),
                      ),
                    ),
                    Text(
                      'Contacts',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _CircleBtn(
                        icon: CupertinoIcons.xmark,
                        onTap: () => Navigator.pop(context, false),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: pillBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: pillBorder, width: 1),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(Icons.search, color: iconColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() => _q = v),
                        style: TextStyle(color: titleColor, fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: hintColor),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    if (_q.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _q = '');
                        },
                        icon: Icon(Icons.close, color: iconColor, size: 18),
                      ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.mic, color: iconColor, size: 20),
                    ),
                  ],
                ),
              ),
            ),

            // List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('contacts')
                    .orderBy('firstName')
                    .snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snap.data!.docs;
                  final list = docs
                      .map(
                        (d) => ContactsModel.fromJson(
                          d.data() as Map<String, dynamic>,
                          d.id,
                        ),
                      )
                      .where((c) => _match(c, _q))
                      .toList();

                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      thickness: 0.6,
                      color: pillBorder,
                      indent: 76,
                    ),
                    itemBuilder: (context, i) {
                      final c = list[i];
                      final name = '${c.firstName} ${c.lastName}'.trim();
                      final title = name.isEmpty ? c.phoneNumber : name;

                      return InkWell(
                        onTap: () async {
                          await SaveSharedPrefWidget.add(c.id);
                          if (!mounted) return;
                          Navigator.pop(context, true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Avatar(
                                size: 44,
                                initials: _initials(c),
                                imageUrl: c.imageUrl,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: titleColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? p.surface2 : p.surface;
    final border = p.keypadBorder;
    final iconColor = p.text2;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: border, width: 1),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }
}
