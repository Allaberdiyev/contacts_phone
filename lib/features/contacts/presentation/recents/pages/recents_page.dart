import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_phone/app/theme.dart';
import 'package:contacts_phone/core/widgets/search_bar_widget.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/contact_title.dart';
import 'package:contacts_phone/features/contacts/presentation/recents/widgets/recents_segmented_button.dart';
import 'package:contacts_phone/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/contacts_model.dart';

class RecentsPage extends StatefulWidget {
  final String title;
  const RecentsPage({super.key, required this.title});

  @override
  State<RecentsPage> createState() => _RecentsPageState();
}

class _RecentsPageState extends State<RecentsPage> {
  final _searchCtrl = TextEditingController();
  final _filterBtnKey = GlobalKey();

  String _query = '';
  int _segment = 0;

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

  PopupMenuItem<String> _menuItem({
    required BuildContext context,
    required String value,
    required IconData icon,
    required String text,
  }) {
    final p = AppColors.of(context);

    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: p.text2, size: 20),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(color: p.text)),
        ],
      ),
    );
  }

  Future<void> _openTopMenu(BuildContext context) async {
    final box = _filterBtnKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero, ancestor: overlay);

    final p = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selected = await showMenu<String>(
      context: context,
      color: isDark ? p.surface2 : p.bg,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      position: RelativeRect.fromLTRB(
        pos.dx,
        pos.dy + box.size.height + 8,
        overlay.size.width - (pos.dx + box.size.width),
        overlay.size.height,
      ),
      items: [
        _menuItem(
          context: context,
          value: 'theme',
          icon: Icons.brightness_6_rounded,
          text: 'Theme',
        ),
        const PopupMenuDivider(height: 10),
        _menuItem(
          context: context,
          value: 'uz',
          icon: Icons.language_rounded,
          text: 'UZ',
        ),
        _menuItem(
          context: context,
          value: 'ru',
          icon: Icons.language_rounded,
          text: 'RU',
        ),
        _menuItem(
          context: context,
          value: 'en',
          icon: Icons.language_rounded,
          text: 'EN',
        ),
      ],
    );

    if (!mounted || selected == null) return;

    if (selected == 'theme') {
      final cur = MainApp.themeNotifier.value;
      await MainApp.setTheme(
        cur == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
      );
      return;
    }

    if (selected == 'uz') await context.setLocale(const Locale('uz'));
    if (selected == 'ru') await context.setLocale(const Locale('ru'));
    if (selected == 'en') await context.setLocale(const Locale('en'));
  }

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textMain = p.text;

    final pillBg = isDark ? p.surface2 : p.surface;
    final pillBorder = p.keypadBorder;

    final dividerColor = p.keypadBorder;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {},
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
                        'Edit',
                        style: TextStyle(
                          color: textMain,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  RecentsSegmentedButton(
                    value: _segment,
                    onChanged: (v) => setState(() => _segment = v),
                    width: 160,
                    height: 38,
                    leftText: "All",
                    rightText: "Missed",
                  ),

                  const Spacer(),

                  InkWell(
                    key: _filterBtnKey,
                    onTap: () => _openTopMenu(context),
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: pillBg,
                        shape: BoxShape.circle,
                        border: Border.all(color: pillBorder, width: 1),
                      ),
                      child: Icon(
                        CupertinoIcons.line_horizontal_3_decrease,
                        color: textMain,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recents',
                  style: TextStyle(
                    color: textMain,
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: SearchBarWidget(
                controller: _searchCtrl,
                query: _query,
                isDark: isDark,
                onChanged: (v) => setState(() => _query = v),
                onClear: () {
                  _searchCtrl.clear();
                  setState(() => _query = '');
                },
                onMic: () {},
              ),
            ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('contacts')
                    .orderBy('firstName')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return Center(
                      child: Text(
                        'no_contacts'.tr(),
                        style: TextStyle(color: textMain),
                      ),
                    );
                  }

                  final list = docs
                      .map(
                        (d) => ContactsModel.fromJson(
                          d.data() as Map<String, dynamic>,
                          d.id,
                        ),
                      )
                      .where((c) => _match(c, _query))
                      .toList();

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      thickness: 0.6,
                      color: dividerColor,
                      indent: 76,
                      endIndent: 0,
                    ),
                    itemBuilder: (context, index) =>
                        ContactTile(contact: list[index]),
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
