import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/contacts_model.dart';

class ContactsRepositorie {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ContactsRepositorie({FirebaseFirestore? firestore, FirebaseStorage? storage})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _storage = storage ?? FirebaseStorage.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('contacts');

  static const _offlineContactsKey = 'offline_pending_contacts';

  Stream<List<ContactsModel>> watchContacts() {
    return _col
        .orderBy('updatedAtLocal', descending: true)
        .snapshots(includeMetadataChanges: true)
        .map((snap) {
          return snap.docs.map((d) {
            final data = d.data();
            return ContactsModel(
              id: d.id,
              firstName: (data['firstName'] ?? '') as String,
              lastName: (data['lastName'] ?? '') as String,
              phoneNumber: (data['phoneNumber'] ?? '') as String,
              imageUrl: (data['imageUrl'] ?? '') as String,
            );
          }).toList();
        });
  }

  String newId() => _col.doc().id;

  Future<void> upsertContact({
    required ContactsModel contact,
    File? imageFile,
  }) async {
    final id = contact.id.isNotEmpty ? contact.id : newId();
    String imageUrl = contact.imageUrl;

    try {
      final List<ConnectivityResult> result = await Connectivity()
          .checkConnectivity();
      final isOffline = result.contains(ConnectivityResult.none);

      if (isOffline) {
        await _saveOfflineContact(
          contact: contact,
          contactId: id,
          imagePath: imageFile?.path,
        );
        return;
      }

      if (imageFile != null) {
        imageUrl = await _uploadImage(
          contactId: id,
          imageFile: imageFile,
        ).timeout(const Duration(seconds: 5));
      }

      await _saveToFirestore(
        id,
        contact,
        imageUrl,
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      await _saveOfflineContact(
        contact: contact,
        contactId: id,
        imagePath: imageFile?.path,
      );
    }
  }

  Future<void> addContact({required ContactsModel contact, File? imageFile}) =>
      upsertContact(contact: contact, imageFile: imageFile);

  Future<void> updateContact({
    required ContactsModel contact,
    File? imageFile,
  }) => upsertContact(contact: contact, imageFile: imageFile);

  Future<void> deleteContact(String id) async {
    await _col.doc(id).delete();
    try {
      await _storage.ref('contacts/$id.jpg').delete();
    } catch (_) {}
  }

  Future<String> _uploadImage({
    required String contactId,
    required File imageFile,
  }) async {
    final ref = _storage.ref('contacts/$contactId.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<void> _saveToFirestore(
    String id,
    ContactsModel contact,
    String imageUrl,
  ) async {
    await _col.doc(id).set({
      'firstName': contact.firstName,
      'lastName': contact.lastName,
      'phoneNumber': contact.phoneNumber,
      'imageUrl': imageUrl,
      'updatedAtLocal': DateTime.now().millisecondsSinceEpoch,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _saveOfflineContact({
    required ContactsModel contact,
    required String contactId,
    String? imagePath,
  }) async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList(_offlineContactsKey) ?? <String>[];

    final filtered = list.where((e) {
      final m = jsonDecode(e) as Map<String, dynamic>;
      return m['id'] != contactId;
    }).toList();

    final offlineData = {
      'id': contactId,
      'firstName': contact.firstName,
      'lastName': contact.lastName,
      'phoneNumber': contact.phoneNumber,
      'imageUrl': contact.imageUrl,
      'imagePath': imagePath,
    };

    filtered.add(jsonEncode(offlineData));
    await sp.setStringList(_offlineContactsKey, filtered);
  }

  Future<void> syncOfflineContacts() async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList(_offlineContactsKey) ?? <String>[];

    if (list.isEmpty) return;

    final keepInOffline = <String>[];

    for (final item in list) {
      try {
        final data = jsonDecode(item) as Map<String, dynamic>;
        final id = data['id'] as String;
        String imageUrl = data['imageUrl'] as String;
        final imagePath = data['imagePath'] as String?;

        if (imagePath != null) {
          final f = File(imagePath);
          if (await f.exists()) {
            imageUrl = await _uploadImage(contactId: id, imageFile: f);
          }
        }

        final contactToSync = ContactsModel(
          id: id,
          firstName: data['firstName'] ?? '',
          lastName: data['lastName'] ?? '',
          phoneNumber: data['phoneNumber'] ?? '',
          imageUrl: imageUrl,
        );

        await _saveToFirestore(id, contactToSync, imageUrl);
      } catch (e) {
        keepInOffline.add(item);
      }
    }

    await sp.setStringList(_offlineContactsKey, keepInOffline);
  }
}
