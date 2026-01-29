import 'dart:io';
import 'package:contacts_phone/features/contacts/data/models/contacts_model.dart';

abstract class ContactEvent {}

class SaveContactEvent extends ContactEvent {
  final ContactsModel? oldContact;
  final String firstName;
  final String lastName;
  final String phone;
  final File? imageFile;

  SaveContactEvent({
    this.oldContact,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.imageFile,
  });
}
