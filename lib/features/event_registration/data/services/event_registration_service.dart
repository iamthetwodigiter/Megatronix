import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:megatronix/common/services/secure_storage_service.dart';
import 'package:megatronix/config/config.dart';

class EventRegistrationService {
  static const String baseURL = "${Config.apiBaseURL}/teams";
  static const String comboBaseURL = "${Config.apiBaseURL}/combos";

  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<Map<String, dynamic>> registerTeam(int eventID, String teamName,
      List<String> gidList, List<Map<String, dynamic>> contact) async {
    final token = await _secureStorageService.readToken();
    final url = Uri.parse('$baseURL/register');
    final response = await http.post(
      url,
      body: jsonEncode({
        "eventId": eventID,
        "teamName": teamName,
        "gidList": gidList,
        "contacts": contact
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final decodedBody = jsonDecode(response.body);
    print(decodedBody);
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
    } else {
      throw Exception(decodedBody['message']);
    }
  }

  Future<Map<String, dynamic>> registerCombo(int comboID, String teamName,
      Map<String, dynamic> gidList, List<Map<String, dynamic>> contact) async {
    final token = await _secureStorageService.readToken();
    final url = Uri.parse('$comboBaseURL/register');

    final response = await http.post(
      url,
      body: jsonEncode({
        'comboId': comboID,
        "teamName": teamName,
        "eventGidMap": gidList,
        "contacts": contact
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return decodedBody[0];
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

  Future<List<Map<String, dynamic>>> getTeamsByGID(String gid) async {
    final token = await _secureStorageService.readToken();
    final url = Uri.parse('$baseURL/gid/$gid');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final decodedBody = jsonDecode(response.body);
    print(decodedBody);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(decodedBody);
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
      throw Exception((decodedBody as Map<String, dynamic>)['message']);
    }
  }
}
