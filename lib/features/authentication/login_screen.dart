import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nflzoneofficial/core/services/auth_service.dart';
import 'package:nflzoneofficial/features/home/home_screen.dart';
import 'package:nflzoneofficial/features/authentication/login_screen.dart'; // Added import for navigation

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoginMode = true;
  bool _isLoading = false;
  String _statusMessage = '';
  bool _isSuccess = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _statusMessage = '';
        _isSuccess = false;
      });

      try {
        User? user;
        if (_isLoginMode) {
          user = await _auth.signInWithEmail(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
        } else {
          if (_passwordController.text != _confirmPasswordController.text) {
            throw FirebaseAuthException(
              code: 'passwords-mismatch',
              message: 'Passwords do not match',
            );
          }
          user = await _auth.signUpWithEmail(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
        }

        if (user != null && mounted) {
          setState(() {
            _isLoading = false;
            _statusMessage = _isLoginMode
                ? 'Login successful!'
                : 'Account created successfully!';
            _isSuccess = true;
          });

          await Future.delayed(const Duration(seconds: 2));

          if (mounted) {
            if (_isLoginMode) {
              // For login, go to home screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else {
              // For signup, navigate back to login screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _statusMessage = _getErrorMessage(e.code);
          _isSuccess = false;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _statusMessage = 'An unexpected error occurred';
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
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'passwords-mismatch':
        return 'Passwords do not match';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'user-disabled':
        return 'This account has been disabled';
      default:
        return 'Authentication failed. Please try again';
    }
  }

  void _switchAuthMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _statusMessage = '';
      _isSuccess = false;
    });
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
              Color(0xFF013369),
              Color(0xFF002244),
              Colors.black,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/nfl_logo.png',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _isLoginMode ? 'Welcome Back!' : 'Create Account',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isLoginMode
                        ? 'Sign in to continue'
                        : 'Join the NFL community',
                    style: const TextStyle(
                      color: Color(0xFFA5ACAF),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),

                  if (_statusMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _statusMessage,
                        style: TextStyle(
                          color: _isSuccess ? Colors.green : Color(0xFFD50A0A),
                          fontSize: 14,
                        ),
                      ),
                    ),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!_isLoginMode)
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
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        if (!_isLoginMode)
                          Column(
                            children: [
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _confirmPasswordController,
                                label: 'Confirm Password',
                                icon: Icons.lock_outline,
                                isPassword: true,
                                validator: (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD50A0A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                                : Text(
                              _isLoginMode
                                  ? 'SIGN IN'
                                  : 'CREATE ACCOUNT',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: _isLoading ? null : _switchAuthMode,
                          child: Text(
                            _isLoginMode
                                ? 'Don\'t have an account? SIGN UP'
                                : 'Already have an account? SIGN IN',
                            style: const TextStyle(
                              color: Color(0xFFA5ACAF),
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
        labelStyle: const TextStyle(color: Color(0xFFA5ACAF)),
        prefixIcon: Icon(icon, color: const Color(0xFFA5ACAF)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 16),
        errorStyle: const TextStyle(color: Color(0xFFD50A0A)),
      ),
      validator: validator,
    );
  }
}