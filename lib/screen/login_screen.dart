import 'package:flutter/material.dart';
import 'package:login_api/model/login_model.dart';
import 'package:login_api/screen/product_screen.dart';
import 'package:login_api/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // controller
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false, obscurePassword = true;

  String? usernameError;
  String? passwordError;

  ApiService apiService = new ApiService();

  // validation
  bool validate() {
    if (usernameController.text.isEmpty) {
      setState(() {
        usernameError = "Username is required";
      });
      return false;
    }
    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = "Password is required";
      });
      return false;
    }
    return true;
  }

  // api call
  Future<void> login() async {
    if (!validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // request
      LoginRequest loginRequest = LoginRequest(username: usernameController.text, password: passwordController.text, expiresInMins: 30,);

      // send request service
      final LoginResponse loginResponse = await apiService.login(loginRequest);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      if (!mounted) return;
      ScaffoldMessenger.of(context,).showSnackBar(SnackBar(content: Text("Login Successfull")));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductScreen()));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context,).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  InputDecoration inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      errorText: errorText,
      prefixIcon: Icon(prefixIcon, color: Colors.grey.shade700),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
        borderSide: const BorderSide(color: Color(0xFF40B983), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 17),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // username TextField
            TextField(
              controller: usernameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              // decoration: InputDecoration(labelText: "Username"),
              decoration: inputDecoration(
                hintText: 'Username',
                prefixIcon: Icons.account_circle_outlined,
                errorText: usernameError,
              ),
            ),
            SizedBox(height: 20),
            // password TextField
            TextField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: obscurePassword,
              // decoration: InputDecoration(labelText: "Password"),
              decoration: inputDecoration(
                hintText: 'Password',
                prefixIcon: Icons.lock,
                errorText: passwordError,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey.shade600,
                    size: 28,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Login button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                elevation: 5,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
              onPressed: () {
                isLoading ? null : login();
              },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
