import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_phone/features/contacts/data/models/contacts_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ContactsRepositorie {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ContactsRepositorie({FirebaseFirestore? firestore, FirebaseStorage? storage})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _storage = storage ?? FirebaseStorage.instance;

  Future<String?> uploadImage({
    required String contactId,
    required File imageFile,
  }) async {
    final ref = _storage.ref('contacts/$contactId.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<void> addContact({
    required ContactsModel contact,
    File? imageFile,
  }) async {
    String? imageUrl;

    if (imageFile != null) {
      imageUrl = await uploadImage(contactId: contact.id, imageFile: imageFile);
    }

    await _firestore.collection('contacts').doc(contact.id).set({
      'firstName': contact.firstName,
      'lastName': contact.lastName,
      'phoneNumber': contact.phoneNumber,
      'imageUrl': imageUrl ?? '',
    });
  }

  Future<void> updateContact({
    required ContactsModel contact,
    File? imageFile,
  }) async {
    String imageUrl = contact.imageUrl;

    if (imageFile != null) {
      final uploadedUrl = await uploadImage(
        contactId: contact.id,
        imageFile: imageFile,
      );

      imageUrl = uploadedUrl ?? imageUrl;
    }

    await _firestore.collection('contacts').doc(contact.id).update({
      'firstName': contact.firstName,
      'lastName': contact.lastName,
      'phoneNumber': contact.phoneNumber,
      'imageUrl': imageUrl,
    });
  }

  Future<void> deleteContact(String id) async {
    await _firestore.collection('contacts').doc(id).delete();
  }
}
