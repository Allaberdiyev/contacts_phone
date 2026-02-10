import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:contacts_phone/features/contacts/presentation/contacts/bloc/contacts_bloc.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/add_contact_sheet.dart';
import 'package:contacts_phone/features/contacts/presentation/keypad/utils/phone_format.dart';

void openCreateNew(BuildContext context, String digitsOnly) {
  final preset = PhoneFormat.toUzE164FromDigits(digitsOnly);
  final bloc = context.read<ContactBloc>();

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'create',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 140),
    pageBuilder: (dialogContext, __, ___) {
      return _CreateOpenDialog(
        onCreate: () {
          Navigator.pop(dialogContext);
          Future.microtask(() {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => BlocProvider.value(
                value: bloc,
                child: AddContactSheet(presetPhone: preset),
              ),
            );
          });
        },
      );
    },
    transitionBuilder: (_, a, __, child) {
      final curved = CurvedAnimation(parent: a, curve: Curves.easeOut);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.98, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _CreateOpenDialog extends StatelessWidget {
  final VoidCallback onCreate;

  const _CreateOpenDialog({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
          Positioned(
            top: top + 6,
            right: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  width: 280,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: onCreate,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.person_badge_plus,
                                color: Colors.white.withOpacity(0.92),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Create New Contact',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.92),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
