import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:client/Login/page.dart';

// const String domain = "http://127.0.0.1:5000";
const String domain = "";

Future<dynamic> httpPostRequest({
  required String route,
  required Map<String, dynamic> body,
  int successCode = 200,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.post(
      Uri.parse(domain + route),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token != null ? 'Bearer $token' : '',
      },
      body: jsonEncode(body),
    );

    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == successCode) {
      return decodedResponse;
    } else if (response.statusCode == 401) {
      developer.log("JWT token invalid $response");
      await prefs.remove("token");
      Get.offAll(() => LoginScreen());
      throw Exception(decodedResponse["detail"] ?? "Authorization error");
    } else {
      throw Exception(decodedResponse["detail"] ?? "Fetch error");
    }
  } catch (e) {
    rethrow;
  }
}
