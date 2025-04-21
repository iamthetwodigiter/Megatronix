import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:megatronix/common/services/secure_storage_service.dart';
import 'package:megatronix/config/config.dart';

class ContactService {
  static const String contactBaseUrl = '${Config.apiBaseURL}/contact';
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<Map<String, dynamic>> createQuery({
    required String name,
    required String email,
    required String contact,
    required String query,
  }) async {
    final token = await _secureStorageService.readToken();

    final response = await http.post(
      Uri.parse(contactBaseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'contact': contact,
        'query': query,
      }),
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 201) {
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
    }
    throw Exception('Internal Server Error');
  }
}
