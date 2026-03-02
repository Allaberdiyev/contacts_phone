import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_phone/app/theme.dart';
import 'package:contacts_phone/core/widgets/search_bar_widget.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/contact_title.dart';
import 'package:contacts_phone/features/contacts/presentation/recents/widgets/recents_segmented_button.dart';
import 'package:easy_localization/easy_localization.dart';
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

  Widget _topRow(BuildContext context) {
    final p = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textMain = p.text;
    final pillBg = isDark ? p.surface2 : p.surface;
    final pillBorder = p.keypadBorder;

    return Padding(
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
                'edit'.tr(),
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
            leftText: "all".tr(),
            rightText: "missed".tr(),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textMain = p.text;
    final dividerColor = p.keypadBorder;

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('contacts')
              .orderBy('firstName')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _PinnedHeaderDelegate(
                      height: 60,
                      child: _topRow(context),
                    ),
                  ),
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              );
            }

            final docs = snapshot.data!.docs;

            final list = docs
                .map(
                  (d) => ContactsModel.fromJson(
                    d.data() as Map<String, dynamic>,
                    d.id,
                  ),
                )
                .where((c) => _match(c, _query))
                .toList();

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _PinnedHeaderDelegate(
                    height: 60,
                    child: _topRow(context),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget
                            .title, // 'recents'.tr() ham bo'ladi, lekin title dan oldik.
                        style: TextStyle(
                          color: textMain,
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
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
                ),

                if (docs.isEmpty || list.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'no_contacts'.tr(),
                        style: TextStyle(color: textMain),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 12),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final c = list[index];
                        final isLast = index == list.length - 1;
                        return Column(
                          children: [
                            ContactTile(contact: c),
                            if (!isLast)
                              Divider(
                                height: 1,
                                thickness: 0.6,
                                color: dividerColor,
                                indent: 76,
                                endIndent: 0,
                              ),
                          ],
                        );
                      }, childCount: list.length),
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

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  const _PinnedHeaderDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(height: height, child: child);
  }

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
