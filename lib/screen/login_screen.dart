import 'package:flutter/material.dart';
import 'package:login_api/model/login_model.dart';
import 'package:login_api/service/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // controller
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  ApiService apiService = new ApiService();

  // api call
  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    try {
      // request
      LoginRequest loginRequest = LoginRequest(username: usernameController.text, password: passwordController.text, expiresInMins: 30);

      // send request service
      final LoginResponse loginResponse = await apiService.login(loginRequest);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successfull")));

    } catch(e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),),);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // username TextField
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            SizedBox(height: 20,),
            // password TextField
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20,),
            // Login button
            ElevatedButton(onPressed: (){
              isLoading ? null : login();
            }, child: isLoading ? const CircularProgressIndicator() : Text("Login")),
          ],
        ),
      ),
    );
  }
}
