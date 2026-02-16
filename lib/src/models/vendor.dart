class Vendor {
  final String vendorId;
  final String name;
  final String imageUrl;
  final String description;

  Vendor({
    this.imageUrl = '',
    this.name = '',
    this.vendorId = '',
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'vendorId': vendorId,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  factory Vendor.fromFirestore(Map<String, dynamic>? firestore) {
    final data = firestore ?? <String, dynamic>{};
    return Vendor(
      vendorId: data['vendorId'] ?? '',
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
