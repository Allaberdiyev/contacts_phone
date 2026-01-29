import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadContactImage(File file, String contactId) async {
    final ref = _storage.ref('contacts/$contactId.jpg');

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> deleteContactImage(String contactId) async {
    final ref = _storage.ref('contacts/$contactId.jpg');
    await ref.delete();
  }
}
