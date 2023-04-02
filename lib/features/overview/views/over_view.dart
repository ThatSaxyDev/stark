import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/features/attendance/controllers/attendance_controller.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/organisation/controllers/organisation_controller.dart';
import 'package:stark/features/tasks_projects/controllers/task_project_controller.dart';
import 'package:stark/models/attemdance_model.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/app_bar.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/widget_extensions.dart';

class OverView extends ConsumerStatefulWidget {
  const OverView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OverViewState();
}

class _OverViewState extends ConsumerState<OverView> {
  DateTime todaysDate = DateTime.now();

  //! navigation
  void navigateToCreateOrg(BuildContext context) {
    Routemaster.of(context).push('/create-organisation');
  }

  void navigateToMarkAttendance(BuildContext context) {
    Routemaster.of(context).push('/mark-attendance');
  }

  int getNumberOfProjectsDoneNumber(projects) {
    return projects.where((project) => project.status == 'done').length;
  }

  int getNumberOfTProjectsProgressNumber(projects) {
    return projects.where((project) => project.status == 'ongoing').length;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final organisationsStream = ref.watch(getManagerOrganisationsProvider);
    final projectsStream = ref.watch(getProjectsForOrganisationsProvider);
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Overview',
      ),
      body: organisationsStream.when(
        data: (organisations) => organisations.isEmpty
            //! if you dont have an organisation
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You don\'t have an organisation',
                      style: TextStyle(
                        color: Pallete.blackTint,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    20.sbH,
                    BButton(
                      onTap: () => navigateToCreateOrg(context),
                      width: 300.w,
                      text: '+ Create one',
                    ),
                  ],
                ),
              )
            : //! when an orgaisation has been created
            Column(
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
                        DateFormat.yMMMMEEEEd().format(todaysDate),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 7.h),
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
                        TransparentButton(
                          width: 150.w,
                          height: 50.h,
                          onTap: () => navigateToMarkAttendance(context),
                          color: Pallete.greyColor,
                          isText: false,
                          item: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Attendance',
                                style: TextStyle(
                                  color: Pallete.blackTint,
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Pallete.blackTint,
                                size: 19.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  10.sbH,
                  //! TODO: implement pie chart

                  // //! pie chart
                  // SizedBox.square(
                  //   dimension: 60.h,
                  //   child: PieChart(
                  //     PieChartData(
                  //       centerSpaceRadius: 50.h,
                  //       borderData: FlBorderData(show: false),
                  //       sections: [
                  //         PieChartSectionData(value: 10, color: Colors.blue),
                  //         PieChartSectionData(value: 10, color: Colors.orange),
                  //         PieChartSectionData(value: 10, color: Colors.red),

                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Text(
                    organisations[0].employees.length == 1
                        ? 'Total ${organisations[0].employees.length.toString()} employee'
                        : 'Total ${organisations[0].employees.length.toString()} employees',
                    style: TextStyle(
                      color: Pallete.blackColor,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  20.sbH,
                  //! metrics
                  ref.watch(getAttendanceRecordProvider).when(
                        data: (data) {
                          String orgName = '';
                          organisationsStream
                              .whenData((value) => orgName = value[0].name);
                          if (data.organisationName == orgName) {
                            return Column(
                              children: [
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
                                            'Present ${data.present.length}',
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
                                            'Early ${data.early.length}',
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
                                            'Absent ${data.absent.length}',
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
                                            'Late ${data.late.length}',
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
                          }

                          return const SizedBox.shrink();
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      ),
                  const Spacer(),
                  //! projects over view
                  projectsStream.when(
                    data: (projects) {
                      if (projects.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      int done = getNumberOfProjectsDoneNumber(projects);
                      int ongoing =
                          getNumberOfTProjectsProgressNumber(projects);

                      return Container(
                        height: 270.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 15.w)
                            .copyWith(top: 20.h),
                        decoration: BoxDecoration(
                          color: Pallete.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Project Overview',
                              style: TextStyle(
                                color: Pallete.blackColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            10.sbH,
                            //! project number
                            Row(
                              children: [
                                Text(
                                  projects.length.toString(),
                                  style: TextStyle(
                                    color: Pallete.blackColor,
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                10.sbW,
                                Text(
                                  projects.length == 1
                                      ? 'Projects'
                                      : 'Projects',
                                  style: TextStyle(
                                    color: Pallete.blackColor.withOpacity(0.4),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            24.sbH,
                            //! doings for the metrics
                            SizedBox(
                              height: 80.h,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: ongoing,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 11.h,
                                          color: Pallete.progressGrey,
                                        ),
                                        Text(
                                          'Ongoing',
                                          style: TextStyle(
                                            color: Pallete.blackColor
                                                .withOpacity(0.6),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 10.h,
                                              width: 10.h,
                                              decoration: BoxDecoration(
                                                  color: Pallete.progressGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.r)),
                                            ),
                                            8.sbW,
                                            Text(
                                              ongoing.toString(),
                                              style: TextStyle(
                                                color: Pallete.blackColor,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  8.sbW,
                                  Expanded(
                                    flex: done,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 11.h,
                                          color: Colors.green.shade800,
                                        ),
                                        Text(
                                          'Completed',
                                          style: TextStyle(
                                            color: Pallete.blackColor
                                                .withOpacity(0.6),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 10.h,
                                              width: 10.h,
                                              decoration: BoxDecoration(
                                                  color: Colors.green.shade800,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.r)),
                                            ),
                                            8.sbW,
                                            Text(
                                              done.toString(),
                                              style: TextStyle(
                                                color: Pallete.blackColor,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w500,
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
                          ],
                        ),
                      );
                    },
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => const Loader(),
                  ),
                ],
              ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}
