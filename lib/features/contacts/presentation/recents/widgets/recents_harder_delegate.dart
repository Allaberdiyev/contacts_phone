import 'dart:ui';
import 'package:flutter/material.dart';

class RecentsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int tab; // 0=All, 1=Missed
  final ValueChanged<int> onTabChanged;

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  final VoidCallback onEditTap;   // iOS: Edit/Done
  final VoidCallback onRightTap;  // iOS: filter/add (senda xohlagan callback)

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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final t = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    final titleOpacity = (1.0 - t * 1.5).clamp(0.0, 1.0);
    final searchOpacity = (1.0 - t * 2.0).clamp(0.0, 1.0);

    return Container(
      color: Colors.black,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // top row: Edit | segmented | right button
              Row(
                children: [
                  _PillButton(text: "Edit", onTap: onEditTap),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Segmented(
                      value: tab,
                      onChanged: onTabChanged,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _CircleIconButton(
                    icon: Icons.tune_rounded, // videodagi filterga o‘xshaydi
                    onTap: onRightTap,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // big title
              Opacity(
                opacity: titleOpacity,
                child: const Text(
                  "Recents",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // search bar
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              border: Border.all(color: Colors.white.withOpacity(0.16)),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              "Edit",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
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
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Material(
          color: Colors.white.withOpacity(0.10),
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.16)),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
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
    return Container(
      height: 56,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: LayoutBuilder(
        builder: (_, c) {
          final w = c.maxWidth;
          return Stack(
            children: [
              AnimatedAlign(
                alignment: value == 0 ? Alignment.centerLeft : Alignment.centerRight,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                child: Container(
                  width: (w - 12) / 2,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(0),
                      child: Center(
                        child: Text(
                          "All",
                          style: TextStyle(
                            color: Colors.white.withOpacity(value == 0 ? 0.95 : 0.75),
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(1),
                      child: Center(
                        child: Text(
                          "Missed",
                          style: TextStyle(
                            color: Colors.white.withOpacity(value == 1 ? 0.95 : 0.75),
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
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
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: Colors.white.withOpacity(0.75), size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 22, fontWeight: FontWeight.w600),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Icon(Icons.mic_none_rounded, color: Colors.white.withOpacity(0.75), size: 28),
        ],
      ),
    );
  }
}
