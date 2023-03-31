import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stark/features/attendance/controllers/attendance_controller.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/organisation/controllers/organisation_controller.dart';
import 'package:stark/features/timer/timerr.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/app_bar.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/widget_extensions.dart';

class MarkAttendanceView extends ConsumerStatefulWidget {
  const MarkAttendanceView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MarkAttendanceViewState();
}

class _MarkAttendanceViewState extends ConsumerState<MarkAttendanceView> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final attendanceStream = ref.watch(getAttendanceStreamProvider);
    final attendanceStreamSigned = ref.watch(getAttendanceSignedStreamProvider);
    // final currentTime = ref.watch(timeNotifierProvider.notifier);
    // if (currentTime.hour == 12 &&
    //     currentTime.minute == 0 &&
    //     currentTime.second == 0) {
    //   ref.read(myFunctionProvider);
    // }
    return Scaffold(
      floatingActionButton: attendanceStreamSigned.when(
        data: (signed) {
          if (signed.isNotEmpty) {
            return FloatingActionButton(
              onPressed: () => ref
                  .read(attendanceControllerProvider.notifier)
                  .createAttendance(context),
              child: Icon(PhosphorIcons.repeatBold),
            );
          }
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
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
            return attendanceStreamSigned.when(
              data: (signed) {
                if (signed.isNotEmpty) {
                  return ErrorText(error: 'All employees signed');
                }

                return Center(
                  child: BButton(
                    color: Pallete.primaryGreen,
                    onTap: () => ref
                        .read(attendanceControllerProvider.notifier)
                        .createAttendance(context),
                    width: 300.w,
                    text: 'Open Attendance For Today',
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            );
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
                                        .read(attendanceControllerProvider
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
