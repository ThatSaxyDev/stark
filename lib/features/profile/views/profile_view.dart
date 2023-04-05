import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/app_bar.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/widget_extensions.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void logOut(WidgetRef ref) async {
      ref.read(authControllerProvider.notifier).logOut();
    }

    void navigateToEditProfile(BuildContext context) {
      Routemaster.of(context).push('/edit-profile');
    }

    void showlogOutDialog(WidgetRef ref, BuildContext context) async {
      showGeneralDialog(
        context: context,
        //!SHADOW EFFECT
        barrierColor: Pallete.blackColor.withOpacity(0.2),
        transitionBuilder: (context, a1, a2, widget) => Dialog(
          elevation: 65.0.h,
          child: Container(
            height: 270.h * a1.value,
            width: 296.w * a2.value,
            decoration: BoxDecoration(
              color: Pallete.whiteColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  18.sbH,
                  CircleAvatar(
                    radius: 25.w,
                    backgroundColor: Pallete.primaryGreen,
                    child: const Icon(
                      PhosphorIcons.signOut,
                      color: Color.fromARGB(255, 57, 44, 44),
                    ),
                  ),
                  15.sbH,
                  Text(
                    'Log out',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Pallete.blackColor,
                        fontWeight: FontWeight.w600),
                  ),
                  6.sbH,
                  Text(
                    'Are you sure?',
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: Pallete.greyColor,
                        fontWeight: FontWeight.w400),
                  ),
                  20.sbH,
                  // cancel
                  Padding(
                    padding: 13.padH,
                    child: BButton(
                      onTap: () {
                        Routemaster.of(context).pop();
                      },
                      height: 41.h,
                      radius: 6.r,
                      color: Pallete.blackTint,
                      text: 'No, cancel',
                    ),
                  ),
                  20.sbH,
                  // yes
                  Padding(
                    padding: 13.padH,
                    child: TransparentButton(
                      onTap: () {
                        Routemaster.of(context).pop();
                        logOut(ref);
                      },
                      height: 39.h,
                      radius: 6.r,
                      color: Pallete.blackTint,
                      text: 'Yes, log me out',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        //! ANIMATION DURATION
        transitionDuration: const Duration(milliseconds: 200),

        //! STILL DON'T KNOW WHAT THIS DOES, BUT IT'S REQUIRED
        pageBuilder: (context, animation1, animation2) => const Text(""),
      );
    }

    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: MyAppBar(
        title: 'Profile',
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height(context),
          width: width(context),
          child: Column(
            children: [
              58.sbH,
              CircleAvatar(
                radius: 50.w,
                backgroundColor: Pallete.greey,
                backgroundImage: NetworkImage(user.profilePic),
              ),
              27.sbH,
              Text(
                '${user.firstName} ${user.lastName}',
                style: TextStyle(
                    fontSize: 22.sp,
                    color: Pallete.blackish,
                    fontWeight: FontWeight.w600),
              ),
              8.sbH,
              Text(
                user.role == '' ? 'Role - - -' : user.role,
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Pallete.greyColor,
                    fontWeight: FontWeight.w500),
              ),
              36.sbH,
              BButton(
                onTap: () => navigateToEditProfile(context),
                width: 128.w,
                height: 40.h,
                text: 'Edit Profile',
              ),
              60.sbH,
              ListTile(
                onTap: () => showlogOutDialog(ref, context),
                leading: CircleAvatar(
                  radius: 30.w,
                  backgroundColor: Pallete.primaryGreen.withOpacity(0.08),
                  child: const Icon(
                    PhosphorIcons.signOut,
                    color: Pallete.blackTint,
                  ),
                ),
                title: Text(
                  'Log out',
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Pallete.blackColor,
                      fontWeight: FontWeight.w400),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Pallete.blackTint.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
