// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';

import 'package:stark/models/user_model.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/widget_extensions.dart';

class EmployeeCard extends ConsumerWidget {
  final String employeeUid;
  const EmployeeCard({
    super.key,
    required this.employeeUid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(15.w),
      margin: EdgeInsets.only(bottom: 18.h),
      decoration: BoxDecoration(
          color: Pallete.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: const [
            BoxShadow(
                color: Pallete.greey, blurRadius: 2, offset: Offset(3, 3)),
          ]),
      child: ref.watch(getUserProvider(employeeUid)).when(
            data: (employee) {
              return Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.w,
                        backgroundImage: NetworkImage(employee.profilePic),
                      ),
                      10.sbW,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${employee.firstName} ${employee.lastName}',
                            style: TextStyle(
                              color: Pallete.blackish,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          5.sbH,
                          Text(
                            'Role', //TODO! update role in the organisation model, add roles and department
                            style: TextStyle(
                              color: Pallete.greyColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          PhosphorIcons.signOutBold,
                          color: Pallete.thickRed,
                        ),
                      ),
                    ],
                  ),
                  13.sbH,
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Department',
                            style: TextStyle(
                              color: Pallete.blackish,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          4.sbH,
                          Text(
                            'DEmployee Dpet',
                            style: TextStyle(
                              color: Pallete.blackish,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  25.sbH,
                  Row(
                    children: [
                    const Icon(PhosphorIcons.envelope),
                      7.sbW,
                      Text(
                        employee.email,
                        style: TextStyle(
                          color: Pallete.blackish,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  10.sbH,
                  Row(
                    children: [
                      Icon(PhosphorIcons.phone), 
                      7.sbW,
                      Text(
                        '08028068097731',
                        style: TextStyle(
                          color: Pallete.blackish,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
