import 'dart:io';
import 'dart:ui';

import 'package:contacts_phone/app/theme.dart';
import 'package:contacts_phone/core/services/notificaxtion_service.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/custom_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/contacts_model.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';

class AddContactSheet extends StatefulWidget {
  final ContactsModel? contact;
  final String? presetPhone;

  const AddContactSheet({super.key, this.contact, this.presetPhone});

  @override
  State<AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<AddContactSheet> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _picker = ImagePicker();
  File? _selectedImage;

  bool _fixingPhone = false;

  late final String _initialFirst;
  late final String _initialLast;
  late final String _initialPhone;
  late final bool _initialHasImage;

  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+998 ## ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  String _digitsOnly(String input) => input.replaceAll(RegExp(r'\D'), '');

  String _normalizeUzPhone(String input) {
    final d = _digitsOnly(input);
    if (d.isEmpty) return '+998 ';
    if (d.startsWith('998')) {
      final tail = d.substring(3);
      final last9 = tail.length >= 9 ? tail.substring(tail.length - 9) : tail;
      return '+998 $last9';
    }
    final last9 = d.length >= 9 ? d.substring(d.length - 9) : d;
    return '+998 $last9';
  }

  void _setPhoneText(String value) {
    _fixingPhone = true;
    _phoneController.text = value;
    _phoneController.selection = TextSelection.collapsed(offset: value.length);
    _fixingPhone = false;
  }

  bool _isDirty() {
    final f = _firstNameController.text.trim();
    final l = _lastNameController.text.trim();
    final ph = _phoneController.text.trim();

    final hasNewImage = _selectedImage != null;
    final hasImageNow =
        hasNewImage || (widget.contact?.imageUrl.isNotEmpty ?? false);

    return f != _initialFirst ||
        l != _initialLast ||
        ph != _initialPhone ||
        hasNewImage ||
        hasImageNow != _initialHasImage;
  }

