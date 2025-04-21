import 'package:megatronix/config/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeamService {
  static const String teamBaseURL = '${Config.apiBaseURL}/megatronix-team';
  static const String teamPhotoBaseURL = '${Config.apiBaseURL}/team-photo';

  Future<List<Map<String, dynamic>>> getTeamMembers() async {
    final url = Uri.parse(teamBaseURL);
    final response = await http.get(url);
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final members = decodedBody['members'];
      return List<Map<String, dynamic>>.from(
        members.map(
          (item) => Map<String, dynamic>.from(item),
        ),
      );
    } else if (response.statusCode == 400) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 401) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden access. You do not have permission to perform this action.');
    } else if (response.statusCode == 429) {
      throw Exception(
          'Too Many Requests. Please wait before sending other one.');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else if (response.statusCode == 503) {
      throw Exception(
          'Service Temporarily Unavailable due to overloading or maintenance of the server.');
    } else if (response.statusCode == 504) {
      throw Exception('Gateway Timeout Error.');
    } else {
      throw Exception('Failed to load team members');
    }
  }

  Future<List<Map<String, dynamic>>> getDevelopers(
      {int page = 0, int size = 100}) async {
    final url = Uri.parse(teamBaseURL);
    final response = await http.get(url);
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final members = decodedBody['developers'];
      return List<Map<String, dynamic>>.from(
          members.map((item) => Map<String, dynamic>.from(item)));
    } else if (response.statusCode == 400) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 401) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden access. You do not have permission to perform this action.');
    } else if (response.statusCode == 429) {
      throw Exception(
          'Too Many Requests. Please wait before sending other one.');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else if (response.statusCode == 503) {
      throw Exception(
          'Service Temporarily Unavailable due to overloading or maintenance of the server.');
    } else if (response.statusCode == 504) {
      throw Exception('Gateway Timeout Error.');
    } else {
      throw Exception('Failed to load team members');
    }
  }

  Future<Map<String, dynamic>> getTeamPhoto() async {
    final devUrl = Uri.parse(teamPhotoBaseURL);
    final response = await http.get(devUrl);
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return decodedBody;
    } else if (response.statusCode == 400) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 401) {
      throw Exception(decodedBody['message']);
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden access. You do not have permission to perform this action.');
    } else if (response.statusCode == 429) {
      throw Exception(
          'Too Many Requests. Please wait before sending other one.');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else if (response.statusCode == 503) {
      throw Exception(
          'Service Temporarily Unavailable due to overloading or maintenance of the server.');
    } else if (response.statusCode == 504) {
      throw Exception('Gateway Timeout Error.');
    } else {
      throw Exception('Failed to fetch team photos');
    }
  }
}
