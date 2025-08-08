import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final uuid = const Uuid();

  Future<String> uploadProfilePhoto(File file, String uid) async {
    final ref = _storage.ref().child("profile_photos/$uid-${uuid.v4()}");
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}