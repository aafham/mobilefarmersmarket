class Product {
  final String productName;
  final String unitType;
  final double unitPrice;
  final int availableUnits;
  final String vendorId;
  final String productId;
  final String imageUrl;
  final bool approved;
  final String note;

  Product({
    required this.approved,
    required this.availableUnits,
    this.imageUrl = '',
    this.note = '',
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.unitType,
    required this.vendorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'unitType': unitType,
      'unitPrice': unitPrice,
      'availableUnits': availableUnits,
      'approved': approved,
      'imageUrl': imageUrl,
      'note': note,
      'productId': productId,
      'vendorId': vendorId,
    };
  }

  factory Product.fromFirestore(Map<String, dynamic> firestore) {
    final unitPriceRaw = firestore['unitPrice'];
    return Product(
      productName: (firestore['productName'] ?? '').toString(),
      unitType: (firestore['unitType'] ?? '').toString(),
      unitPrice: unitPriceRaw is num ? unitPriceRaw.toDouble() : 0.0,
      availableUnits: (firestore['availableUnits'] ?? 0) as int,
      approved: (firestore['approved'] ?? false) as bool,
      imageUrl: (firestore['imageUrl'] ?? '').toString(),
      note: (firestore['note'] ?? '').toString(),
      productId: (firestore['productId'] ?? '').toString(),
      vendorId: (firestore['vendorId'] ?? '').toString(),
    );
  }
}
