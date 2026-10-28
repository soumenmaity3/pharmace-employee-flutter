import 'package:flutter/material.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

class NeedsCardWidget extends StatelessWidget {
  const NeedsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section label
          Text(
            'Needs you',
            style: theme.textTheme.bodyMedium!.copyWith(
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 10),

          // Main heading
          Text(
            '2 refunds waiting',
            style: theme.textTheme.titleLarge!.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            'Return requests from the counter need a decision before close.',
            style: theme.textTheme.bodyMedium!.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),

          const SizedBox(height: 20),

          // Review button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to the refunds review screen.
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Review refunds',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Clock-in time
          Center(
            child: Text(
              'Clocked in · 8:40 am',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
