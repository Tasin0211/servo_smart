import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking_model.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/loading_indicator.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCompletedBookings();
    });
  }

  Future<void> _loadCompletedBookings() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    await bookingProvider.loadCompletedBookings(authProvider.user?.id ?? '');
  }

  Future<void> _rateBooking(BuildContext context, BookingModel booking) async {
    double rating = 3.0;

    final shouldRate = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('How was your experience with ${booking.providerName}?'),
            const SizedBox(height: AppDimensions.paddingMedium),
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: AppColors.secondaryColor,
              ),
              onRatingUpdate: (value) {
                rating = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (shouldRate != true) return;

    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final success = await bookingProvider.rateBooking(
      booking.bookingId,
      booking.providerId,
      rating,
    );

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rating submitted successfully'),
          backgroundColor: AppColors.successColor,
        ),
      );
      // Reload bookings to show the rating
      await _loadCompletedBookings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit rating'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Completed Services',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<BookingProvider>(
          builder: (context, bookingProvider, child) {
            if (bookingProvider.isLoading) {
              return const Center(
                child: LoadingIndicator(message: 'Loading completed bookings...'),
              );
            }

            final bookings = bookingProvider.completedBookings;

            if (bookings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    const Text(
                      'No completed bookings',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall),
                    const Text(
                      'Your completed services will appear here',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _loadCompletedBookings,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return _CompletedBookingCard(
                    booking: booking,
                    onRate: () => _rateBooking(context, booking),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CompletedBookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onRate;

  const _CompletedBookingCard({
    required this.booking,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    final icon = ServiceTypes.serviceIcons[booking.serviceType] ?? Icons.miscellaneous_services;

    return Card(
      elevation: AppDimensions.cardElevation,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Service Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.completedColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: AppColors.completedColor,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMedium),
                // Booking Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ServiceTypes.serviceNames[booking.serviceType] ?? booking.serviceType,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.providerName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            // Booking Details
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  Helpers.formatDate(booking.date),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${booking.hours} hour${booking.hours > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.attach_money,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Total: ${Helpers.formatCurrency(booking.totalCost)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            // Rating Section
            if (booking.rating != null) ...[
              const Divider(),
              const SizedBox(height: AppDimensions.paddingSmall),
              Row(
                children: [
                  const Text(
                    'Your Rating:',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  RatingBarIndicator(
                    rating: booking.rating!,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: AppColors.secondaryColor,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                ],
              ),
            ] else ...[
              const Divider(),
              const SizedBox(height: AppDimensions.paddingSmall),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onRate,
                  icon: const Icon(Icons.star_border),
                  label: const Text('Rate this service'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    side: const BorderSide(color: AppColors.primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
