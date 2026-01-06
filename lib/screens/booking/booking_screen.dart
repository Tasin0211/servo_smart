import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/provider_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../upcoming/upcoming_screen.dart';

class BookingScreen extends StatefulWidget {
  final ServiceProviderModel provider;

  const BookingScreen({
    super.key,
    required this.provider,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  int _selectedHours = 1;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _confirmBooking() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date'),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }

    final shouldConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Provider: ${widget.provider.name}'),
            const SizedBox(height: 8),
            Text('Service: ${ServiceTypes.serviceNames[widget.provider.serviceType]}'),
            const SizedBox(height: 8),
            Text('Date: ${Helpers.formatDate(_selectedDate!)}'),
            const SizedBox(height: 8),
            Text('Hours: $_selectedHours'),
            const SizedBox(height: 8),
            Text(
              'Total: ${Helpers.formatCurrency(Helpers.calculateTotalCost(_selectedHours, widget.provider.hourlyRate))}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
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
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (shouldConfirm != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

      final success = await bookingProvider.createBooking(
        user: authProvider.user!,
        provider: widget.provider,
        date: _selectedDate!,
        hours: _selectedHours,
      );

      if (!mounted) return;

      if (success) {
        // Show success dialog
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Booking Confirmed'),
            content: const Text('Your booking has been successfully created!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );

        // Navigate to upcoming screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const UpcomingScreen(),
          ),
          (route) => route.isFirst,
        );
      } else {
        _showError('Failed to create booking. Please try again.');
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
    final totalCost = Helpers.calculateTotalCost(_selectedHours, widget.provider.hourlyRate);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Book Service',
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
              // Provider Info Card
              Card(
                elevation: AppDimensions.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                        child: Text(
                          widget.provider.name.isNotEmpty
                              ? widget.provider.name[0].toUpperCase()
                              : 'P',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      Text(
                        widget.provider.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingSmall),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 20,
                            color: AppColors.secondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.provider.rating.toStringAsFixed(1)} (${widget.provider.totalReviews} reviews)',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingSmall),
                      Text(
                        '${Helpers.formatCurrency(widget.provider.hourlyRate)}/hour',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
              // Date Selection
              const Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              Card(
                elevation: AppDimensions.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.calendar_today,
                    color: AppColors.primaryColor,
                  ),
                  title: Text(
                    _selectedDate != null
                        ? Helpers.formatDate(_selectedDate!)
                        : 'Choose a date',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedDate != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
              // Hours Selection
              const Text(
                'Select Hours',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              Card(
                elevation: AppDimensions.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Hours:',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '$_selectedHours',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _selectedHours.toDouble(),
                        min: 1,
                        max: 8,
                        divisions: 7,
                        label: '$_selectedHours hours',
                        activeColor: AppColors.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _selectedHours = value.toInt();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
              // Total Cost
              Card(
                elevation: AppDimensions.cardElevation,
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Cost:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        Helpers.formatCurrency(totalCost),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
              // Confirm Button
              CustomButton(
                text: AppStrings.confirmBooking,
                onPressed: _confirmBooking,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
