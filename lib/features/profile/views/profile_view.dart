import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/utils/app_bar.dart';
import 'package:stark/utils/button.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void logOut(WidgetRef ref) async {
      ref.read(authControllerProvider.notifier).logOut();
    }

    return Scaffold(
      appBar: MyAppBar(
        title: 'Profile',
      ),
      body: Center(
        child: BButton(
          onTap: () => logOut(ref),
          width: 200.w,
          text: 'Log out',
        ),
      ),
    );
  }
}
