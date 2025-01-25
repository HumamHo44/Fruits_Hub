import 'package:flutter/material.dart';
import 'package:fruits_hub/constants.dart';
import 'package:fruits_hub/core/utils/app_colors.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/widgets/custom_button.dart';
import 'package:fruits_hub/core/widgets/custom_text_form_field.dart';
import 'package:fruits_hub/features/auth/presentation/view/widgets/dont_have_an_account_widget.dart';
import 'package:fruits_hub/features/auth/presentation/view/widgets/or_divider.dart';
import 'package:fruits_hub/features/auth/presentation/view/widgets/social_login_button.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              height: 24,
            ),
            const CustomTextFormField(
              hintText: 'البريد الالكتروني',
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 16,
            ),
            const CustomTextFormField(
              suffixIcon: Icon(
                Icons.remove_red_eye,
                color: Color(0xFFC9CECF),
              ),
              hintText: 'كلمة المرور',
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'نسيت كلمة المرور؟',
                  style: TextStyles.semiBold13.copyWith(
                    color: AppColors.lightPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            CustomButton(onPressed: () {}, text: 'تسجيل الدخول'),
            const SizedBox(
              height: 32,
            ),
            const DontHaveAnAccounWidget(),
            const SizedBox(
              height: 33,
            ),
            const OrDivider(),
            SocialLoginButton(
              onPressed: () {},
              title: 'تسجيل بواسطة جوجل',
              image: Assets.imagesGoogleIcon,
            ),
          ],
        ),
      ),
    );
  }
}
