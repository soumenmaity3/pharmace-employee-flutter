import 'package:flutter/material.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

class ExtraWidget extends StatelessWidget {
  const ExtraWidget({super.key});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.cardColor;
    final borderColor = isDark?AppColors.darkBorder:AppColors.lightBorder;
    final labelColor = isDark?AppColors.darkTextSecondary:AppColors.lightTextSecondary;
    final valueColor = isDark?AppColors.darkTextPrimary:AppColors.lightTextSecondary;

    final items = [
      ('On duty now', '4'),
      ('Bills on this device', '2'),
      ('At or below reorder', '3'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Padding(
              padding:  EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 17,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      items[i].$1,
                      style:  TextStyle(
                        color: labelColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    items[i].$2,
                    style:  TextStyle(
                      color: valueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (i < items.length - 1)
               Divider(
                height: 1,
                thickness: 1,
                color: borderColor,
              ),
          ],
        ],
      ),
    );
  }

}
