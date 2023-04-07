import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/string_extensions.dart';
import 'package:stark/utils/widget_extensions.dart';

class SelectUserTypeView extends ConsumerWidget {
  const SelectUserTypeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! navigation
    void navigateToSignUp(BuildContext context, String type) {
      Routemaster.of(context).push('/sign-up/$type');
    }

    return Scaffold(
      body: SizedBox(
        height: height(context),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            //!  background
            Container(
              height: height(context),
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(255, 244, 237, 237),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  60.sbH,
                  Image.asset(
                    'starkiconntransparent'.png,
                    height: 300.h,
                  ),
                ],
              ),
            ),

            //! glasssmorph
            Positioned(
              bottom: 0,
              child: Container(
                height: 436.h,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(
                  top: 89.h,
                  bottom: 43.h,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('glassmorph'.png),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.sbH,
                    Text(
                      'Let\'s Get Started!',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: Pallete.blackTint,
                      ),
                    ),
                    // 13.sbH,
                    // RichText(
                    //   text: TextSpan(
                    //     text:
                    //         'Explore your mates for gowth of your knowledge and ',
                    //     style: TextStyle(
                    //       color: Pallete.textGrey,
                    //       fontSize: 14.sp,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //     children: [
                    //       TextSpan(
                    //         text: 'personality',
                    //         style: TextStyle(
                    //           color: Pallete.primaryGreen,
                    //           fontSize: 15.sp,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const Spacer(),

                    //! buttons
                    //! manager
                    BButton(
                      onTap: () => navigateToSignUp(context, 'admin'),
                      height: 95.h,
                      isText: false,
                      padding:
                          EdgeInsets.symmetric(vertical: 16.h, horizontal: 9.w),
                      item: Row(
                        children: [
                          SvgPicture.asset('admin'.svg),
                          13.sbW,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Manager',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Pallete.whiteColor,
                                ),
                              ),
                              SizedBox(
                                width: 200.w,
                                child: Text(
                                  'Add Your Company and send invite to your employee',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Pallete.textGrey,
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
                      onTap: () => navigateToSignUp(context, 'employee'),
                      height: 95.h,
                      isText: false,
                      color: Pallete.whiteColor,
                      borderColor: Pallete.greey,
                      padding:
                          EdgeInsets.symmetric(vertical: 16.h, horizontal: 9.w),
                      item: Row(
                        children: [
                          SvgPicture.asset('employee'.svg),
                          13.sbW,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Employee',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Pallete.blackTint,
                                ),
                              ),
                              SizedBox(
                                width: 200.w,
                                child: Text(
                                  'Join your organisation, be punctual, update your task progress!',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Pallete.textGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
