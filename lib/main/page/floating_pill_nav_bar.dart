import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:contacts_phone/app/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class FloatingPillNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const FloatingPillNavBar({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  State<FloatingPillNavBar> createState() => _FloatingPillNavBarState();
}

class _FloatingPillNavBarState extends State<FloatingPillNavBar>
    with SingleTickerProviderStateMixin {
  static const _h = 68.0;
  static const _pad = 6.0;

  List<_NavItem> get _items => [
    _NavItem(Icons.star, "favorites".tr()),
    _NavItem(Icons.access_time_filled_sharp, "recents".tr()),
    _NavItem(Icons.account_circle_rounded, "contacts".tr()),
    _NavItem(Icons.dialpad, "keypad".tr()),
    _NavItem(Icons.settings, "settings".tr()),
  ];

  late final AnimationController _ac;
  Animation<double>? _anim;

  double _t = 0;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _t = widget.currentIndex.toDouble();
    _ac =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 220),
        )..addListener(() {
          if (_anim != null) setState(() => _t = _anim!.value);
        });
  }

  @override
  void didUpdateWidget(covariant FloatingPillNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_dragging) return;

    final target = widget.currentIndex.toDouble();
    if ((target - _t).abs() > 0.001) _animateTo(target);
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    _ac.stop();
    _anim = Tween<double>(
      begin: _t,
      end: target,
    ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));
    _ac.forward(from: 0);
  }

  void _snap() {
    final idx = _t.round().clamp(0, _items.length - 1);
    _animateTo(idx.toDouble());
    if (idx != widget.currentIndex) widget.onChanged(idx);
  }

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final currentItems = _items;

    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
            child: LayoutBuilder(
              builder: (context, c) {
                final n = currentItems.length;
                final innerW = c.maxWidth - _pad * 2;
                final slotW = innerW / n;

                final t = _t.clamp(0.0, (n - 1).toDouble());
                final thumbLeft = slotW * t;

                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: (_) {
                    _dragging = true;
                    _ac.stop();
                  },
                  onPanUpdate: (d) {
                    final x = (d.localPosition.dx - _pad).clamp(0.0, innerW);
                    setState(() => _t = x / slotW);
                  },
                  onPanEnd: (_) {
                    _dragging = false;
                    _snap();
                  },
                  onPanCancel: () {
                    _dragging = false;
                    _snap();
                  },
                  child: Container(
                    height: _h,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [p.navGlassTop, p.navGlassBottom],
                      ),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: p.navBorder, width: 1),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 60,
                          offset: const Offset(0, 16),
                          color: p.navShadow,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: thumbLeft,
                          top: 0,
                          bottom: 0,
                          width: slotW,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: p.navThumb,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: p.navThumbBorder,
                                width: 0.8,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: List.generate(n, (i) {
                            final item = currentItems[i];

                            final dist = (t - i).abs().clamp(0.0, 1.0);
                            final sel = 1.0 - dist;

                            final iconColor = Color.lerp(
                              p.navIconUnselected,
                              p.primary,
                              sel,
                            )!;
                            final textColor = Color.lerp(
                              p.navTextUnselected,
                              p.primary,
                              sel,
                            )!;

                            return Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                splashColor: p.navSplash,
                                highlightColor: p.navHighlight,
                                onTap: () => widget.onChanged(i),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        item.icon,
                                        size: 26,
                                        color: iconColor,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.0,
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
