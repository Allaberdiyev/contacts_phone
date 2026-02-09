import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_phone/core/utils/colors/app_colors.dart';
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
    final s = '${f.isNotEmpty ? f[0] : ''}${l.isNotEmpty ? l[0] : ''}'
        .toUpperCase();
    return s.isEmpty ? ' ' : s;
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.dark;
    const pillBg = Color(0xFF1C1C1E);
    const pillBorder = Colors.white24;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 6),
            const Text(
              'Choose a contact to add to Favorites',
              style: TextStyle(color: Colors.white54, fontSize: 11),
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
                        bg: pillBg,
                        border: pillBorder,
                        icon: CupertinoIcons.back,
                        onTap: () => Navigator.pop(context, false),
                      ),
                    ),
                    const Text(
                      'Contacts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _CircleBtn(
                        bg: pillBg,
                        border: pillBorder,
                        icon: CupertinoIcons.xmark,
                        onTap: () => Navigator.pop(context, false),
                      ),
                    ),
                  ],
                ),
              ),
            ),

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
                    const Icon(Icons.search, color: Colors.white54, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() => _q = v),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white38),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    if (_q.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _q = '');
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white54,
                          size: 18,
                        ),
                      ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.mic,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),

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
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      thickness: 0.6,
                      color: Colors.white12,
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
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF75718C),
                                      Color(0xFF221E38),
                                    ],
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _initials(c),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
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
  final Color bg;
  final Color border;
  final IconData icon;
  final VoidCallback onTap;

  const _CircleBtn({
    required this.bg,
    required this.border,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
        child: Icon(icon, color: Colors.white70, size: 18),
      ),
    );
  }
}
