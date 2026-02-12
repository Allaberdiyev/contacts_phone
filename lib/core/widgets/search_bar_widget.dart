import 'package:contacts_phone/app/theme.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback? onMic;
  final bool
  isDark; 
  final String hintText;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
    required this.isDark,
    this.onMic,
    this.hintText = 'Search',
  });

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final textMain = p.recentsSearchText;
    final pillBorder = p.recentsGlassBorder;
    final bg = p.recentsSearchBg;

    final iconMain = p.recentsSearchIcon;
    final iconMic = p.recentsSearchIcon;
    final hint = p.recentsSearchHint;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: pillBorder, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.search, color: iconMain, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(color: textMain, fontSize: 16),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: hint),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (query.isNotEmpty)
            IconButton(
              onPressed: onClear,
              icon: Icon(Icons.close, size: 20, color: iconMain),
            ),
          IconButton(
            onPressed: onMic,
            icon: Icon(Icons.mic, color: iconMic),
          ),
        ],
      ),
    );
  }
}
