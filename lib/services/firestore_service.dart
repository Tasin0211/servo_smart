import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/provider_model.dart';
import '../models/booking_model.dart';
import '../utils/constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User operations
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .get();
      
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(user.id)
          .set(user.toFirestore());
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .update(data);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  // Provider operations
  Future<List<ServiceProviderModel>> getProvidersByServiceType(String serviceType) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreCollections.providers)
          .where('serviceType', isEqualTo: serviceType)
          .get();
      
      return querySnapshot.docs
          .map((doc) => ServiceProviderModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting providers: $e');
      return [];
    }
  }

  Future<ServiceProviderModel?> getProvider(String providerId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreCollections.providers)
          .doc(providerId)
          .get();
      
      if (doc.exists) {
        return ServiceProviderModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting provider: $e');
      return null;
    }
  }

  Future<void> updateProviderRating(String providerId, double newRating) async {
    try {
      final provider = await getProvider(providerId);
      if (provider == null) return;

      final currentTotal = provider.rating * provider.totalReviews;
      final newTotal = currentTotal + newRating;
      final newTotalReviews = provider.totalReviews + 1;
      final newAverageRating = newTotal / newTotalReviews;

      await _firestore
          .collection(FirestoreCollections.providers)
          .doc(providerId)
          .update({
        'rating': newAverageRating,
        'totalReviews': newTotalReviews,
      });
    } catch (e) {
      print('Error updating provider rating: $e');
      rethrow;
    }
  }

  // Booking operations
  Future<String> createBooking(BookingModel booking) async {
    try {
      final docRef = await _firestore
          .collection(FirestoreCollections.bookings)
          .add(booking.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error creating booking: $e');
      rethrow;
    }
  }

  Future<void> updateBooking(String bookingId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(FirestoreCollections.bookings)
          .doc(bookingId)
          .update(data);
    } catch (e) {
      print('Error updating booking: $e');
      rethrow;
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    try {
      await _firestore
          .collection(FirestoreCollections.bookings)
          .doc(bookingId)
          .delete();
    } catch (e) {
      print('Error deleting booking: $e');
      rethrow;
    }
  }

  Stream<List<BookingModel>> getUserBookings(String userId, List<String> statuses) {
    return _firestore
        .collection(FirestoreCollections.bookings)
        .where('userId', isEqualTo: userId)
        .where('status', whereIn: statuses)
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<BookingModel>> getAllBookings() {
    return _firestore
        .collection(FirestoreCollections.bookings)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromFirestore(doc))
            .toList());
  }

  Future<List<BookingModel>> getCompletedBookings(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreCollections.bookings)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: BookingStatus.completed)
          .orderBy('date', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting completed bookings: $e');
      return [];
    }
  }
}
