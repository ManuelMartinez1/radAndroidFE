import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rad/models/title_model.dart';
import 'package:rad/models/volume_model.dart';
import 'package:rad/models/issue_model.dart';
import 'package:rad/models/author_model.dart';


class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});


  // ***********************TITLES**********************
  //GET ALL TITLES
  Future<List<TitlesModel>> getAllTitles() async {
    final response = await http.get(Uri.parse('$baseUrl/collections'));

    if (response.statusCode == 200) {
      return _handleResponseList(response, TitlesModel.fromJson);
    } else {
      throw Exception('Failed to load titles');
    }
  }
  //GET TITLE BY ID
  Future<TitlesModel> getTitles(String titleId) async {
    final response = await http.get(Uri.parse('$baseUrl/collections/$titleId'));

    return _handleResponse(response, TitlesModel.fromJson);
  }


  // **********************VOLUMES***************************
  //GET ALL VOLUMES
  Future<List<VolumesModel>> getAllVolumes() async {
    final response = await http.get(Uri.parse('$baseUrl/volumes'));
    return _handleResponseList(response, VolumesModel.fromJson);
  }
  //GET VOLUME BY ID
  Future<VolumesModel> getVolumes(String volumeId) async {
    final response = await http.get(Uri.parse('$baseUrl/volumes/$volumeId'));

    return _handleResponse(response, VolumesModel.fromJson);
  }

  // *************************ISSUES*************************
  //GET ISSUES
  Future<List<IssueModel>> getAllIssues() async {
    final response = await http.get(Uri.parse('$baseUrl/issues'));
    return _handleResponseList(response, IssueModel.fromJson);
  }
  //GET ISSUE BY ID
  Future<IssueModel> getIssue(String issueId) async {
    final response = await http.get(Uri.parse('$baseUrl/issues/$issueId'));

    return _handleResponse(response, IssueModel.fromJson);
  }

  //************************AUTHORS****************
  // GET AUTHOR BY ID
  Future<AuthorModel> getAuthor(String authorId) async {
    final response = await http.get(Uri.parse('$baseUrl/authors/$authorId'));
    return _handleResponse(response, AuthorModel.fromJson);
  }

  Future<List<String>> search(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/search?query=$query'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results'];
        final List<String> results = data.cast<String>().toList();
        return results;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }







  //************************************** HANDLE RESPONSES DE LISTS Y DE NORMAL LOL

  Future<T> _handleResponse<T>(http.Response response, T Function(Map<String, dynamic>) fromJson) async {
    if (response.statusCode == 200) {
      return fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future<List<T>> _handleResponseList<T>(http.Response response, T Function(Map<String, dynamic>) fromJson) async {
  if (response.statusCode == 200) {
       final List<dynamic> responseData = json.decode(response.body);
       return responseData.map((data) => fromJson(data)).toList();
     } else {
       throw Exception('Failed to load data');
     }
   }

   Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: json.encode({
        'Username' : username,
        'Password': password,
      })
    );

    if (response.statusCode== 200){
      return json.decode(response.body);
    }else {
      throw Exception('Failed to login. Status code: ${response.statusCode}');
    }
  }
  Future<void> SignUp(String? email,String? username, String? password,String? date, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'Email' : email,
        'Username': username,
        'Password': password,
        'Date_of_Birth': date,
        'accountType': role,
      })
    );
    if (response.statusCode==200 || response.statusCode ==201){
      return json.decode(response.body);
    }else{
      throw Exception('Failed to login. Status code: ${response.statusCode}');
    }
  }
  }
