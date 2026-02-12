import 'package:contacts_phone/app/theme.dart';
import 'package:contacts_phone/features/contacts/presentation/favorites/widget/favorite_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/models/contacts_model.dart';
import 'circle_button.dart';

class FavoritesListView extends StatelessWidget {
  final List<ContactsModel> favorites;
  final bool editing;
  final VoidCallback onToggleEdit;
  final void Function(String) onRemoveFav;
  final VoidCallback onOpenPicker;

  const FavoritesListView({
    super.key,
    required this.favorites,
    required this.editing,
    required this.onToggleEdit,
    required this.onRemoveFav,
    required this.onOpenPicker,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textMain = p.text;

    final pillBg = isDark ? p.surface2 : p.surface;
    final pillBorder = p.keypadBorder;

    final dividerColor = p.keypadBorder;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Row(
            children: [
              InkWell(
                onTap: onToggleEdit,
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
                    editing ? 'Done' : 'Edit',
                    style: TextStyle(
                      color: textMain,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              CircleFavButton(
                isDark: isDark, 
                onTap: onOpenPicker,
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
              return FavoriteTileItem(
                contact: c,
                isDark: isDark,
                editing: editing,
                onRemove: () => onRemoveFav(c.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
