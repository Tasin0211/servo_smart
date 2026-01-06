import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking_model.dart';
import '../../utils/constants.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/loading_indicator.dart';
import 'admin_booking_detail.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.adminDashboard,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: AppColors.errorColor),
                      ),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.signOut();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<List<BookingModel>>(
          stream: Provider.of<BookingProvider>(context, listen: false).getAllBookings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingIndicator(message: 'Loading all bookings...'),
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
                      Icons.inbox,
                      size: 80,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    const Text(
                      'No bookings yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Summary Cards
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Total',
                          count: bookings.length,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingMedium),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Upcoming',
                          count: bookings.where((b) => b.status == BookingStatus.upcoming).length,
                          color: AppColors.upcomingColor,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingMedium),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Ongoing',
                          count: bookings.where((b) => b.status == BookingStatus.ongoing).length,
                          color: AppColors.ongoingColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Bookings List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return BookingCard(
                        booking: booking,
                        showUserName: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminBookingDetail(booking: booking),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
