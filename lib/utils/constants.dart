import 'package:flutter/material.dart';

// App Colors
class AppColors {
  static const Color primaryColor = Color(0xFF1565C0); // Deep Blue
  static const Color secondaryColor = Color(0xFFFFC107); // Amber
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  
  // Status Colors
  static const Color upcomingColor = Color(0xFF2196F3);
  static const Color ongoingColor = Color(0xFFFF9800);
  static const Color completedColor = Color(0xFF4CAF50);
  static const Color cancelledColor = Color(0xFF9E9E9E);
}

// App Strings
class AppStrings {
  static const String appName = 'Home Services';
  static const String login = 'Login';
  static const String register = 'Register';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String name = 'Name';
  static const String home = 'Home';
  static const String upcoming = 'Upcoming';
  static const String completed = 'Completed';
  static const String profile = 'Profile';
  static const String logout = 'Logout';
  static const String selectService = 'Select a Service';
  static const String bookNow = 'Book Now';
  static const String confirmBooking = 'Confirm Booking';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String rate = 'Rate';
  static const String adminDashboard = 'Admin Dashboard';
}

// Service Types
class ServiceTypes {
  static const String cleaner = 'cleaner';
  static const String cook = 'cook';
  static const String plumber = 'plumber';
  static const String electrician = 'electrician';
  
  static const Map<String, IconData> serviceIcons = {
    cleaner: Icons.cleaning_services,
    cook: Icons.restaurant,
    plumber: Icons.plumbing,
    electrician: Icons.electrical_services,
  };
  
  static const Map<String, String> serviceNames = {
    cleaner: 'Cleaner',
    cook: 'Cook',
    plumber: 'Plumber',
    electrician: 'Electrician',
  };
}

// Booking Status
class BookingStatus {
  static const String upcoming = 'upcoming';
  static const String ongoing = 'ongoing';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
  
  static Color getStatusColor(String status) {
    switch (status) {
      case upcoming:
        return AppColors.upcomingColor;
      case ongoing:
        return AppColors.ongoingColor;
      case completed:
        return AppColors.completedColor;
      case cancelled:
        return AppColors.cancelledColor;
      default:
        return AppColors.textSecondary;
    }
  }
}

// User Roles
class UserRoles {
  static const String user = 'user';
  static const String admin = 'admin';
}

// Firestore Collections
class FirestoreCollections {
  static const String users = 'users';
  static const String providers = 'providers';
  static const String bookings = 'bookings';
}

// App Dimensions
class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
}
