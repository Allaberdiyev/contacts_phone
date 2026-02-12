import 'dart:ui';
import 'package:contacts_phone/app/theme.dart';
import 'package:flutter/material.dart';

class RecentsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int tab;
  final ValueChanged<int> onTabChanged;

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onEditTap;
  final VoidCallback onRightTap;

  RecentsHeaderDelegate({
    required this.tab,
    required this.onTabChanged,
    required this.searchController,
    required this.onSearchChanged,
    required this.onEditTap,
    required this.onRightTap,
  });

  @override
  double get maxExtent => 240;

  @override
  double get minExtent => 108;

  @override
  bool shouldRebuild(covariant RecentsHeaderDelegate oldDelegate) => true;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final p = AppColors.of(context);

    final t = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final titleOpacity = (1.0 - t * 1.5).clamp(0.0, 1.0);
    final searchOpacity = (1.0 - t * 2.0).clamp(0.0, 1.0);

    return Container(
      color: p.recentsHeaderBg,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _PillButton(text: "Edit", onTap: onEditTap),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Segmented(value: tab, onChanged: onTabChanged),
                  ),
                  const SizedBox(width: 12),
                  _CircleIconButton(
                    icon: Icons.tune_rounded,
                    onTap: onRightTap,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Opacity(
                opacity: titleOpacity,
                child: Text(
                  "Recents",
                  style: TextStyle(
                    color: p.recentsTitleColor,
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Opacity(
                opacity: searchOpacity,
                child: _SearchBar(
                  controller: searchController,
                  onChanged: onSearchChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _PillButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              decoration: BoxDecoration(
                color: p.recentsGlassBg,
                border: Border.all(color: p.recentsGlassBorder),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: p.recentsGlassText,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Material(
          color: p.recentsGlassBg,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: p.recentsGlassBorder),
              ),
              child: Icon(icon, color: p.recentsGlassIcon, size: 28),
            ),
          ),
        ),
      ),
    );
  }
}

class _Segmented extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _Segmented({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    return Container(
      height: 56,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: p.recentsSegBg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: p.recentsSegBorder),
      ),
      child: LayoutBuilder(
        builder: (_, c) {
          final w = c.maxWidth;
          return Stack(
            children: [
              Align(
                alignment: value == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: (w - 12) / 2,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: p.recentsSegThumb,
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
              Row(
                children: [
                  _segBtn(context, "All", value == 0, () => onChanged(0)),
                  _segBtn(context, "Missed", value == 1, () => onChanged(1)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _segBtn(
    BuildContext context,
    String text,
    bool selected,
    VoidCallback onTap,
  ) {
    final p = AppColors.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected
                  ? p.recentsSegTextActive
                  : p.recentsSegTextInactive,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: p.recentsSearchBg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: p.recentsSearchIcon, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                color: p.recentsSearchText,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              cursorColor: p.recentsSearchText,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  color: p.recentsSearchHint,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Icon(Icons.mic_none_rounded, color: p.recentsSearchIcon, size: 28),
        ],
      ),
    );
  }
}
