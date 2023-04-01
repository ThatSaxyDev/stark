import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/features/tasks_projects/controllers/task_project_controller.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/app_bar.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/widget_extensions.dart';

class TasksView extends ConsumerWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! navigate
    void navigateToCreateProject(BuildContext context) {
      Routemaster.of(context).push('/create-project');
    }

    String _calculateDaysRemaining(DateTime futureDate) {
      Duration difference = futureDate.difference(DateTime.now());
      int days = difference.inDays;
      return '$days days left';
    }

    final projectsStream = ref.watch(getProjectsForOrganisationsProvider);
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Tasks',
      ),
      body: projectsStream.when(
        data: (projects) {
          if (projects.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You don\'t have any projects',
                    style: TextStyle(
                      color: Pallete.blackTint,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  20.sbH,
                  BButton(
                    onTap: () => navigateToCreateProject(context),
                    width: 300.w,
                    text: '+ Create one',
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              20.sbH,
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Row(
                  children: [
                    Text(
                      'Ongoing Projects',
                      style: TextStyle(
                        color: Pallete.newblueColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    10.sbW,
                    InkWell(
                      onTap: () => navigateToCreateProject(context),
                      child: CircleAvatar(
                        radius: 15.w,
                        backgroundColor: Pallete.primaryGreen,
                        child: Icon(
                          Icons.add,
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //! the projects
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 22.w)
                      .copyWith(top: 20.h),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final projectt = projects[index];
                    if (projectt.status == 'ongoing') {
                      return Container(
                        height: 270.h,
                        padding: EdgeInsets.all(22.w),
                        // padding: EdgeInsets.all(15.w),
                        margin: EdgeInsets.only(bottom: 18.h),
                        decoration: BoxDecoration(
                          color: Pallete.whiteColor,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: const [
                            BoxShadow(
                                color: Pallete.greey,
                                blurRadius: 2,
                                offset: Offset(3, 3)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //! started
                            RichText(
                              text: TextSpan(
                                text: 'Started: ',
                                style: TextStyle(
                                  color: Pallete.textGrey,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text: DateFormat.yMMMMEEEEd()
                                        .format(projectt.startDateTime),
                                    style: TextStyle(
                                      color: Pallete.primaryGreen,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            25.sbH,

                            //! project name
                            Text(
                              projectt.name,
                              style: TextStyle(
                                color: Pallete.newblueColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            15.sbH,

                            //! progress indicator
                            SizedBox(
                              height: 10.h,
                              child: Stack(
                                children: [
                                  //! grey background
                                  Container(
                                    height: 10.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Pallete.greey,
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                  ),
                                  //! indicator
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      height: 10.h,
                                      width: 200.h,
                                      decoration: BoxDecoration(
                                          color: Pallete.primaryGreen,
                                          borderRadius:
                                              BorderRadius.circular(10.r)),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            10.sbH,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  projectt.name,
                                  style: TextStyle(
                                    color: Pallete.newblueColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '10%',
                                  style: TextStyle(
                                    color: Pallete.newblueColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Divider(
                              color: Pallete.greyColor,
                            ),
                            10.sbH,
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                    color: Pallete.primaryGreen,
                                    borderRadius: BorderRadius.circular(7.r)),
                                child: Text(
                                  _calculateDaysRemaining(projectt.endDateTime),
                                  style: TextStyle(
                                    color: Pallete.whiteColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
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
