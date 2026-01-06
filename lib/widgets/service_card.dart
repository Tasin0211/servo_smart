import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ServiceCard extends StatelessWidget {
  final String serviceType;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.serviceType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = ServiceTypes.serviceIcons[serviceType] ?? Icons.miscellaneous_services;
    final name = ServiceTypes.serviceNames[serviceType] ?? serviceType;

    return Card(
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
