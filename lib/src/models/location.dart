import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  final String name;
  final String address;
  final String city;
  final String state;
  final GeoPoint? geo;
  final String? placesId;

  Location({
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    this.geo,
    this.placesId,
  });

  factory Location.fromFirestore(Map<String, dynamic> firestore) {
    return Location(
      name: (firestore['name'] ?? '').toString(),
      address: (firestore['address'] ?? '').toString(),
      city: (firestore['city'] ?? '').toString(),
      state: (firestore['state'] ?? '').toString(),
      geo: firestore['geo'] as GeoPoint?,
      placesId: firestore['placesId']?.toString(),
    );
  }
}