  @override
  void initState() {
    super.initState();

    if (widget.contact != null) {
      _firstNameController.text = widget.contact!.firstName;
      _lastNameController.text = widget.contact!.lastName;
      final formatted = _phoneMaskFormatter.maskText(
        widget.contact!.phoneNumber,
      );
      _phoneController.text = formatted;
    } else {
      final p = widget.presetPhone?.trim() ?? '';
      _phoneController.text = p.isNotEmpty
          ? _phoneMaskFormatter.maskText(_normalizeUzPhone(p))
          : '+998 ';
    }

    _initialFirst = _firstNameController.text.trim();
    _initialLast = _lastNameController.text.trim();
    _initialPhone = _phoneController.text.trim();
    _initialHasImage = widget.contact?.imageUrl.isNotEmpty ?? false;

    _phoneController.addListener(() {
      if (_fixingPhone) return;

      final t = _phoneController.text;

      if (!t.startsWith('+998 ')) {
        _setPhoneText('+998 ');
      }
    });
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _selectedImage = File(picked.path));
  }

  void _onSave() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final rawPhone = _phoneController.text.replaceAll(' ', '');

    context.read<ContactBloc>().add(
      SaveContactEvent(
        oldContact: widget.contact,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: rawPhone,
        imageFile: _selectedImage,
      ),
    );
  }

  Future<bool> _confirmCloseIfDirty() async {
    FocusScope.of(context).unfocus();

    if (!_isDirty()) return true;

    final res = await showDialog<_CloseAction>(
      context: context,
      builder: (ctx) {
        final p = AppColors.of(ctx);
        return AlertDialog(
          backgroundColor: p.surface,
          surfaceTintColor: Colors.transparent,
          title: Text('save_changes'.tr(), style: TextStyle(color: p.text)),
          content: Text(
            'save_changes_desc'.tr(),
            style: TextStyle(color: p.text2),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, _CloseAction.cancel),
              child: Text('cancel'.tr(), style: TextStyle(color: p.primary)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, _CloseAction.discard),
              child: Text('discard'.tr(), style: TextStyle(color: p.danger)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, _CloseAction.save),
              child: Text('save'.tr(), style: TextStyle(color: p.primary)),
            ),
          ],
        );
      },
    );

    if (res == _CloseAction.discard) return true;

    if (res == _CloseAction.save) {
      _onSave();
      return false;
    }

    return false;
  }

  Future<void> _handleClose() async {
    final ok = await _confirmCloseIfDirty();
    if (ok && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final hasImage =
        _selectedImage != null ||
        (widget.contact != null && widget.contact!.imageUrl.isNotEmpty);

    return PopScope(
      canPop: !_isDirty(),
      onPopInvokedWithResult: (didPop, dynamic result) async {
        if (didPop) return;

        final ok = await _confirmCloseIfDirty();
        if (ok && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: BlocConsumer<ContactBloc, ContactState>(
        listener: (context, state) async {
          if (state is ContactSuccess) {
            final fullName =
                '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
                    .trim();

            final prefs = await SharedPreferences.getInstance();
            final isNotificationEnabled =
                prefs.getBool('notifications_enabled') ?? true;

            if (isNotificationEnabled) {
              await NotificationService.instance.showContactAdded(
                name: fullName,
                phone: _phoneController.text.replaceAll(' ', '').trim(),
              );
            }

            if (context.mounted) Navigator.pop(context);
          }

          if (state is ContactError) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final loading = state is ContactLoading;

          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.90,
            minChildSize: 0.60,
            maxChildSize: 0.90,
            builder: (context, scrollController) {
              final bottomInset = MediaQuery.of(context).viewInsets.bottom;

              return AnimatedPadding(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: bottomInset),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Material(
                      color: p.surface,
                      child: AbsorbPointer(
                        absorbing: loading,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: p.separator.withAlpha(178),
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                            const SizedBox(height: 8),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _GlassActionIcon(
                                    icon: Icons.close,
                                    onTap: _handleClose,
                                  ),
                                  Text(
                                    widget.contact == null
                                        ? 'new_contact'.tr()
                                        : 'edit_contact'.tr(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: p.text,
                                    ),
                                  ),
                                  _GlassActionIcon(
                                    icon: Icons.check,
                                    onTap: loading ? null : _onSave,
                                    trailing: loading
                                        ? SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: p.primary,
                                            ),
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 12),

                                        GestureDetector(
                                          onTap: _pickImage,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            clipBehavior: Clip.none,
                                            children: [
                                              CircleAvatar(
                                                radius: 52,
                                                backgroundColor: p.surface2,
                                                backgroundImage:
                                                    _selectedImage != null
                                                    ? FileImage(_selectedImage!)
                                                    : (widget.contact != null &&
                                                          widget
                                                              .contact!
                                                              .imageUrl
                                                              .isNotEmpty)
                                                    ? NetworkImage(
                                                        widget
                                                            .contact!
                                                            .imageUrl,
                                                      )
                                                    : null,
                                                child:
                                                    (_selectedImage == null &&
                                                        (widget.contact ==
                                                                null ||
                                                            widget
                                                                .contact!
                                                                .imageUrl
                                                                .isEmpty))
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                52,
                                                              ),
                                                          image: const DecorationImage(
                                                            image: AssetImage(
                                                              "assets/pictures/white_person_icon.png",
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                              if (!hasImage)
                                                Positioned(
                                                  right: 6,
                                                  bottom: 0,
                                                  child: Container(
                                                    width: 28,
                                                    height: 28,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: p.sheetAddBadgeBg,
                                                      border: Border.all(
                                                        color: p
                                                            .sheetAddBadgeBorder,
                                                        width: 2.5,
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 18,
                                                      color:
                                                          p.sheetAddBadgeIcon,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 26),

                                        CustomField(
                                          controller: _firstNameController,
                                          hintText: 'first_name'.tr(),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                              25,
                                            ),
                                          ],
                                          validator: (v) => null,
                                        ),

                                        CustomField(
                                          controller: _lastNameController,
                                          hintText: 'last_name'.tr(),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                              25,
                                            ),
                                          ],
                                          validator: (v) => null,
                                        ),

                                        CustomField(
                                          controller: _phoneController,
                                          hintText: 'phone_number'.tr(),
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: [
                                            _phoneMaskFormatter,
                                          ],
                                          validator: (v) {
                                            if (v == null || v.isEmpty) {
                                              return null;
                                            }
                                            if (!v.startsWith('+998 ')) {
                                              return null;
                                            }
                                            if (v.length != 17) return "";
                                            return null;
                                          },
                                        ),

                                        const SizedBox(height: 24),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

enum _CloseAction { cancel, discard, save }

class _GlassActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _GlassActionIcon({
    required this.icon,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final enabled = onTap != null;

    final disabledTopAlpha = ((isDark ? 0.55 : 0.70) * 255).toInt();
    final disabledBottomAlpha = ((isDark ? 0.45 : 0.60) * 255).toInt();
    final borderAlpha = ((isDark ? 0.55 : 0.25) * 255).toInt();

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 44,
        height: 44,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: enabled
                      ? [p.navGlassTop, p.navGlassBottom]
                      : [
                          p.navGlassTop.withAlpha(disabledTopAlpha),
                          p.navGlassBottom.withAlpha(disabledBottomAlpha),
                        ],
                ),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: p.navBorder.withAlpha(borderAlpha),
                  width: 1,
                ),
              ),
              child: Center(
                child:
                    trailing ??
                    Icon(icon, size: 22, color: enabled ? p.text : p.text3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
