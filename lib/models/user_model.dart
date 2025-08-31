
class AppUser {
  final String uid;
  final String displayName;
  final String email;
  final String? gender;
  final Map<String, dynamic>? otherDetails;
  final bool? agreedToTerms;

  AppUser({
    required this.uid,
    required this.displayName,
    required this.email,
    this.gender,
    this.otherDetails,
    this.agreedToTerms,
  });

  AppUser copyWith({
    String? displayName,
    String? gender,
    Map<String, dynamic>? otherDetails,
  }) {
    return AppUser(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email,
      gender: gender ?? this.gender,
      otherDetails: otherDetails ?? this.otherDetails,
      agreedToTerms: agreedToTerms,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'gender': gender,
      'otherDetails': otherDetails,
      'agreedToTerms': agreedToTerms,
    };
  }

  static AppUser fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      displayName: (data['displayName'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      gender: data['gender']?.toString(),
      otherDetails: (data['otherDetails'] as Map?)?.cast<String, dynamic>(),
      agreedToTerms: data['agreedToTerms'] as bool?,
    );
  }
}
