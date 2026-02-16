class ApplicationUser {
  final String userId;
  final String email;

  ApplicationUser({required this.email, required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
    };
  }

  factory ApplicationUser.fromFirestore(Map<String, dynamic> firestore) {
    return ApplicationUser(
      userId: (firestore['userId'] ?? '').toString(),
      email: (firestore['email'] ?? '').toString(),
    );
  }
}
