import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/src/models/application_user.dart';
import 'package:farmers_market/src/models/market.dart';
import 'package:farmers_market/src/models/product.dart';
import 'package:farmers_market/src/models/vendor.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser(ApplicationUser user) {
    return _db.collection('users').doc(user.userId).set(user.toMap());
  }

  Future<ApplicationUser?> fetchUser(String userId) {
    return _db.collection('users').doc(userId).get().then((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return ApplicationUser.fromFirestore(data);
    });
  }

  Stream<List<String>> fetchUnitTypes() {
    return _db.collection('types').doc('units').snapshots().map((snapshot) {
      final data = snapshot.data();
      final list = (data?['production'] as List<dynamic>? ?? <dynamic>[])
          .map((type) => type.toString())
          .toList();
      return list;
    });
  }

  Future<void> setProduct(Product product) {
    final options = SetOptions(merge: true);
    return _db
        .collection('products')
        .doc(product.productId)
        .set(product.toMap(), options);
  }

  Future<Product?> fetchProduct(String? productId) {
    if (productId == null || productId.isEmpty) {
      return Future.value(null);
    }

    return _db.collection('products').doc(productId).get().then((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return Product.fromFirestore(data);
    });
  }

  Stream<List<Product>> fetchProductsByVendorId(String vendorId) {
    return _db
        .collection('products')
        .where('vendorId', isEqualTo: vendorId)
        .snapshots()
        .map((query) => query.docs
            .map((doc) => Product.fromFirestore(doc.data()))
            .toList());
  }

  Stream<List<Market>> fetchUpcomingMarkets() {
    return _db
        .collection('markets')
        .where('dateEnd', isGreaterThan: DateTime.now().toIso8601String())
        .snapshots()
        .map((query) =>
            query.docs.map((doc) => Market.fromFirestore(doc.data())).toList());
  }

  Stream<List<Product>> fetchAvailableProducts() {
    return _db
        .collection('products')
        .where('availableUnits', isGreaterThan: 0)
        .snapshots()
        .map((query) => query.docs
            .map((doc) => Product.fromFirestore(doc.data()))
            .toList());
  }

  Future<Vendor?> fetchVendor(String vendorId) {
    return _db.collection('vendors').doc(vendorId).get().then((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return Vendor.fromFirestore(data);
    });
  }

  Future<void> setVendor(Vendor vendor) {
    final options = SetOptions(merge: true);

    return _db
        .collection('vendors')
        .doc(vendor.vendorId)
        .set(vendor.toMap(), options);
  }
}
