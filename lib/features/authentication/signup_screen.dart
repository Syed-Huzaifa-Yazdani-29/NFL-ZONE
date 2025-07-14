import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nflzoneofficial/core/services/auth_service.dart';
import 'package:nflzoneofficial/core/constants/app_colors.dart';
import 'package:nflzoneofficial/features/authentication/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _statusMessage = '';
  bool _isSuccess = false;
  bool _showSuccessState = false;

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _statusMessage = '';
        _isSuccess = false;
        _showSuccessState = false;
      });

      try {
        if (_passwordController.text != _confirmPasswordController.text) {
          throw FirebaseAuthException(
            code: 'passwords-mismatch',
            message: 'Passwords do not match',
          );
        }

        final user = await _auth.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (user != null && mounted) {
          setState(() {
            _isLoading = false;
            _statusMessage = 'Account created successfully!';
            _isSuccess = true;
            _showSuccessState = true;
          });

          // Clear input fields
          _emailController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
          _nameController.clear();

          // Navigate to login after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _statusMessage = _getErrorMessage(e.code);
          _isSuccess = false;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _statusMessage = 'An error occurred. Please try again.';
          _isSuccess = false;
          _isLoading = false;
        });
      }
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password should be at least 6 characters';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'invalid-email':
        return 'Please enter a valid email';
      case 'passwords-mismatch':
        return 'Passwords do not match';
      default:
        return 'Registration failed. Please try again';
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.nflBlue,
              AppColors.nflDarkBlue,
              Colors.black,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // NFL Logo
                Image.asset(
                  'assets/images/nfl_logo.png',
                  width: 120,
                  height: 120,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.sports_football,
                    size: 120,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  _showSuccessState ? 'Success!' : 'Create Account',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _showSuccessState
                      ? 'Your account is ready to use'
                      : 'Join the NFL community',
                  style: const TextStyle(
                    color: AppColors.nflSilver,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),

                // Status Message
                if (_statusMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _statusMessage,
                      style: TextStyle(
                        color: _isSuccess ? Colors.green : AppColors.nflRed,
                        fontSize: 14,
                      ),
                    ),
                  ),

                // Show either the form or success content
                _showSuccessState
                    ? _buildSuccessContent()
                    : _buildSignUpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Full Name Field
          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email Field
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password Field
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be 6+ characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm Password Field
          _buildTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            icon: Icons.lock_reset,
            isPassword: true,
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Sign Up Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.nflRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              )
                  : const Text(
                'CREATE ACCOUNT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Already have account
          TextButton(
            onPressed: _isLoading ? null : _navigateToLogin,
            child: const Text(
              'Already have an account? Sign In',
              style: TextStyle(
                color: AppColors.nflSilver,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 100,
        ),
        const SizedBox(height: 24),
        const Text(
          'Account created successfully!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'You will be redirected to login shortly',
          style: TextStyle(
            color: AppColors.nflSilver,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _navigateToLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.nflRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
            ),
            child: const Text(
              'SIGN IN NOW',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.nflSilver),
        prefixIcon: Icon(icon, color: AppColors.nflSilver),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        errorStyle: const TextStyle(color: AppColors.nflRed),
      ),
      validator: validator,
    );
  }
}