import 'dart:convert';
import 'package:megatronix/config/config.dart';
import 'package:http/http.dart' as http;

class GalleryService {
  static const String baseURL = '${Config.apiBaseURL}/galleries';

  Future<List<Map<String, dynamic>>> getGalleries(
      {int page = 0, int size = 20}) async {
    final response =
        await http.get(Uri.parse('$baseURL?page=$page&size=$size'));
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          decodedBody['content'].map((e) => Map<String, dynamic>.from(e)));
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
      throw Exception('Failed to load galleries');
    }
  }
}
