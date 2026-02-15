import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ProgressBarWidget extends StatelessWidget {
  final double percentage;

  const ProgressBarWidget({
    super.key,
    required this.percentage,
  });

  Color _getProgressColor(double percentage) {
    if (percentage < 30) return AppColors.errorRed;
    if (percentage < 70) return AppColors.warningAmber;
    return AppColors.successGreen;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Progress',
              style: AppTextStyles.caption,
            ),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 6,
            backgroundColor: AppColors.backgroundGrey,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getProgressColor(percentage),
            ),
          ),
        ),
      ],
    );
  }
}
