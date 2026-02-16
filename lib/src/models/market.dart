import 'package:farmers_market/src/models/location.dart';

class Market {
  final String title;
  final String dateBegin;
  final String dateEnd;
  final Location location;
  final bool acceptingOrders;
  final String marketId;

  Market({
    required this.title,
    required this.dateBegin,
    required this.dateEnd,
    required this.location,
    required this.marketId,
    this.acceptingOrders = false,
  });

  factory Market.fromFirestore(Map<String, dynamic> firestore) {
    return Market(
      title: (firestore['title'] ?? '').toString(),
      dateBegin: (firestore['dateBegin'] ?? '').toString(),
      dateEnd: (firestore['dateEnd'] ?? '').toString(),
      location: Location.fromFirestore(
        (firestore['location'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      ),
      marketId: (firestore['marketId'] ?? '').toString(),
      acceptingOrders: (firestore['acceptingOrders'] ?? false) as bool,
    );
  }
}
