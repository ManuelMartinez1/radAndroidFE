class IssueModel {
  String id;
  String volumeNumber;
  int issueNumber;
  String title;
  String issueName;
  String publishDate;
  List<String> authors;
  List<String> genre;
  String description;
  String publisher;
  double rating;
  String cover;
  List<String> tags;
  bool free;

  IssueModel({
    required this.id,
    required this.volumeNumber,
    required this.issueNumber,
    required this.title,
    required this.issueName,
    required this.publishDate,
    required this.authors,
    required this.genre,
    required this.description,
    required this.publisher,
    required this.rating,
    required this.cover,
    required this.tags,
    required this.free,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['_id'],
      volumeNumber: json['Volume_Number'],
      issueNumber: json['Issue_Number'],
      title: json['Title_Name'],
      issueName: json['Issue_Name'],
      publishDate: json['Publish_Date'],
      authors: List<String>.from(json['Authors']),
      genre: List<String>.from(json['Genre']),
      description: json['Description'],
      publisher: json['Publisher'],
      rating: json['Rating'].toDouble(),
      cover: json['Cover'],
      tags: List<String>.from(json['Tags']),
      free: json['Free'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id':id,
      'Volume_Number': volumeNumber,
      'Issue_Number': issueNumber,
      'Title_Name': title,
      'Issue_Name': issueName,
      'Publish_Date': publishDate,
      'Authors': authors,
      'Genre': genre,
      'Description': description,
      'Publisher': publisher,
      'Rating': rating,
      'Cover': cover,
      'Tags': tags,
      'Free': free,
    };
  }
}
