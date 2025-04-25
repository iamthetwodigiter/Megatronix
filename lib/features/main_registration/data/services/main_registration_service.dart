import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:megatronix/config/config.dart';

class MainRegistrationService {
  static const String baseURL = '${Config.apiBaseURL}/mrd';

  Future<Map<String, dynamic>> mainRegistration(String email) async {
    final url = Uri.parse('$baseURL/register');
    final response = await http.post(
      url,
      body: jsonEncode({"email": email}),
      headers: {'Content-Type': 'application/json'},
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return decodedBody;
    } else if (response.statusCode == 400) {
      if (decodedBody.containsKey('validationErrors')) {
        throw Exception((decodedBody['validationErrors'] as List<dynamic>)
            .map((errors) => errors['message'])
            .join("\n"));
      }
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
