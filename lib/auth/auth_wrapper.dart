import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/login/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/admin/admin_dashboard.dart';
import '../widgets/loading_indicator.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    logger.d(
      '🔍 AuthWrapper build - isLoading: ${authProvider.isLoading}, isAuthenticated: ${authProvider.isAuthenticated}, user: ${authProvider.user?.email ?? "null"}, role: ${authProvider.user?.role ?? "null"}',
    );

    // Show loading while checking auth state
    if (authProvider.isLoading) {
      logger.d('⏳ Showing loading screen');
      return const Scaffold(body: Center(child: LoadingIndicator()));
    }

    // Show login screen if not authenticated
    if (!authProvider.isAuthenticated) {
      logger.d('🔓 Not authenticated, showing LoginScreen');
      return const LoginScreen();
    }

    // Route based on user role
    if (authProvider.user?.role == UserRoles.admin) {
      logger.i('👑 Admin user detected, navigating to AdminDashboard');
      return const AdminDashboard();
    } else {
      logger.i('👤 Regular user detected, navigating to HomeScreen');
      return const HomeScreen();
    }
  }
}
