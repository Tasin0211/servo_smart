import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final bool showUserName;

  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
    this.onCancel,
    this.showUserName = false,
  });

  @override
  Widget build(BuildContext context) {
    final icon = ServiceTypes.serviceIcons[booking.serviceType] ?? Icons.miscellaneous_services;
    final statusColor = BookingStatus.getStatusColor(booking.status);

    return Card(
      elevation: AppDimensions.cardElevation,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
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
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: AppColors.primaryColor,
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
                        if (showUserName) ...[
                          const SizedBox(height: 4),
                          Text(
                            'User: ${booking.userName}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      booking.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
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
              // Cancel Button
              if (onCancel != null && booking.status == BookingStatus.upcoming) ...[
                const SizedBox(height: AppDimensions.paddingMedium),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.errorColor),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                      ),
                    ),
                    child: const Text(
                      'Cancel Booking',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.errorColor,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
