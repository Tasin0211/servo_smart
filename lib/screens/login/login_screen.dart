import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      bool success;
      if (_isLogin) {
        success = await authProvider.signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        success = await authProvider.register(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
        );
      }

      if (!mounted) return;

      if (!success) {
        _showError('Authentication failed. Please try again.');
      }
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo/Icon
                  Icon(
                    Icons.home_repair_service,
                    size: 80,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  // App Title
                  const Text(
                    AppStrings.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  // Login/Register Toggle
                  Text(
                    _isLogin ? 'Welcome Back' : 'Create Account',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  // Name Field (only for registration)
                  if (!_isLogin)
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: AppStrings.name,
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                        ),
                        filled: true,
                        fillColor: AppColors.cardColor,
                      ),
                      validator: (value) {
                        if (!_isLogin && (value == null || value.isEmpty)) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  if (!_isLogin) const SizedBox(height: AppDimensions.paddingMedium),
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: AppStrings.email,
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                      ),
                      filled: true,
                      fillColor: AppColors.cardColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!Helpers.isValidEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: AppStrings.password,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                      ),
                      filled: true,
                      fillColor: AppColors.cardColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  // Submit Button
                  CustomButton(
                    text: _isLogin ? AppStrings.login : AppStrings.register,
                    onPressed: _submit,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  // Toggle Login/Register
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin
                          ? "Don't have an account? Register"
                          : 'Already have an account? Login',
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
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
}
