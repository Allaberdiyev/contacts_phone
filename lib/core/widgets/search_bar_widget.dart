import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback? onMic;
  final bool isDark;
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
    final textMain = isDark ? Colors.white : Colors.black87;
    final pillBorder = isDark ? Colors.white24 : Colors.black26;
    final bg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);

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
          Icon(
            Icons.search,
            color: isDark ? Colors.white54 : Colors.black45,
            size: 22,
          ),
          const SizedBox(width: 8),

          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(color: textMain, fontSize: 16),
              decoration: InputDecoration(
                hintText: hintText,

                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),

          if (query.isNotEmpty)
            IconButton(
              onPressed: onClear,
              icon: Icon(
                Icons.close,
                size: 20,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),

          IconButton(
            onPressed: onMic,
            icon: Icon(
              Icons.mic,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
