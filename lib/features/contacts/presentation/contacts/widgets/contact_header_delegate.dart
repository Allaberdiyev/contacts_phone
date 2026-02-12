import 'dart:ui';
import 'package:contacts_phone/app/theme.dart';
import 'package:contacts_phone/features/contacts/data/models/contacts_model.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/avatar.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/circle_back_buttons.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/segmented.dart';
import 'package:flutter/material.dart';

class ContactHeaderDelegate extends SliverPersistentHeaderDelegate {
  final ContactsModel contact;
  final String name;
  final String initials;
  final int segment;
  final ValueChanged<int> onSegmentChanged;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onSms;
  final VoidCallback onCall;
  final VoidCallback onVideo;
  final VoidCallback onMail;

  ContactHeaderDelegate({
    required this.contact,
    required this.name,
    required this.initials,
    required this.segment,
    required this.onSegmentChanged,
    required this.onBack,
    required this.onEdit,
    required this.onSms,
    required this.onCall,
    required this.onVideo,
    required this.onMail,
  });

  @override
  double get maxExtent => 430;

  @override
  double get minExtent => 170;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final pal = AppColors.of(context);
    final top = MediaQuery.of(context).padding.top;

    final total = maxExtent - minExtent;
    final progress = (total == 0 ? 0.0 : shrinkOffset / total).clamp(0.0, 1.0);
    final t = Curves.easeOutCubic.transform(progress);

    final iconsFade = ((progress - 0.06) / 0.22).clamp(0.0, 1.0);
    final iconsOpacity = 1.0 - Curves.easeOut.transform(iconsFade);

    final blur = lerpDouble(0, 14, t)!;

    final glassOpacity = lerpDouble(0.0, 0.20, t)!;

    final avatarSize = lerpDouble(155, 44, t)!;
    final avatarY = lerpDouble(top + 78, top + 6, t)!;

    final nameFont = lerpDouble(
      ContactDetailsTheme.title.fontSize ?? 40,
      20,
      t,
    )!;
    final nameY = lerpDouble(top + 255, top + 56, t)!;

    final iconsY = lerpDouble(top + 330, top + 96, t)!;
    final segY = lerpDouble(top + 375, top + 98, t)!;

    return Stack(
      fit: StackFit.expand,
      children: [
        const SizedBox.expand(),

        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Opacity(
              opacity: glassOpacity,
              child: Container(color: ContactDetailsTheme.glassColor),
            ),
          ),
        ),

        Positioned(
          top: top + 8,
          left: 14,
          child: CircleBackButton(onTap: onBack),
        ),
        Positioned(
          top: top + 8,
          right: 14,
          child: EditPillButton(onTap: onEdit),
        ),

        Positioned(
          top: avatarY,
          left: 0,
          right: 0,
          child: Center(
            child: Avatar(
              size: avatarSize,
              initials: initials,
              imageUrl: contact.imageUrl,
            ),
          ),
        ),

        Positioned(
          top: nameY,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: ContactDetailsTheme.title.copyWith(
                fontSize: nameFont,
                color: pal.text,
              ),
            ),
          ),
        ),

        Positioned(
          top: iconsY,
          left: 0,
          right: 0,
          child: IgnorePointer(
            ignoring: iconsOpacity < 0.05,
            child: Opacity(
              opacity: iconsOpacity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ActionIcon(icon: Icons.chat_bubble_rounded, onTap: onSms),
                  const SizedBox(width: 22),
                  _ActionIcon(icon: Icons.phone_rounded, onTap: onCall),
                  const SizedBox(width: 22),
                  _ActionIcon(icon: Icons.videocam_rounded, onTap: onVideo),
                  const SizedBox(width: 22),
                  _ActionIcon(icon: Icons.mail_rounded, onTap: onMail),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          top: segY,
          left: 0,
          right: 0,
          child: Center(
            child: Segmented(value: segment, onChanged: onSegmentChanged),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant ContactHeaderDelegate old) {
    return old.segment != segment ||
        old.name != name ||
        old.initials != initials ||
        old.contact != contact;
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final bg = ContactDetailsTheme.actionTint;
    final iconColor = p.text;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}
