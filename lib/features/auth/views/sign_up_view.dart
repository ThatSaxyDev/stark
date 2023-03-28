// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routemaster/routemaster.dart';

import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/text_input.dart';
import 'package:stark/utils/widget_extensions.dart';

class SignUpView extends ConsumerStatefulWidget {
  final String type;
  const SignUpView({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  //! variable initialization
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  //! navigation
  void navigateToAdminLogin(BuildContext context) {
    Routemaster.of(context).push('/login');
  }

  //! methods
  void signInAdmin(
    BuildContext context,
    WidgetRef ref,
    String firstName,
    String lastName,
    String email,
    String password,
  ) {
    ref.read(authControllerProvider.notifier).signUpAdmin(
          context: context,
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          isAdmin: widget.type == 'admin' ? true : false,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Pallete.blackish,
      ),
      body: isLoading
          ? const Center(child: Loader())
          : SingleChildScrollView(
              child: Padding(
                padding: 21.padH,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    30.sbH,
                    Text(
                      'Stark',
                      style: TextStyle(
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w600,
                        color: Pallete.primaryGreen,
                      ),
                    ),
                    17.sbH,
                    Text(
                      'Create your account',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Pallete.textGrey,
                      ),
                    ),
                    17.sbH,
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        color: Pallete.primaryGreen,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        widget.type == 'admin' ? 'Manager' : 'Employee',
                        style: TextStyle(
                          color: Pallete.whiteColor,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    24.sbH,
                    //! first name input
                    TextInputBox(
                      height: 47.h,
                      hintText: 'First Name',
                      controller: _firstNameController,
                      icon: 'usericon',
                    ),
                    16.sbH,

                    //! last name input
                    TextInputBox(
                      height: 47.h,
                      hintText: 'Last Name',
                      controller: _lastNameController,
                      icon: 'usericon',
                    ),
                    16.sbH,

                    //! last name input
                    TextInputBox(
                      height: 47.h,
                      hintText: 'Email',
                      controller: _emailController,
                      icon: 'email_icon',
                    ),
                    16.sbH,

                    //! last name input
                    TextInputBox(
                      height: 47.h,
                      hintText: 'Password',
                      controller: _passwordController,
                      icon: 'password_icon',
                    ),
                    16.sbH,

                    //! last name input
                    TextInputBox(
                      height: 47.h,
                      hintText: 'Confirm Password',
                      controller: _confirmPasswordController,
                      icon: 'password_icon',
                    ),
                    32.sbH,

                    BButton(
                      onTap: () => signInAdmin(
                        context,
                        ref,
                        _firstNameController.text,
                        _lastNameController.text,
                        _emailController.text,
                        _confirmPasswordController.text,
                      ),
                      text: 'Sign Up',
                    ),
                    70.sbH,

                    RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: Pallete.blackTint,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => navigateToAdminLogin(context),
                            text: 'Login',
                            style: TextStyle(
                              color: Pallete.primaryGreen,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
