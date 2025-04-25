import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:megatronix/config/config.dart';

class EventsService {
  static const String baseURL = '${Config.apiBaseURL}/events';
  static const String comboBaseURL = '${Config.apiBaseURL}/combos/domains';
  static const String posterBaseURL = '${Config.apiBaseURL}/domain-posters';

  Future<List<Map<String, dynamic>>> getAllEvents() async {
    final url = Uri.parse(baseURL);
    final response = await http.get(url);
    final List<Map<String, dynamic>> decodedBody =
        List<Map<String, dynamic>>.from(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return decodedBody;
    } else if (response.statusCode == 400) {
      throw Exception((decodedBody as Map<String, dynamic>)['message']);
    } else if (response.statusCode == 401) {
      throw Exception((decodedBody as Map<String, dynamic>)['message']);
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
      throw Exception((decodedBody as Map<String, dynamic>)['message']);
    }
  }

  Future<List<Map<String, dynamic>>> getAllEventsByDomain(String domain) async {
    final url = Uri.parse('$baseURL/domains/${domain.toUpperCase()}');
    final response = await http.get(url);

    final List<dynamic> dynamicBody = jsonDecode(response.body);
    final List<Map<String, dynamic>> decodedBody =
        dynamicBody.map((item) => item as Map<String, dynamic>).toList();
    if (response.statusCode == 200) {
      return decodedBody;
    } else if (response.statusCode == 400) {
      throw Exception((decodedBody as Map<String, dynamic>)['message']);
    } else if (response.statusCode == 401) {
      throw Exception((decodedBody as Map<String, dynamic>)['message']);
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
      throw Exception((decodedBody as Map<String, dynamic>)['message']);
    }
  }

  Future<List<Map<String, dynamic>>> getAllCombosByDomain(String domain) async {
    final url = Uri.parse('$comboBaseURL/${domain.toUpperCase()}');
    final response = await http.get(url);
    final List<dynamic> decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> comboEvents =
          decodedBody.map((item) => item as Map<String, dynamic>).toList();
      return comboEvents;
    } else if (response.statusCode == 400) {
      throw Exception((decodedBody as Map<String, dynamic>)['message']);
    } else if (response.statusCode == 401) {
      throw Exception((decodedBody as Map<String, dynamic>)['message']);
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
      throw Exception((decodedBody as Map<String, dynamic>)['message']);
    }
  }

  Future<List<Map<String, dynamic>>> getAllDomainPosters() async {
    final url = Uri.parse(posterBaseURL);
    final response = await http.get(url);
    final List<dynamic> decodedBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> domainPosters =
          decodedBody.map((item) => item as Map<String, dynamic>).toList();
      return domainPosters;
    } else if (response.statusCode == 400) {
      throw Exception((decodedBody as Map<String, dynamic>)['message']);
    } else if (response.statusCode == 401) {
      throw Exception((decodedBody as Map<String, dynamic>)['message']);
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
      throw Exception((decodedBody as Map<String, dynamic>)['message']);
    }
  }
}
