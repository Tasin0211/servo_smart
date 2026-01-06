import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';
import '../models/user_model.dart';
import '../models/provider_model.dart';
import '../services/booking_service.dart';

class BookingProvider with ChangeNotifier {
  final BookingService _bookingService = BookingService();
  List<BookingModel> _upcomingBookings = [];
  List<BookingModel> _completedBookings = [];
  List<BookingModel> _allBookings = [];
  bool _isLoading = false;

  List<BookingModel> get upcomingBookings => _upcomingBookings;
  List<BookingModel> get completedBookings => _completedBookings;
  List<BookingModel> get allBookings => _allBookings;
  bool get isLoading => _isLoading;

  // Create booking
  Future<bool> createBooking({
    required UserModel user,
    required ServiceProviderModel provider,
    required DateTime date,
    required int hours,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _bookingService.createBooking(
        user: user,
        provider: provider,
        date: date,
        hours: hours,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error creating booking: $e');
      return false;
    }
  }

  // Cancel booking
  Future<bool> cancelBooking(String bookingId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _bookingService.cancelBooking(bookingId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error cancelling booking: $e');
      return false;
    }
  }

  // Mark as ongoing
  Future<bool> markAsOngoing(String bookingId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _bookingService.markAsOngoing(bookingId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error marking as ongoing: $e');
      return false;
    }
  }

  // Mark as completed
  Future<bool> markAsCompleted(String bookingId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _bookingService.markAsCompleted(bookingId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error marking as completed: $e');
      return false;
    }
  }

  // Rate booking
  Future<bool> rateBooking(String bookingId, String providerId, double rating) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _bookingService.rateBooking(bookingId, providerId, rating);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error rating booking: $e');
      return false;
    }
  }

  // Stream user bookings
  Stream<List<BookingModel>> getUserBookings(String userId, List<String> statuses) {
    return _bookingService.getUserBookings(userId, statuses);
  }

  // Stream all bookings (admin)
  Stream<List<BookingModel>> getAllBookings() {
    return _bookingService.getAllBookings();
  }

  // Load completed bookings
  Future<void> loadCompletedBookings(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _completedBookings = await _bookingService.getCompletedBookings(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error loading completed bookings: $e');
    }
  }
}
