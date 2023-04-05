import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stark/core/utils.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/profile/comtrollers/profile_controller.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/text_input.dart';
import 'package:stark/utils/widget_extensions.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? profileFile;

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editUserProfile(
          context: context,
          profileFile: profileFile,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          role: _roleController.text,
          phone: _phoneController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final user = ref.watch(userProvider)!;
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Pallete.profileGreen.withOpacity(0.3),
        foregroundColor: Pallete.blackTint,
        title: Text(
          'My Profile',
          style: TextStyle(
              color: Pallete.blackish,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Pallete.profileGreen.withOpacity(0.3),
          child: isLoading
              ? const Loader()
              : Column(
                  children: [
                    70.sbH,
                    Expanded(
                      child: ref.watch(getUserProvider(user.uid)).when(
                            data: (userr) {
                              // _firstNameController =
                              //     TextEditingController(text: userr.firstName);
                              // _lastNameController =
                              //     TextEditingController(text: userr.lastName);
                              //     _roleController =
                              //     TextEditingController(text: userr.role);
                              //     _phoneController =
                              //     TextEditingController(text: userr.phone);
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 24.w)
                                    .copyWith(top: 16.h),
                                decoration: BoxDecoration(
                                  color: Pallete.whiteColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50.r),
                                    topRight: Radius.circular(50.r),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 101.h,
                                      width: 101.w,
                                      child: Stack(
                                        children: [
                                          profileFile != null
                                              ? CircleAvatar(
                                                  backgroundImage:
                                                      FileImage(profileFile!),
                                                  radius: 50.w,
                                                )
                                              : CircleAvatar(
                                                  radius: 50.w,
                                                  backgroundColor:
                                                      Pallete.greey,
                                                  backgroundImage: NetworkImage(
                                                      userr.profilePic),
                                                ),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: BButton(
                                              onTap: selectProfileImage,
                                              height: 25.h,
                                              width: 25.h,
                                              radius: 3.r,
                                              isText: false,
                                              item: Icon(
                                                PhosphorIcons.penFill,
                                                size: 15.sp,
                                              ),
                                              color: Pallete.primaryGreen,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    10.sbH,
                                    Text(
                                      userr.email,
                                      style: TextStyle(
                                          color: Pallete.blackish,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700),
                                    ),

                                    25.sbH,
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'First Name',
                                        style: TextStyle(
                                            color: Pallete.blackish,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    6.sbH,
                                    //! first name input
                                    TextInputBoxx(
                                      height: 47.h,
                                      hintText: userr.firstName,
                                      controller: _firstNameController,
                                      icon:
                                          const Icon(PhosphorIcons.personThin),
                                    ),
                                    16.sbH,

                                    //!
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Last Name',
                                        style: TextStyle(
                                            color: Pallete.blackish,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    6.sbH,
                                    //! last name input
                                    TextInputBoxx(
                                      height: 47.h,
                                      hintText: userr.lastName,
                                      controller: _lastNameController,
                                      icon:
                                          const Icon(PhosphorIcons.personThin),
                                    ),
                                    16.sbH,

                                    //! role
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Role',
                                        style: TextStyle(
                                            color: Pallete.blackish,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    6.sbH,
                                    TextInputBoxx(
                                      height: 47.h,
                                      hintText: userr.role,
                                      controller: _roleController,
                                      icon: const Icon(PhosphorIcons.gearThin),
                                    ),
                                    16.sbH,

                                    //! phone input
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Phone',
                                        style: TextStyle(
                                            color: Pallete.blackish,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    6.sbH,
                                    TextInputBoxx(
                                      height: 47.h,
                                      hintText: userr.phone,
                                      controller: _phoneController,
                                      icon: const Icon(
                                          PhosphorIcons.phoneCallThin),
                                    ),

                                    50.sbH,
                                    BButton(
                                      onTap: save,
                                      height: 50.h,
                                      text: 'Save',
                                    ),
                                  ],
                                ),
                              );
                            },
                            error: (error, stactrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
