import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking_model.dart';
import '../../utils/constants.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/loading_indicator.dart';

class UpcomingScreen extends StatelessWidget {
  const UpcomingScreen({super.key});

  Future<void> _cancelBooking(BuildContext context, BookingModel booking) async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: AppColors.errorColor),
            ),
          ),
        ],
      ),
    );

    if (shouldCancel != true) return;

    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final success = await bookingProvider.cancelBooking(booking.bookingId);

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking cancelled successfully'),
          backgroundColor: AppColors.successColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to cancel booking'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.user?.id ?? '';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Upcoming Services',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: StreamBuilder<List<BookingModel>>(
          stream: Provider.of<BookingProvider>(context, listen: false)
              .getUserBookings(userId, [BookingStatus.upcoming, BookingStatus.ongoing]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingIndicator(message: 'Loading bookings...'),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 80,
                      color: AppColors.errorColor,
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final bookings = snapshot.data ?? [];

            if (bookings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 80,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    const Text(
                      'No upcoming bookings',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall),
                    const Text(
                      'Book a service to get started',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return BookingCard(
                  booking: booking,
                  onCancel: booking.status == BookingStatus.upcoming
                      ? () => _cancelBooking(context, booking)
                      : null,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
