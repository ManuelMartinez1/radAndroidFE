class AuthorModel {
  String id;
  String name;
  String lastName;
  String bio;
  List<String> role;
  List<String> popularIssues;
  String nationality;
  String image;

  AuthorModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.bio,
    required this.role,
    required this.popularIssues,
    required this.nationality,
    required this.image,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['_id'],
      name: json['Name'],
      lastName: json['Last_Name'],
      bio: json['Bio'],
      role: List<String>.from(json['Role']),
      popularIssues: List<String>.from(json['Popular_Issues']),
      nationality: json['Nationality'],
      image: json['Image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Name': name,
      'Last_Name': lastName,
      'Bio': bio,
      'Role': role,
      'Popular_Issues': popularIssues,
      'Nationality': nationality,
      'Image': image,
    };
  }
}
