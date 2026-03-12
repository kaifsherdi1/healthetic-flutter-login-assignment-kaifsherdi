import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/branded_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isFormValid = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();

    // Setup listeners for real-time validation
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // Email regex
  final _emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  void _validateForm() {
    final bool emailValid = _emailRegex.hasMatch(_emailController.text);
    final bool passwordValid = _passwordController.text.length >= 6;

    setState(() {
      _isFormValid = emailValid && passwordValid;
    });
  }

  Future<void> _handleLogin() async {
    // Only proceed if form is valid and not already loading to prevent double tap
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() => _isLoading = true);

    // Simulate login
    await Future.delayed(const Duration(seconds: 2));

    debugPrint("Login successful for ${_emailController.text}!");

    if (!context.mounted) return;

    setState(() => _isLoading = false);

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login successful! Welcome to Healthetic."),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [secondaryGreen, neutralWhite],
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),

                        // Header
                        const Text(
                          "Healthetic Lifestyle",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Welcome back!",
                          style: TextStyle(
                            fontSize: 16,
                            color: neutralGrey,
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Email Field
                        CustomTextField(
                          label: "Email",
                          placeholder: "Enter your email",
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            if (!_emailRegex.hasMatch(value)) {
                              return "Enter a valid email format";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        // Password Field
                        CustomTextField(
                          label: "Password",
                          placeholder: "Enter your password",
                          isPassword: true,
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (value.length < 6) {
                              return "Minimum 6 characters";
                            }
                            return null;
                          },
                        ),

                        // Forgot Password Link
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => debugPrint("Forgot Password tapped"),
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: neutralGrey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Login Button
                        BrandedButton(
                          text: "Login",
                          isLoading: _isLoading,
                          isDisabled: !_isFormValid,
                          onPressed: _handleLogin,
                        ),

                        const Spacer(),

                        // Sign Up Link
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: neutralGrey,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => debugPrint("Navigating to Sign Up..."),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: primaryGreen,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
