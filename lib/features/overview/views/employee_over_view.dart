import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stark/features/attendance/controllers/attendance_controller.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/employee/controllers/employee_controller.dart';
import 'package:stark/features/employee/widgets/employee_invite_tile.dart';
import 'package:stark/features/organisation/controllers/organisation_controller.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/app_bar.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/widget_extensions.dart';

class EmployeeOverView extends ConsumerStatefulWidget {
  const EmployeeOverView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmployeeOverViewState();
}

class _EmployeeOverViewState extends ConsumerState<EmployeeOverView> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final invitesStream = ref.watch(getInvitesForEmployeeProvider);
    final organisationsStream = ref.watch(getEmployeeOrganisationsProvider);

    return Scaffold(
      appBar: const MyAppBar(title: ''),
      body: organisationsStream.when(
        data: (organisations) {
          if (organisations.isEmpty) {
            return invitesStream.when(
              data: (invites) {
                if (invites.isEmpty) {
                  return Center(
                    child: Text(
                      'You do not belong to any organisation, kindly contact your administrator for an invite',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Pallete.blackish,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }

                return invites[0].status == 'pending'
                    ? Column(
                        children: [
                          10.sbH,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.w),
                              child: Text(
                                'Welcome ${user.firstName},',
                                style: TextStyle(
                                  color: Pallete.blackTint,
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          7.sbH,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.w),
                              child: Text(
                                'Looks like you\'ve been invited to an organisation',
                                style: TextStyle(
                                  color: Pallete.greyColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),

                          //! invitation
                          EmployeeInviteTile(
                            invite: invites[0],
                          ),
                        ],
                      )
                    : const SizedBox.shrink();
              },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            );
          }

          return Column(
            children: [
              10.sbH,
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Text(
                    'Welcome ${user.firstName},',
                    style: TextStyle(
                      color: Pallete.blackTint,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              7.sbH,
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Text(
                    DateFormat.yMMMMEEEEd().format(DateTime.now()),
                    style: TextStyle(
                      color: Pallete.greyColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              15.sbH,
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: Pallete.primaryGreen,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    organisations[0].name.toUpperCase(),
                    style: TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              20.sbH,
              ref.watch(getAttendanceRecordListProvider).when(
                    data: (attendanceRecords) {
                      int presentCount = attendanceRecords
                          .where((record) => record.present.contains(user.uid))
                          .length;

                      int absentCount = attendanceRecords
                          .where((record) => record.absent.contains(user.uid))
                          .length;

                      int earlyCount = attendanceRecords
                          .where((record) => record.early.contains(user.uid))
                          .length;

                      int lateCount = attendanceRecords
                          .where((record) => record.late.contains(user.uid))
                          .length;

                      return Column(
                        children: [
                          Text(
                            attendanceRecords.length == 1
                                ? '${attendanceRecords.length} work day'
                                : '${attendanceRecords.length} work days',
                            style: TextStyle(
                              color: Pallete.blackColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          10.sbH,
                          Padding(
                            padding: 35.padH,
                            child: Row(
                              children: [
                                //! present
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 5.w,
                                      backgroundColor: Colors.green,
                                    ),
                                    10.sbW,
                                    Text(
                                      'Present $presentCount',
                                      style: TextStyle(
                                        color: Pallete.blackColor,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                //! early
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 5.w,
                                      backgroundColor: Colors.purple,
                                    ),
                                    10.sbW,
                                    Text(
                                      'Early $earlyCount',
                                      style: TextStyle(
                                        color: Pallete.blackColor,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          32.sbH,
                          Padding(
                            padding: 35.padH,
                            child: Row(
                              children: [
                                //! present
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 5.w,
                                      backgroundColor: Colors.red,
                                    ),
                                    10.sbW,
                                    Text(
                                      'Absent $absentCount',
                                      style: TextStyle(
                                        color: Pallete.blackColor,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                //! early
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 5.w,
                                      backgroundColor: Colors.orange,
                                    ),
                                    10.sbW,
                                    Text(
                                      'Late $lateCount',
                                      style: TextStyle(
                                        color: Pallete.blackColor,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    error: (error, stackTrace) =>
                        ErrorText(error: 'Attendance not opened for today'),
                    loading: () => const Loader(),
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
