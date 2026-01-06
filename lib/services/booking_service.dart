import '../models/booking_model.dart';
import '../models/user_model.dart';
import '../models/provider_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'firestore_service.dart';

class BookingService {
  final FirestoreService _firestoreService = FirestoreService();

  // Create a new booking
  Future<String> createBooking({
    required UserModel user,
    required ServiceProviderModel provider,
    required DateTime date,
    required int hours,
  }) async {
    try {
      final totalCost = Helpers.calculateTotalCost(hours, provider.hourlyRate);
      
      final booking = BookingModel(
        bookingId: '', // Will be set by Firestore
        userId: user.id,
        userName: user.name,
        serviceType: provider.serviceType,
        providerId: provider.providerId,
        providerName: provider.name,
        date: date,
        hours: hours,
        hourlyRate: provider.hourlyRate,
        totalCost: totalCost,
        status: BookingStatus.upcoming,
        createdAt: DateTime.now(),
      );

      return await _firestoreService.createBooking(booking);
    } catch (e) {
      print('Error in createBooking: $e');
      rethrow;
    }
  }

  // Cancel a booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _firestoreService.updateBooking(bookingId, {
        'status': BookingStatus.cancelled,
      });
    } catch (e) {
      print('Error in cancelBooking: $e');
      rethrow;
    }
  }

  // Mark booking as ongoing
  Future<void> markAsOngoing(String bookingId) async {
    try {
      await _firestoreService.updateBooking(bookingId, {
        'status': BookingStatus.ongoing,
      });
    } catch (e) {
      print('Error in markAsOngoing: $e');
      rethrow;
    }
  }

  // Mark booking as completed
  Future<void> markAsCompleted(String bookingId) async {
    try {
      await _firestoreService.updateBooking(bookingId, {
        'status': BookingStatus.completed,
      });
    } catch (e) {
      print('Error in markAsCompleted: $e');
      rethrow;
    }
  }

  // Rate a booking
  Future<void> rateBooking(String bookingId, String providerId, double rating) async {
    try {
      // Update booking with rating
      await _firestoreService.updateBooking(bookingId, {
        'rating': rating,
      });

      // Update provider's average rating
      await _firestoreService.updateProviderRating(providerId, rating);
    } catch (e) {
      print('Error in rateBooking: $e');
      rethrow;
    }
  }

  // Get user bookings by status
  Stream<List<BookingModel>> getUserBookings(String userId, List<String> statuses) {
    return _firestoreService.getUserBookings(userId, statuses);
  }

  // Get all bookings (for admin)
  Stream<List<BookingModel>> getAllBookings() {
    return _firestoreService.getAllBookings();
  }

  // Get completed bookings
  Future<List<BookingModel>> getCompletedBookings(String userId) async {
    return await _firestoreService.getCompletedBookings(userId);
  }
}
