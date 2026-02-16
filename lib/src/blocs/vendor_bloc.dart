import 'dart:async';
import 'dart:io';

import 'package:farmers_market/src/models/vendor.dart';
import 'package:farmers_market/src/services/firebase_storage_service.dart';
import 'package:farmers_market/src/services/firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class VendorBloc {
  final _db = FirestoreService();
  final _name = BehaviorSubject<String>();
  final _description = BehaviorSubject<String>();
  final _imageUrl = BehaviorSubject<String>.seeded('');
  final _vendorId = BehaviorSubject<String>();
  final _vendorSaved = PublishSubject<bool>();
  final _vendor = BehaviorSubject<Vendor?>.seeded(null);
  final _isUploading = BehaviorSubject<bool>.seeded(false);

  final _picker = ImagePicker();
  final storageService = FirebaseStorageService();
  final uuid = Uuid();

  //Getters
  Future<Vendor?> fetchVendor(String userId) => _db.fetchVendor(userId);
  Stream<String> get name => _name.stream.transform(validateName);
  Stream<String> get description =>
      _description.stream.transform(validateDescription);
  Stream<String> get imageUrl => _imageUrl.stream;
  Stream<bool> get vendorSaved => _vendorSaved.stream;
  Stream<Vendor?> get vendor => _vendor.stream;
  Stream<bool> get isUploading => _isUploading.stream;
  Stream<bool> get isValid =>
      CombineLatestStream.combine2(name, description, (a, b) => true);

  //Setters
  Function(String) get changeName => _name.sink.add;
  Function(String) get changeDescription => _description.sink.add;
  Function(String) get changeImageUrl => _imageUrl.sink.add;
  Function(Vendor?) get changeVendor => _vendor.sink.add;
  Function(String) get changeVendorId => _vendorId.sink.add;

  //Dispose
  void dispose() {
    _name.close();
    _description.close();
    _imageUrl.close();
    _vendorSaved.close();
    _vendor.close();
    _vendorId.close();
    _isUploading.close();
  }

  //Validators
  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    final safeName = name.trim();
    if (safeName.length >= 3 && safeName.length <= 20) {
      sink.add(safeName);
    } else {
      if (safeName.length < 3) {
        sink.addError('3 Character Minimum');
      } else {
        sink.addError('20 Character Maximum');
      }
    }
  });

  final validateDescription = StreamTransformer<String, String>.fromHandlers(
      handleData: (description, sink) {
    final safeDescription = description.trim();
    if (safeDescription.length >= 10 && safeDescription.length <= 200) {
      sink.add(safeDescription);
    } else {
      if (safeDescription.length < 10) {
        sink.addError('10 Character Minimum');
      } else {
        sink.addError('200 Character Maximum');
      }
    }
  });

  //Save Record
  Future<void> saveVendor() async {
    try {
      final vendor = Vendor(
        description: (_description.valueOrNull ?? '').trim(),
        imageUrl: _imageUrl.valueOrNull ?? '',
        name: (_name.valueOrNull ?? '').trim(),
        vendorId: _vendorId.valueOrNull ?? '',
      );

      await _db.setVendor(vendor);
      _vendorSaved.sink.add(true);
      changeVendor(vendor);
    } catch (_) {
      _vendorSaved.sink.add(false);
    }
  }

  Future<void> pickImage() async {
    PermissionStatus permissionStatus = await Permission.photos.request();
    if (!permissionStatus.isGranted) {
      permissionStatus = await Permission.storage.request();
    }

    if (!permissionStatus.isGranted) return;

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    _isUploading.sink.add(true);
    try {
      final imageUrl =
          await storageService.uploadVendorImage(File(image.path), uuid.v4());
      changeImageUrl(imageUrl);
    } finally {
      _isUploading.sink.add(false);
    }
  }
}
