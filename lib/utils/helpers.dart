import 'package:intl/intl.dart';

class Helpers {
  // Format currency
  static String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }
  
  // Format date
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  // Format date with time
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }
  
  // Format time
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
  
  // Validate email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  
  // Calculate total cost
  static double calculateTotalCost(int hours, double hourlyRate) {
    return hours * hourlyRate;
  }
  
  // Get greeting based on time
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
  
  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
