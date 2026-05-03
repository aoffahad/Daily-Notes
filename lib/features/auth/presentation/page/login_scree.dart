import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../controller/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final authController = Get.find<AuthController>();

  bool _obscure = true;
  bool _isLoading = false;

  String? _emailError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ FIX overflow
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( // ✅ FIX overflow
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Login to continue",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF828282),
                ),
              ),

              const SizedBox(height: 40),

              // 🔹 Email
              _buildInputField(
                controller: emailController,
                hint: "Email",
                errorText: _emailError,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    _emailError = _validateEmail(value);
                  });
                },
              ),

              const SizedBox(height: 16),

              // 🔹 Password
              TextField(
                controller: passwordController,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: "Password",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF828282),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure; // ✅ FIX
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F80ED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 Register Redirect
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text(
                  "Don't have an account? Register",
                  style: TextStyle(color: Color(0xFF2F80ED)),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable Input
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    String? errorText,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // 🔹 Login Logic
  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      _emailError = _validateEmail(email);
    });

    if (_emailError != null || password.isEmpty) {
      Get.snackbar("Error", "Enter valid credentials");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await authController.login(email, password);

      context.go('/'); // router decides next
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        "Invalid email or password",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 🔹 Email Validation
  String? _validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Enter a valid email";
    }
    return null;
  }
}