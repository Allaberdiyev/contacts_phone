import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contacts_phone/app/theme.dart';
import 'package:contacts_phone/features/contacts/presentation/favorites/widget/circle_button.dart';

class EmptyFavoritesView extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyFavoritesView({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    color: p.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: CircleFavButton(
                    isDark: isDark, 
                    onTap: onAdd,
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
                color: p.text3,
                fontSize: 34,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
