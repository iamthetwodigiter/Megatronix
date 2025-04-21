import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:megatronix/common/services/secure_storage_service.dart';
import 'package:megatronix/config/config.dart';

class ProfileService {
  static const String baseURL = '${Config.apiBaseURL}/profiles';
  static const String defaultProfile =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<Map<String, dynamic>> createProfile(String email, String contact,
      String college, String year, String department, String rollNo) async {
    final token = await _secureStorageService.readToken();
    final response = await http.post(
      Uri.parse(baseURL),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'email': email,
        'contact': contact,
        'college': college,
        'year': year,
        'department': department,
        'rollNo': rollNo,
        'profile': defaultProfile,
      }),
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return decodedBody['profileDetails'];
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
      throw Exception('Failed to create profile');
    }
  }

  Future<Map<String, dynamic>> getProfileByID(int id) async {
    final token = await _secureStorageService.readToken();
    final response = await http.get(
      Uri.parse('$baseURL/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return decodedBody['profileDetails'];
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
      throw Exception(decodedBody['message']);
    }
  }
}
