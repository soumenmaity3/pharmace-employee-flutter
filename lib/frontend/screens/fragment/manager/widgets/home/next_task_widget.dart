import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';

class NextTaskWidget extends StatelessWidget {
  const NextTaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
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
          // Header: Next task + Urgent badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Next task',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              Container(
                height: 25,
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.errorDarkContainer.withValues(alpha: isDark?1:0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 15,
                      color: AppColors.errorDark,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Urgent',
                      style: TextStyle(
                        color: AppColors.errorDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 6),

          // Task title
          Text(
            'Review the afternoon refund queue',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge!.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 8),

          // Task schedule
          Text(
            'Today · End of Shift',
            style: theme.textTheme.bodyMedium!.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              // TODO: Navigate to the task details screen.
            },
            borderRadius: BorderRadius.circular(8),
            child: Text(
              'Open task',
              style: theme.textTheme.titleLarge!.copyWith(
                color: AppColors.primaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
