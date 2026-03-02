// import 'dart:ui';

// import 'package:contacts_phone/app/theme.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:easy_localization/easy_localization.dart';

// import 'package:contacts_phone/features/contacts/presentation/contacts/bloc/contacts_bloc.dart';
// import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/add_contact_sheet.dart';

// void openCreateNew(BuildContext context, String digitsOnly) {
//   showGeneralDialog(
//     context: context,
//     barrierDismissible: true,
//     barrierLabel: 'create',
//     barrierColor: Colors.transparent,
//     pageBuilder: (dialogContext, _, _) {
//       return _CreateOpenDialog(
//         onCreate: () {
//           Navigator.pop(dialogContext);
//           Future.microtask(() {
//             if (!context.mounted) return;
//             showModalBottomSheet(
//               context: context,
//               isScrollControlled: true,
//               backgroundColor: Colors.transparent,
//               barrierColor: Colors.black.withAlpha(102),
//               builder: (_) => BlocProvider.value(
//                 value: context.read<ContactBloc>(),
//                 child: const AddContactSheet(),
//               ),
//             );
//           });
//         },
//       );
//     },
//     transitionBuilder: (_, a, _, child) {
//       final curved = CurvedAnimation(parent: a, curve: Curves.easeOut);
//       return FadeTransition(
//         opacity: curved,
//         child: ScaleTransition(
//           scale: Tween(begin: 0.98, end: 1.0).animate(curved),
//           child: child,
//         ),
//       );
//     },
//   );
// }

// class _CreateOpenDialog extends StatelessWidget {
//   final VoidCallback onCreate;

//   const _CreateOpenDialog({required this.onCreate});

//   @override
//   Widget build(BuildContext context) {
//     final p = AppColors.of(context);
//     final top = MediaQuery.paddingOf(context).top;

//     final cardBg = p.surface;
//     final cardBorder = p.separator;
//     final iconBg = p.surface2;
//     final iconColor = p.text;
//     final textColor = p.text;

//     return Material(
//       color: Colors.transparent,
//       child: Stack(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             behavior: HitTestBehavior.translucent,
//             child: const SizedBox.expand(),
//           ),
//           Positioned(
//             top: top + 6,
//             right: 10,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(18),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//                 child: Container(
//                   width: 280,
//                   decoration: BoxDecoration(
//                     color: cardBg,
//                     borderRadius: BorderRadius.circular(18),
//                     border: Border.all(color: cardBorder),
//                   ),
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       splashColor: Colors.transparent,
//                       highlightColor: Colors.transparent,
//                       onTap: onCreate,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 14,
//                           vertical: 12,
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 34,
//                               height: 34,
//                               decoration: BoxDecoration(
//                                 color: iconBg,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 CupertinoIcons.person_badge_plus,
//                                 color: iconColor,
//                                 size: 18,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 'create_new_contact'.tr(),
//                                 style: TextStyle(
//                                   color: textColor,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
