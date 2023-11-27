class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final String? profileImage;
  final List<String> favoriteComics;
  final bool? isActive;
  final String? role;
  final String? dateOfBirth;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.profileImage,
    this.favoriteComics = const [],
    this.isActive,
    this.role,
    this.dateOfBirth,
  });

  // Method to convert a User instance to a Map. Useful for JSON serialization.
  Map<String, dynamic> toJson() => {
    '_id': id,
    'Username': username,
    'Email': email,
    'Password': password,
    'Profile_Image': profileImage,
    'Favorite_Comics': favoriteComics,
    'isActive': isActive,
    'role': role,
    'Date_of_Birth': dateOfBirth,
  };

  // Method to create a User instance from a Map. Useful for JSON deserialization.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      username: json['Username'] as String,
      email: json['Email'] as String,
      password: json['Password'] as String,
      profileImage: json['Profile_Image'] as String?,
      favoriteComics: List<String>.from(json['Favorite_Comics'] as List<dynamic>),
      isActive: json['isActive'] as bool?,
      role: json['role'] as String?,
      dateOfBirth: json['Date_of_Birth'] as String?,
    );
  }
}