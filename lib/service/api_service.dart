import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:login_api/model/login_model.dart';

class ApiService {
  static const String loginUrl = 'https://dummyjson.com/auth/login';

  Future<LoginResponse> login(LoginRequest request) async {

    // Send POST request response
    final response = await http.post(
      Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      body: jsonEncode(request.toJson())
    );

    // Check status code
    if(response.statusCode == 200) {
      final Map<String,dynamic> data = jsonDecode(response.body);
      // print("Login Api Response is : $data");
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Login failed: $response.statusCode');
    }
  }

  Future<void> getProducts() async {

  }
}