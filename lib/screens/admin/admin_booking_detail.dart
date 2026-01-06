import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';

class AdminBookingDetail extends StatefulWidget {
  final BookingModel booking;

  const AdminBookingDetail({
    super.key,
    required this.booking,
  });

  @override
  State<AdminBookingDetail> createState() => _AdminBookingDetailState();
}

class _AdminBookingDetailState extends State<AdminBookingDetail> {
  bool _isLoading = false;

  Future<void> _updateStatus(String newStatus, String actionName) async {
    final shouldUpdate = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(actionName),
        content: Text('Are you sure you want to $actionName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (shouldUpdate != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
      bool success = false;

      switch (newStatus) {
        case BookingStatus.ongoing:
          success = await bookingProvider.markAsOngoing(widget.booking.bookingId);
          break;
        case BookingStatus.completed:
          success = await bookingProvider.markAsCompleted(widget.booking.bookingId);
          break;
        case BookingStatus.cancelled:
          success = await bookingProvider.cancelBooking(widget.booking.bookingId);
          break;
      }

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking $actionName successfully'),
            backgroundColor: AppColors.successColor,
          ),
        );
        Navigator.pop(context);
      } else {
        _showError('Failed to $actionName');
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final icon = ServiceTypes.serviceIcons[widget.booking.serviceType] ??
        Icons.miscellaneous_services;
    final statusColor = BookingStatus.getStatusColor(widget.booking.status);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Booking Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.booking.status.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
              // Service Info Card
              Card(
                elevation: AppDimensions.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(AppDimensions.borderRadius),
                            ),
                            child: Icon(
                              icon,
                              size: 32,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.paddingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ServiceTypes.serviceNames[widget.booking.serviceType] ??
                                      widget.booking.serviceType,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Booking ID: ${widget.booking.bookingId}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      _DetailRow(
                        icon: Icons.person,
                        label: 'Customer',
                        value: widget.booking.userName,
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      _DetailRow(
                        icon: Icons.person_outline,
                        label: 'Provider',
                        value: widget.booking.providerName,
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      _DetailRow(
                        icon: Icons.calendar_today,
                        label: 'Date',
                        value: Helpers.formatDate(widget.booking.date),
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      _DetailRow(
                        icon: Icons.access_time,
                        label: 'Duration',
                        value: '${widget.booking.hours} hour${widget.booking.hours > 1 ? 's' : ''}',
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      _DetailRow(
                        icon: Icons.attach_money,
                        label: 'Hourly Rate',
                        value: Helpers.formatCurrency(widget.booking.hourlyRate),
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      _DetailRow(
                        icon: Icons.payment,
                        label: 'Total Cost',
                        value: Helpers.formatCurrency(widget.booking.totalCost),
                        isHighlighted: true,
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      _DetailRow(
                        icon: Icons.event,
                        label: 'Created At',
                        value: Helpers.formatDateTime(widget.booking.createdAt),
                      ),
                      if (widget.booking.rating != null) ...[
                        const SizedBox(height: AppDimensions.paddingMedium),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Rating:',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  index < widget.booking.rating!.toInt()
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 20,
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${widget.booking.rating!.toStringAsFixed(1)})',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
              // Action Buttons
              if (widget.booking.status == BookingStatus.upcoming) ...[
                CustomButton(
                  text: 'Mark as Ongoing',
                  onPressed: () => _updateStatus(
                    BookingStatus.ongoing,
                    'mark as ongoing',
                  ),
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
              ],
              if (widget.booking.status == BookingStatus.ongoing) ...[
                CustomButton(
                  text: 'Mark as Completed',
                  onPressed: () => _updateStatus(
                    BookingStatus.completed,
                    'mark as completed',
                  ),
                  isLoading: _isLoading,
                  backgroundColor: AppColors.completedColor,
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
              ],
              if (widget.booking.status != BookingStatus.completed &&
                  widget.booking.status != BookingStatus.cancelled) ...[
                CustomButton(
                  text: 'Cancel Booking',
                  onPressed: () => _updateStatus(
                    BookingStatus.cancelled,
                    'cancel booking',
                  ),
                  isLoading: _isLoading,
                  backgroundColor: AppColors.errorColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isHighlighted;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isHighlighted ? AppColors.primaryColor : AppColors.textSecondary,
        ),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: isHighlighted ? 18 : 14,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
              color: isHighlighted ? AppColors.primaryColor : AppColors.textPrimary,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
