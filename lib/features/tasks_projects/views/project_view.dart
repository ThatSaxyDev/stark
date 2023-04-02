// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/tasks_projects/controllers/task_project_controller.dart';
import 'package:stark/features/tasks_projects/views/task_creation_bottom_sheet.dart';

import 'package:stark/theme/palette.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/widget_extensions.dart';

class ProjectView extends ConsumerStatefulWidget {
  final String name;
  const ProjectView({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProjectViewState();
}

class _ProjectViewState extends ConsumerState<ProjectView> {
  final ValueNotifier<int> selected = ValueNotifier(0);
  final PageController _controller = PageController();

  int getNumberOfTasksDoneNumber(tasks) {
    return tasks.where((task) => task.status == 'done').length;
  }

  int getNumberOfTasksProgressNumber(tasks) {
    return tasks.where((task) => task.status == 'not started').length;
  }

  @override
  Widget build(BuildContext context) {
    String nname = widget.name;
    nname = nname.replaceAll("%20", " ");

    //! get days left
    String calculateDaysRemaining(DateTime futureDate) {
      Duration difference = futureDate.difference(DateTime.now());
      int days = difference.inDays;
      if (days <= 0) {
        return 'Overdue';
      }
      return '$days days left';
    }

    return Scaffold(
      floatingActionButton: ref.watch(getTasksInProjectProvider(nname)).when(
            data: (tasks) {
              int done = getNumberOfTasksDoneNumber(tasks);
              if (done == tasks.length) {
                return FloatingActionButton.extended(
                  backgroundColor: Colors.green.shade900,
                  onPressed: () {
                    ref
                        .read(taskProjectControllerProvider.notifier)
                        .updatProjectStatusDone(context, nname);
                  },
                  label: Row(
                    children: [
                      Text(
                        'Project Done',
                        style: TextStyle(
                          color: Pallete.whiteColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      10.sbW,
                      Icon(
                        PhosphorIcons.checkBold,
                        size: 20.sp,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Pallete.blackTint,
        title: Text(
          nname,
          style: TextStyle(
              color: Pallete.blackish,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BButton(
              width: 40.w,
              height: 30.h,
              radius: 10.r,
              color: Pallete.primaryGreen,
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Wrap(
                      children: [
                        TaskCreationBottomSheet(
                          projectName: nname,
                        ),
                      ],
                    ),
                  ),
                );
              },
              isText: false,
              item: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: ref.watch(getProjectProvider(nname)).when(
            data: (project) {
              return SizedBox.expand(
                child: Column(
                  children: [
                    //! start date
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w)
                          .copyWith(top: 15.h),
                      child: RichText(
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
                                  .format(project.startDateTime),
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w)
                          .copyWith(top: 5.h),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'Ends: ',
                          style: TextStyle(
                            color: Pallete.textGrey,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: DateFormat.yMMMMEEEEd()
                                  .format(project.endDateTime),
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    20.sbH,
                    //! days left
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                      decoration: BoxDecoration(
                          color: calculateDaysRemaining(
                                    project.endDateTime,
                                  ) ==
                                  'Overdue'
                              ? Pallete.thickRed
                              : Pallete.primaryGreen,
                          borderRadius: BorderRadius.circular(20.r)),
                      child: Text(
                        calculateDaysRemaining(
                          project.endDateTime,
                        ),
                        style: TextStyle(
                          color: Pallete.whiteColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    20.sbH,

                    //! employees list view
                    SizedBox(
                      height: 35.h,
                      width: double.infinity,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: project.employeeIds.length,
                        padding: 20.padH,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if (project.employeeIds.isEmpty) {
                            return const ErrorText(
                                error: 'No employees adeded to project');
                          }

                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            margin: EdgeInsets.only(right: 10.w),
                            decoration: BoxDecoration(
                                color: Pallete.greey,
                                borderRadius: BorderRadius.circular(10.r)),
                            child: ref
                                .watch(
                                    getUserProvider(project.employeeIds[index]))
                                .when(
                                  data: (employee) {
                                    return Center(
                                      child: Text(
                                        '${employee.firstName} ${employee.lastName}',
                                        style: TextStyle(
                                          color: Pallete.whiteColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    );
                                  },
                                  error: (error, stackTrace) =>
                                      ErrorText(error: error.toString()),
                                  loading: () => const Loader(),
                                ),
                          );
                        },
                      ),
                    ),
                    20.sbH,
                    //! tasks
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35.w)
                          .copyWith(bottom: 20.h),
                      child: ValueListenableBuilder(
                        valueListenable: selected,
                        child: const SizedBox.shrink(),
                        builder: (context, value, child) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //! NOT STARTED
                              // InkWell(
                              //   onTap: () {
                              //     selected.value = 0;
                              //     _controller.animateToPage(
                              //       duration: const Duration(milliseconds: 500),
                              //       curve: Curves.easeInOut,
                              //       0,
                              //     );
                              //   },
                              //   child: Text(
                              //     'NOT STARTED',
                              //     style: TextStyle(
                              //       color: selected.value == 0
                              //           ? Pallete.blackish
                              //           : Pallete.greey,
                              //       fontSize:
                              //           selected.value == 0 ? 20.sp : 15.sp,
                              //       fontWeight: selected.value == 0
                              //           ? FontWeight.w800
                              //           : FontWeight.w500,
                              //     ),
                              //   ),
                              // ),

                              //! IN PROGRESS
                              InkWell(
                                onTap: () {
                                  selected.value = 0;
                                  _controller.animateToPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    0,
                                  );
                                },
                                child: Text(
                                  'IN PROGRESS',
                                  style: TextStyle(
                                    color: selected.value == 0
                                        ? Pallete.blackish
                                        : Pallete.greey,
                                    fontSize:
                                        selected.value == 0 ? 20.sp : 15.sp,
                                    fontWeight: selected.value == 0
                                        ? FontWeight.w800
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: 20.padH,
                                  child: const Divider(
                                    thickness: 3,
                                    color: Pallete.blueColor,
                                  ),
                                ),
                              ),

                              //! DONE
                              InkWell(
                                onTap: () {
                                  selected.value = 1;
                                  _controller.animateToPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    1,
                                  );
                                },
                                child: Text(
                                  'DONE',
                                  style: TextStyle(
                                    color: selected.value == 1
                                        ? Pallete.blackish
                                        : Pallete.greey,
                                    fontSize:
                                        selected.value == 1 ? 20.sp : 15.sp,
                                    fontWeight: selected.value == 1
                                        ? FontWeight.w800
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        onPageChanged: (value) {
                          if (value == 0) {
                            selected.value = 0;
                          } else if (value == 1) {
                            selected.value = 1;
                          }
                        },
                        controller: _controller,
                        pageSnapping: true,
                        children: [
                          //! in progress
                          ref.watch(getTasksInProjectProvider(nname)).when(
                                data: (tasks) {
                                  int notDone =
                                      getNumberOfTasksProgressNumber(tasks);
                                  if (notDone == 0) {
                                    return Center(
                                      child: Text(
                                        'Nothing here',
                                        style: TextStyle(
                                          color: Pallete.thickRed,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    itemCount: tasks.length,
                                    itemBuilder: (context, index) {
                                      final task = tasks[index];
                                      if (task.status != 'not started') {
                                        return const SizedBox.shrink();
                                      }

                                      return Container(
                                        padding: EdgeInsets.all(15.w),
                                        margin: EdgeInsets.only(bottom: 18.h),
                                        decoration: BoxDecoration(
                                            color: Pallete.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Pallete.greey,
                                                  blurRadius: 2,
                                                  offset: Offset(3, 3)),
                                            ]),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  task.taskName,
                                                  style: TextStyle(
                                                    color: Pallete.blackish,
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    ref
                                                        .read(
                                                            taskProjectControllerProvider
                                                                .notifier)
                                                        .updateTaskStatusDone(
                                                            context,
                                                            task.taskName);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 7.w,
                                                            vertical: 5.h),
                                                    decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.r)),
                                                    child: Text(
                                                      'Done ?',
                                                      style: TextStyle(
                                                        color:
                                                            Pallete.whiteColor,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            20.sbH,
                                            ref
                                                .watch(getUserProvider(
                                                    task.employeeId))
                                                .when(
                                                  data: (employee) {
                                                    return Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: RichText(
                                                        textAlign:
                                                            TextAlign.start,
                                                        text: TextSpan(
                                                          text: 'Assigned to: ',
                                                          style: TextStyle(
                                                            color: Pallete
                                                                .textGrey,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: employee
                                                                  .firstName,
                                                              style: TextStyle(
                                                                color: Pallete
                                                                    .blackColor,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  error: (error, stackTrace) =>
                                                      ErrorText(
                                                          error:
                                                              error.toString()),
                                                  loading: () => const Loader(),
                                                ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                error: (error, stackTrace) =>
                                    ErrorText(error: error.toString()),
                                loading: () => const Loader(),
                              ),

                          //! done
                          //! in progress
                          ref.watch(getTasksInProjectProvider(nname)).when(
                                data: (tasks) {
                                  int done = getNumberOfTasksDoneNumber(tasks);
                                  if (done == 0) {
                                    return Center(
                                      child: Text(
                                        'Nothing here',
                                        style: TextStyle(
                                          color: Pallete.thickRed,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }
                                  return ListView.builder(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    itemCount: tasks.length,
                                    itemBuilder: (context, index) {
                                      final task = tasks[index];
                                      if (task.status != 'done') {
                                        return const SizedBox.shrink();
                                      }

                                      return Container(
                                        padding: EdgeInsets.all(15.w),
                                        margin: EdgeInsets.only(bottom: 18.h),
                                        decoration: BoxDecoration(
                                            color: Pallete.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Pallete.greey,
                                                  blurRadius: 2,
                                                  offset: Offset(3, 3)),
                                            ]),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  task.taskName,
                                                  style: TextStyle(
                                                    color: Pallete.blackish,
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    ref
                                                        .read(
                                                            taskProjectControllerProvider
                                                                .notifier)
                                                        .updateTaskStatusProgress(
                                                            context,
                                                            task.taskName);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 7.w,
                                                            vertical: 5.h),
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.r)),
                                                    child: Text(
                                                      'Remove ?',
                                                      style: TextStyle(
                                                        color:
                                                            Pallete.whiteColor,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            20.sbH,
                                            ref
                                                .watch(getUserProvider(
                                                    task.employeeId))
                                                .when(
                                                  data: (employee) {
                                                    return Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: RichText(
                                                        textAlign:
                                                            TextAlign.start,
                                                        text: TextSpan(
                                                          text: 'Assigned to: ',
                                                          style: TextStyle(
                                                            color: Pallete
                                                                .textGrey,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: employee
                                                                  .firstName,
                                                              style: TextStyle(
                                                                color: Pallete
                                                                    .blackColor,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  error: (error, stackTrace) =>
                                                      ErrorText(
                                                          error:
                                                              error.toString()),
                                                  loading: () => const Loader(),
                                                ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                error: (error, stackTrace) =>
                                    ErrorText(error: error.toString()),
                                loading: () => const Loader(),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
