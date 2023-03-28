import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/string_extensions.dart';
import 'package:stark/utils/text_input.dart';
import 'package:stark/utils/widget_extensions.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  //! variable initialization
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //! navigation
  void navigateToSignUp(BuildContext context, String type) {
    Routemaster.of(context).push('/sign-up/$type');
  }

  //! methods
  void loginAdmin(
    BuildContext context,
    WidgetRef ref,
    String email,
    String password,
  ) {
    ref.read(authControllerProvider.notifier).loginAdmin(
          context: context,
          email: email,
          password: password,
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
                      'Login to your account',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Pallete.textGrey,
                      ),
                    ),

                    24.sbH,

                    //! email input
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
                      hintText: 'Confirm Password',
                      controller: _passwordController,
                      icon: 'password_icon',
                    ),
                    32.sbH,

                    BButton(
                      onTap: () => loginAdmin(
                        context,
                        ref,
                        _emailController.text,
                        _passwordController.text,
                      ),
                      text: 'Login',
                    ),
                    70.sbH,

                    RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          color: Pallete.blackTint,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // coming soon modal sheet
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => Wrap(
                                    children: [
                                      Container(
                                        height: 280.h,
                                        padding: EdgeInsets.only(
                                            top: 8.h, right: 24.w, left: 24.w),
                                        decoration: BoxDecoration(
                                          color: Pallete.whiteColor,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(30.r),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            //! bar
                                            Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                height: 3.h,
                                                width: 72.w,
                                                decoration: BoxDecoration(
                                                  color: Pallete.primaryGreen,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.r),
                                                ),
                                              ),
                                            ),
                                            5.sbH,

                                            //! buttons
                                            //! manager
                                            BButton(
                                              onTap: () {
                                                Routemaster.of(context).pop();
                                                navigateToSignUp(
                                                    context, 'admin');
                                              },
                                              height: 95.h,
                                              isText: false,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16.h,
                                                  horizontal: 9.w),
                                              item: Row(
                                                children: [
                                                  SvgPicture.asset('admin'.svg),
                                                  13.sbW,
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Manager',
                                                        style: TextStyle(
                                                          fontSize: 20.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Pallete
                                                              .whiteColor,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 200.w,
                                                        child: Text(
                                                          'Add Your Company and send invite to your employee',
                                                          style: TextStyle(
                                                            fontSize: 11.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Pallete
                                                                .textGrey,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            10.sbH,
                                            //! employee
                                            BButton(
                                              onTap: () {
                                                Routemaster.of(context).pop();
                                                navigateToSignUp(
                                                    context, 'employee');
                                              },
                                              height: 95.h,
                                              isText: false,
                                              color: Pallete.whiteColor,
                                              borderColor: Pallete.greey,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16.h,
                                                  horizontal: 9.w),
                                              item: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'employee'.svg),
                                                  13.sbW,
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Employee',
                                                        style: TextStyle(
                                                          fontSize: 20.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Pallete.blackTint,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 200.w,
                                                        child: Text(
                                                          'Welcome to time in get an invitation link from admin to join the company.',
                                                          style: TextStyle(
                                                            fontSize: 11.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Pallete
                                                                .textGrey,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            25.sbH,
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            text: 'Sign Up',
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
