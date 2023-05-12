import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadFile(
      {required String filePath, required String fileName}) async {
    File file = File(filePath);
    final uploadPath = 'files/$fileName';
    await _firebaseStorage.ref(uploadPath).putFile(file);
    return uploadPath;
  }

  Future<String> getDownloadUrl({required partialUrl}) async {
    return await _firebaseStorage.ref().child(partialUrl).getDownloadURL();
  }
}
