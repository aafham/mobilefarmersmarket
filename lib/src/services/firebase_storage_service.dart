import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final storage = FirebaseStorage.instance;

  Future<String> uploadProductImage(File file, String fileName) async {
    final ref = storage.ref().child('productImages/$fileName');
    final snapshot = await ref.putFile(file);
    return snapshot.ref.getDownloadURL();
  }

  Future<String> uploadVendorImage(File file, String fileName) async {
    final ref = storage.ref().child('vendorImages/$fileName');
    final snapshot = await ref.putFile(file);
    return snapshot.ref.getDownloadURL();
  }
}
