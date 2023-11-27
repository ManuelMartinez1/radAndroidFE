class TitlesModel {
  String id;
  String name;
  List<String> volumes;
  List<String> genre;
  String description;
  String publishDate;
  double rating;
  String cover;
  List<String> tags;
  bool ongoing;
  String publisherName;

  TitlesModel({
    required this.id,
    required this.name,
    required this.volumes,
    required this.genre,
    required this.description,
    required this.publishDate,
    required this.rating,
    required this.cover,
    required this.tags,
    required this.ongoing,
    required this.publisherName,
  });

  factory TitlesModel.fromJson(Map<String, dynamic> json) {
    return TitlesModel(
      id: json['_id'],
      name: json['Name'],
      volumes: List<String>.from(json['Volumes']),
      genre: List<String>.from(json['Genre']),
      description: json['Description'],
      publishDate: json['Publish_Date'],
      rating: json['Rating'].toDouble(),
      cover: json['Cover'],
      tags: List<String>.from(json['Tags']),
      ongoing: json['Ongoing'],
      publisherName: json['Publisher_Name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id':id,
      'Name': name,
      'Volumes': volumes,
      'Genre': genre,
      'Description': description,
      'Publish_Date': publishDate,
      'Rating': rating,
      'Cover': cover,
      'Tags': tags,
      'Ongoing': ongoing,
      'Publisher_Name': publisherName,
    };
  }
}
