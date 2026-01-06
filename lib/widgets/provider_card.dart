import 'package:flutter/material.dart';
import '../models/provider_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class ProviderCard extends StatelessWidget {
  final ServiceProviderModel provider;
  final VoidCallback onSelect;

  const ProviderCard({
    super.key,
    required this.provider,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
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
                // Provider Avatar
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  child: Text(
                    provider.name.isNotEmpty ? provider.name[0].toUpperCase() : 'P',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMedium),
                // Provider Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: AppColors.secondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${provider.rating.toStringAsFixed(1)} (${provider.totalReviews} reviews)',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${Helpers.formatCurrency(provider.hourlyRate)}/hour',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (provider.description.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.paddingMedium),
              Text(
                provider.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppDimensions.paddingMedium),
            // Select Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  ),
                ),
                child: const Text(
                  'Select',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
