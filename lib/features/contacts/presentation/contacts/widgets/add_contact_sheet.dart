import 'dart:io';

import 'package:contacts_phone/core/services/notificaxtion_service.dart';
import 'package:contacts_phone/core/utils/colors/app_colors.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/custom_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/contacts_model.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';

class AddContactSheet extends StatefulWidget {
  final ContactsModel? contact;

  const AddContactSheet({super.key, this.contact});

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

  @override
  void initState() {
    super.initState();

    if (widget.contact != null) {
      _firstNameController.text = widget.contact!.firstName;
      _lastNameController.text = widget.contact!.lastName;
      _phoneController.text = widget.contact!.phoneNumber;
    } else {
      _phoneController.text = '+998';
    }

    _phoneController.addListener(() {
      if (!_phoneController.text.startsWith('+998')) {
        _phoneController.text = '+998';
        _phoneController.selection = const TextSelection.collapsed(offset: 4);
      }
    });
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  void _onSave() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    context.read<ContactBloc>().add(
      SaveContactEvent(
        oldContact: widget.contact,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        imageFile: _selectedImage,
      ),
    );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hasImage =
        _selectedImage != null ||
        (widget.contact != null && widget.contact!.imageUrl.isNotEmpty);
    return BlocConsumer<ContactBloc, ContactState>(
      listener: (context, state) async {
        if (state is ContactSuccess) {
          final fullName =
              '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
                  .trim();

          await NotificationService.instance.showContactAdded(
            name: fullName,
            phone: _phoneController.text.trim(),
          );

          if (mounted) Navigator.pop(context);
        }

        if (state is ContactError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final loading = state is ContactLoading;

        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.6,
          maxChildSize: 0.90,
          builder: (context, scrollController) {
            return SafeArea(
              child: Stack(
                children: [
                  AbsorbPointer(
                    absorbing: loading,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: isDark
                                        ? AppColors.white
                                        : AppColors.dark,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                Text(
                                  widget.contact == null
                                      ? 'new_contact'.tr()
                                      : 'edit_contact'.tr(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.white
                                        : AppColors.dark,
                                  ),
                                ),
                                BlocBuilder<ContactBloc, ContactState>(
                                  builder: (context, state) {
                                    final loading = state is ContactLoading;
                                    return IconButton(
                                      icon: loading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Icon(
                                              Icons.check,
                                              color: isDark
                                                  ? AppColors.white
                                                  : AppColors.dark,
                                            ),
                                      onPressed: loading ? null : _onSave,
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: _pickImage,
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: _selectedImage != null
                                        ? FileImage(_selectedImage!)
                                        : (widget.contact != null &&
                                              widget
                                                  .contact!
                                                  .imageUrl
                                                  .isNotEmpty)
                                        ? NetworkImage(widget.contact!.imageUrl)
                                        : null,
                                    child:
                                        (_selectedImage == null &&
                                            (widget.contact == null ||
                                                widget
                                                    .contact!
                                                    .imageUrl
                                                    .isEmpty))
                                        ? Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
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
                                      right: 5,
                                      bottom: 0,
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isDark
                                              ? AppColors.white
                                              : AppColors.whitegrey,
                                          border: Border.all(
                                            color: AppColors.grey,
                                            width: 2.5,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: 18,
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),

                            CustomField(
                              controller: _firstNameController,
                              hintText: 'first_name'.tr(),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(25),
                              ],
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'enter_first_name'.tr()
                                  : null,
                            ),

                            CustomField(
                              controller: _lastNameController,
                              hintText: 'last_name'.tr(),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(25),
                              ],
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'enter_last_name'.tr()
                                  : null,
                            ),

                            CustomField(
                              controller: _phoneController,

                              hintText: 'phone_number'.tr(),
                              keyboardType: TextInputType.phone,

                              inputFormatters: [
                                LengthLimitingTextInputFormatter(13),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\+998\d{0,9}$'),
                                ),
                              ],
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'phone_required'.tr();
                                if (!v.startsWith('+998'))
                                  return 'phone_must_start'.tr();
                                if (v.length != 13)
                                  return 'enter_9_digits'.tr();
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
