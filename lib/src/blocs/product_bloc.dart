import 'dart:async';
import 'dart:io';

import 'package:farmers_market/src/models/product.dart';
import 'package:farmers_market/src/services/firebase_storage_service.dart';
import 'package:farmers_market/src/services/firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class ProductBloc {
  final _productName = BehaviorSubject<String>();
  final _unitType = BehaviorSubject<String?>();
  final _unitPrice = BehaviorSubject<String>();
  final _availableUnits = BehaviorSubject<String>();
  final _imageUrl = BehaviorSubject<String>.seeded('');
  final _vendorId = BehaviorSubject<String>();
  final _productSaved = PublishSubject<bool>();
  final _product = BehaviorSubject<Product?>.seeded(null);
  final _isUploading = BehaviorSubject<bool>.seeded(false);

  final db = FirestoreService();
  final uuid = Uuid();
  final _picker = ImagePicker();
  final storageService = FirebaseStorageService();

  //Get
  Stream<String> get productName =>
      _productName.stream.transform(validateProductName);
  Stream<String?> get unitType => _unitType.stream;
  Stream<double> get unitPrice =>
      _unitPrice.stream.transform(validateUnitPrice);
  Stream<int> get availableUnits =>
      _availableUnits.stream.transform(validateAvailableUnits);
  Stream<String> get imageUrl => _imageUrl.stream;
  Stream<bool> get isValid => CombineLatestStream.combine4(productName,
      unitType, unitPrice, availableUnits, (a, b, c, d) => b != null);
  Stream<List<Product>> productByVendorId(String vendorId) =>
      db.fetchProductsByVendorId(vendorId);
  Stream<bool> get productSaved => _productSaved.stream;
  Future<Product?> fetchProduct(String? productId) =>
      db.fetchProduct(productId);
  Stream<bool> get isUploading => _isUploading.stream;

  //Set
  Function(String) get changeProductName => _productName.sink.add;
  Function(String?) get changeUnitType => _unitType.sink.add;
  Function(String) get changeUnitPrice => _unitPrice.sink.add;
  Function(String) get changeAvailableUnits => _availableUnits.sink.add;
  Function(String) get changeImageUrl => _imageUrl.sink.add;
  Function(String) get changeVendorId => _vendorId.sink.add;
  Function(Product?) get changeProduct => _product.sink.add;

  void dispose() {
    _productName.close();
    _unitType.close();
    _unitPrice.close();
    _availableUnits.close();
    _vendorId.close();
    _productSaved.close();
    _product.close();
    _imageUrl.close();
    _isUploading.close();
  }

  //Functions
  Future<void> saveProduct() async {
    try {
      final currentProduct = _product.valueOrNull;
      final product = Product(
        approved: currentProduct?.approved ?? true,
        availableUnits: int.parse((_availableUnits.valueOrNull ?? '0').trim()),
        productId: currentProduct?.productId ?? uuid.v4(),
        productName: (_productName.valueOrNull ?? '').trim(),
        unitPrice: double.parse((_unitPrice.valueOrNull ?? '0').trim()),
        unitType: (_unitType.valueOrNull ?? '').trim(),
        vendorId: _vendorId.valueOrNull ?? '',
        imageUrl: _imageUrl.valueOrNull ?? '',
        note: currentProduct?.note ?? '',
      );

      await db.setProduct(product);
      _productSaved.sink.add(true);
    } catch (_) {
      _productSaved.sink.add(false);
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
      final imageUrl = await storageService.uploadProductImage(
        File(image.path),
        uuid.v4(),
      );
      changeImageUrl(imageUrl);
    } finally {
      _isUploading.sink.add(false);
    }
  }

  //Validators
  final validateUnitPrice = StreamTransformer<String, double>.fromHandlers(
      handleData: (unitPrice, sink) {
    final value = unitPrice.trim();
    if (value.isEmpty) {
      sink.addError('Must be a number');
      return;
    }

    try {
      sink.add(double.parse(value));
    } catch (_) {
      sink.addError('Must be a number');
    }
  });

  final validateAvailableUnits = StreamTransformer<String, int>.fromHandlers(
      handleData: (availableUnits, sink) {
    final value = availableUnits.trim();
    if (value.isEmpty) {
      sink.addError('Must be a whole number');
      return;
    }

    try {
      sink.add(int.parse(value));
    } catch (_) {
      sink.addError('Must be a whole number');
    }
  });

  final validateProductName = StreamTransformer<String, String>.fromHandlers(
      handleData: (productName, sink) {
    final safeName = productName.trim();
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
}
