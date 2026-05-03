import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../controller/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final authController = Get.find<AuthController>();

  bool _obscure = true;
  bool _isLoading = false;

  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Sign up to get started",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF828282),
                ),
              ),

              const SizedBox(height: 40),

              _buildInputField(
                controller: nameController,
                hint: "Full Name",
              ),

              const SizedBox(height: 16),

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

              _buildPasswordField(),

              if (_passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _passwordError!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 10),

              _buildPasswordStrength(),

              const SizedBox(height: 24),

              _buildButton(),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text(
                  "Already have an account? Login",
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

  //  INPUT FIELD
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

  //  PASSWORD FIELD
  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: _obscure,
      onChanged: (value) {
        setState(() {
          _passwordError = _validatePassword(value);
        });
      },
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
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF828282),
          ),
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        ),
      ),
    );
  }

  //  PASSWORD STRENGTH
  Widget _buildPasswordStrength() {
    final password = passwordController.text;

    double strength = 0;

    if (password.length >= 6) strength += 0.3;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.3;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: strength,
          minHeight: 5,
          backgroundColor: Colors.grey.shade300,
          color: strength < 0.4
              ? Colors.red
              : strength < 0.7
                  ? Colors.orange
                  : Colors.green,
        ),
        const SizedBox(height: 4),
        Text(
          strength < 0.4
              ? "Weak password"
              : strength < 0.7
                  ? "Medium password"
                  : "Strong password",
          style: TextStyle(
            fontSize: 12,
            color: strength < 0.4
                ? Colors.red
                : strength < 0.7
                    ? Colors.orange
                    : Colors.green,
          ),
        )
      ],
    );
  }

  //  BUTTON
  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2F80ED),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: _isLoading ? null : _register,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Register",
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }

  //  REGISTER LOGIC
  void _register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      _emailError = _validateEmail(email);
      _passwordError = _validatePassword(password);
    });

    if (name.isEmpty ||
        _emailError != null ||
        _passwordError != null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await authController.register(email, password);
      context.go('/');
    } catch (e) {
      Get.snackbar("Error", "Registration failed");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  //  VALIDATION
  String? _validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.length < 6) return "Minimum 6 characters required";
    return null;
  }
}