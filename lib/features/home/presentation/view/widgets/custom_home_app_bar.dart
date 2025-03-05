import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class CustomHomeAppBar extends StatelessWidget {
  const CustomHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: ShapeDecoration(
          shape: OvalBorder(),
          color: Color(0xFFEEF8ED),
        ),
        child: SvgPicture.asset(Assets.imagesNotification),
      ),
      leading: Image.asset(Assets.imagesProFileImage),
      title: Text(
        'صباح الخير !..',
        textAlign: TextAlign.right,
        style: TextStyles.regular16.copyWith(
          color: const Color(0xFF949D9E),
        ),
      ),
      subtitle: Text(
        'أحمد مصطفي',
        textAlign: TextAlign.right,
        style: TextStyles.bold16,
      ),
    );
  }
}
