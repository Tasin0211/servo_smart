import 'package:flutter/material.dart';
import '../utils/constants.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  
  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}
