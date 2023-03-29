import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/organisation/controllers/organisation_controller.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/app_bar.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/widget_extensions.dart';

class MarkAttendanceView extends ConsumerWidget {
  const MarkAttendanceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceStream = ref.watch(getAttendanceStreamProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Pallete.blackTint,
        title: Text(
          'Mark Attendance',
          style: TextStyle(
              color: Pallete.blackish,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: attendanceStream.when(
        data: (attendance) {
          if (attendance.isEmpty) {
            return const ErrorText(error: 'No attendance available');
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w).copyWith(top: 20.h),
            itemCount: attendance.length,
            itemBuilder: (context, index) {
              final employee = attendance[index];
              if (employee.status != 'notsigned') {
                return const SizedBox.shrink();
              }
              //! attendance card
              return Container(
                padding: EdgeInsets.all(15.w),
                margin: EdgeInsets.only(bottom: 18.h),
                decoration: BoxDecoration(
                  color: Pallete.whiteColor,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: const [
                    BoxShadow(
                      color: Pallete.greey,
                      blurRadius: 2,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: ref.watch(getUserProvider(employee.employeeId)).when(
                      data: (employeee) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25.w,
                                  backgroundImage:
                                      NetworkImage(employeee.profilePic),
                                ),
                                10.sbW,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${employeee.firstName} ${employeee.lastName}',
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
                                TransparentButton(
                                  onTap: () {
                                    ref
                                        .read(organisationsControllerProvider
                                            .notifier)
                                        .markAttendance(
                                            context, employee.employeeId);
                                  },
                                  width: 100.w,
                                  color: Pallete.greyColor,
                                  text: 'Sign',
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    ),
              );
            },
          );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}
