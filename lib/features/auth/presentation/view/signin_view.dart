import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/services/get_it_service.dart';
import 'package:fruits_hub/core/widgets/custom_app_bar.dart';
import 'package:fruits_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:fruits_hub/features/auth/presentation/cubits/signin_cubits/signin_cubit.dart';
import 'package:fruits_hub/features/auth/presentation/view/widgets/signin_view_body_bloc_consumer.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});
  static const String routeName = 'login_view';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SigninCubit(getIt.get<AuthRepo>()),
      child: Scaffold(
        appBar: buildAppBar(
          context,
          title: 'تسجيل الدخول',
        ),
        body: const SigninviewBodyBlocConsumer(),
      ),
    );
  }
}
