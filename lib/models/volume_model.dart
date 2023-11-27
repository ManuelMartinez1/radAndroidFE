class VolumesModel {
  String id;
  List<String> issues;
  int volumeNumber;
  String titleName;
  List<String> genre;
  String description;
  String publishDate;
  String firstIssue;
  String lastIssue;
  String publisher;
  double rating;
  String cover;
  List<String> tags;
  bool ongoing;

  VolumesModel({
    required this.id,
    required this.issues,
    required this.volumeNumber,
    required this.titleName,
    required this.genre,
    required this.description,
    required this.publishDate,
    required this.firstIssue,
    required this.lastIssue,
    required this.publisher,
    required this.rating,
    required this.cover,
    required this.tags,
    required this.ongoing,
  });

  factory VolumesModel.fromJson(Map<String, dynamic> json) {
    return VolumesModel(
      id: json['_id'],
      issues: List<String>.from(json['Issues']),
      volumeNumber: json['Volume_Number'],
      titleName: json['Title_Name'],
      genre: List<String>.from(json['Genre']),
      description: json['Description'],
      publishDate: json['Publish_Date'],
      firstIssue: json['First_Issue'],
      lastIssue: json['Last_Issue'],
      publisher: json['Publisher'],
      rating: json['Rating'].toDouble(),
      cover: json['Cover'],
      tags: List<String>.from(json['Tags']),
      ongoing: json['Ongoing'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id':id,
      'Issues': issues,
      'Volume_Number': volumeNumber,
      'Title_Name': titleName,
      'Genre': genre,
      'Description': description,
      'Publish_Date': publishDate,
      'First_Issue': firstIssue,
      'Last_Issue': lastIssue,
      'Publisher': publisher,
      'Rating': rating,
      'Cover': cover,
      'Tags': tags,
      'Ongoing': ongoing,
    };
  }
}

