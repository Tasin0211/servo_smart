import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/login/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/admin/admin_dashboard.dart';
import '../widgets/loading_indicator.dart';
import '../utils/constants.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Show loading while checking auth state
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: LoadingIndicator(),
        ),
      );
    }

    // Show login screen if not authenticated
    if (!authProvider.isAuthenticated) {
      return const LoginScreen();
    }

    // Route based on user role
    if (authProvider.user?.role == UserRoles.admin) {
      return const AdminDashboard();
    } else {
      return const HomeScreen();
    }
  }
}
