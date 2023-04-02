import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/tasks_projects/controllers/task_project_controller.dart';
import 'package:stark/features/tasks_projects/views/task_creation_bottom_sheet.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/app_bar.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/widget_extensions.dart';

class TasksView extends ConsumerStatefulWidget {
  const TasksView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TasksViewState();
}

class _TasksViewState extends ConsumerState<TasksView> {
  final ValueNotifier<int> selected = ValueNotifier(0);
  final PageController _controller = PageController();

  //! navigate
  void navigateToCreateProject(BuildContext context) {
    Routemaster.of(context).push('/create-project');
  }

  void navigateToProject(BuildContext context, String projectName) {
    Routemaster.of(context).push('/project/$projectName');
  }

  String _calculateDaysRemaining(DateTime futureDate) {
    Duration difference = futureDate.difference(DateTime.now());
    int days = difference.inDays;
    if (days <= 0) {
      return 'Overdue';
    }
    return '$days days left';
  }

  int getNumberOfTasksDone(tasks) {
    return tasks.where((task) => task.status == 'done').length;
  }

  int getNumberOfProjectsDoneNumber(projects) {
    return projects.where((project) => project.status == 'done').length;
  }

  int getNumberOfTProjectsProgressNumber(projects) {
    return projects.where((project) => project.status == 'ongoing').length;
  }

  @override
  Widget build(BuildContext context) {
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
              ValueListenableBuilder(
                  valueListenable: selected,
                  child: const SizedBox.shrink(),
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: Row(
                            children: [
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
                                  'Ongoing Projects',
                                  style: TextStyle(
                                    color: selected.value == 0
                                        ? Pallete.newblueColor
                                        : Pallete.greey,
                                    fontSize:
                                        selected.value == 0 ? 27.sp : 20.sp,
                                    fontWeight: selected.value == 0
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                              10.sbW,
                              InkWell(
                                onTap: () => navigateToCreateProject(context),
                                child: CircleAvatar(
                                  radius: 15.w,
                                  backgroundColor: Pallete.primaryGreen,
                                  child: const Icon(
                                    Icons.add,
                                    color: Pallete.whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        15.sbH,
                        Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: Row(
                            children: [
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
                                  'Completed Projects',
                                  style: TextStyle(
                                    color: selected.value == 1
                                        ? Pallete.newblueColor
                                        : Pallete.greey,
                                    fontSize:
                                        selected.value == 1 ? 27.sp : 20.sp,
                                    fontWeight: selected.value == 1
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),

              //! the projects
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
                    //! ongoing projects
                    projectsStream.when(
                      data: (projectss) {
                        int notDone =
                            getNumberOfTProjectsProgressNumber(projectss);
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
                          padding: EdgeInsets.symmetric(horizontal: 22.w)
                              .copyWith(top: 20.h),
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            final random = Random();
                            final color = Color.fromRGBO(
                              random.nextInt(200), // red component
                              random.nextInt(200), // green component
                              random.nextInt(200), // blue component
                              1, // opacity
                            );
                            final projectt = projects[index];
                            if (projectt.status == 'ongoing') {
                              return InkWell(
                                onTap: () =>
                                    navigateToProject(context, projectt.name),
                                child: Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  .format(
                                                      projectt.startDateTime),
                                              style: TextStyle(
                                                color: Colors.green,
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
                                              width: 280.w,
                                              decoration: BoxDecoration(
                                                  color: Pallete.greey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r)),
                                            ),
                                            //! indicator
                                            if (projectt.taskIds.isNotEmpty)
                                            Consumer(
                                                child: const SizedBox.shrink(),
                                                builder: (context, ref, child) {
                                                  return ref
                                                      .watch(
                                                          getTasksInProjectProvider(
                                                              projectt.name))
                                                      .when(
                                                        data: (tasks) {
                                                          int totalTasks =
                                                              tasks.length;
                                                          final numberOfTasksDone =
                                                              getNumberOfTasksDone(
                                                                  tasks);

                                                          double percentage =
                                                              (numberOfTasksDone /
                                                                      totalTasks) *
                                                                  100;
                                                          int percent =
                                                              percentage
                                                                  .toInt();
                                                          
                                                          

                                                          return Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Container(
                                                              height: 10.h,
                                                              width: (numberOfTasksDone /
                                                                      totalTasks) *
                                                                  280.h,
                                                              decoration: BoxDecoration(
                                                                  color: color,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.r)),
                                                            ),
                                                          );
                                                        },
                                                        error: (error,
                                                                stackTrace) =>
                                                            ErrorText(
                                                                error: error
                                                                    .toString()),
                                                        loading: () =>
                                                            const Loader(),
                                                      );
                                                }),
                                          ],
                                        ),
                                      ),

                                      10.sbH,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Progress',
                                            style: TextStyle(
                                              color: Pallete.newblueColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          //! percentage
                                          if (projectt.taskIds.isNotEmpty)
                                          Consumer(
                                              child: const SizedBox.shrink(),
                                              builder: (context, ref, child) {
                                                return ref
                                                    .watch(
                                                        getTasksInProjectProvider(
                                                            projectt.name))
                                                    .when(
                                                      data: (tasks) {
                                                        int totalTasks =
                                                            tasks.length;
                                                        final numberOfTasksDone =
                                                            getNumberOfTasksDone(
                                                                tasks);

                                                        double percentage =
                                                            (numberOfTasksDone /
                                                                    totalTasks) *
                                                                100;
                                                        int percent =
                                                            percentage.toInt();

                                                        return Text(
                                                          '${percent}%',
                                                          style: TextStyle(
                                                            color: Pallete
                                                                .newblueColor,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        );
                                                      },
                                                      error: (error,
                                                              stackTrace) =>
                                                          ErrorText(
                                                              error: error
                                                                  .toString()),
                                                      loading: () =>
                                                          const Loader(),
                                                    );
                                              }),
                                        ],
                                      ),
                                      const Spacer(),
                                      const Divider(
                                        color: Pallete.greyColor,
                                      ),
                                      10.sbH,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //! the stack holding the avatars
                                          if (projectt.employeeIds.isEmpty)
                                            30.sbH,

                                          if (projectt.employeeIds.length == 1)
                                            SizedBox(
                                              height: 30.h,
                                              width: 65.w,
                                              child: Stack(
                                                children: [
                                                  ref
                                                      .watch(getUserProvider(
                                                          projectt
                                                              .employeeIds[0]))
                                                      .when(
                                                        data: (data) {
                                                          return CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: 15.h,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              radius: 13.h,
                                                              backgroundImage:
                                                                  NetworkImage(data
                                                                      .profilePic),
                                                            ),
                                                          );
                                                        },
                                                        error: (error,
                                                                stackTrace) =>
                                                            ErrorText(
                                                                error: error
                                                                    .toString()),
                                                        loading: () =>
                                                            const Loader(),
                                                      ),
                                                ],
                                              ),
                                            ),

                                          if (projectt.employeeIds.length == 2)
                                            SizedBox(
                                              height: 30.h,
                                              width: 65.w,
                                              child: Stack(
                                                children: [
                                                  ref
                                                      .watch(getUserProvider(
                                                          projectt
                                                              .employeeIds[0]))
                                                      .when(
                                                        data: (data) {
                                                          return CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: 15.h,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              radius: 13.h,
                                                              backgroundImage:
                                                                  NetworkImage(data
                                                                      .profilePic),
                                                            ),
                                                          );
                                                        },
                                                        error: (error,
                                                                stackTrace) =>
                                                            ErrorText(
                                                                error: error
                                                                    .toString()),
                                                        loading: () =>
                                                            const Loader(),
                                                      ),
                                                  Positioned(
                                                    left: 15.w,
                                                    child: ref
                                                        .watch(getUserProvider(
                                                            projectt
                                                                .employeeIds[1]))
                                                        .when(
                                                          data: (data) {
                                                            return CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              radius: 15.h,
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                radius: 13.h,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        data.profilePic),
                                                              ),
                                                            );
                                                          },
                                                          error: (error,
                                                                  stackTrace) =>
                                                              ErrorText(
                                                                  error: error
                                                                      .toString()),
                                                          loading: () =>
                                                              const Loader(),
                                                        ),
                                                  ),
                                                  // Positioned(
                                                  //   left: 30.w,
                                                  //   child: CircleAvatar(
                                                  //     backgroundColor: Colors.white,
                                                  //     radius: 15.h,
                                                  //     child: CircleAvatar(
                                                  //       backgroundColor: Colors.blue,
                                                  //       radius: 13.h,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          if (projectt.employeeIds.length > 2)
                                            SizedBox(
                                              height: 30.h,
                                              width: 65.w,
                                              child: Stack(
                                                children: [
                                                  ref
                                                      .watch(getUserProvider(
                                                          projectt
                                                              .employeeIds[0]))
                                                      .when(
                                                        data: (data) {
                                                          return CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: 15.h,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              radius: 13.h,
                                                              backgroundImage:
                                                                  NetworkImage(data
                                                                      .profilePic),
                                                            ),
                                                          );
                                                        },
                                                        error: (error,
                                                                stackTrace) =>
                                                            ErrorText(
                                                                error: error
                                                                    .toString()),
                                                        loading: () =>
                                                            const Loader(),
                                                      ),
                                                  Positioned(
                                                    left: 15.w,
                                                    child: ref
                                                        .watch(getUserProvider(
                                                            projectt
                                                                .employeeIds[1]))
                                                        .when(
                                                          data: (data) {
                                                            return CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              radius: 15.h,
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                radius: 13.h,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        data.profilePic),
                                                              ),
                                                            );
                                                          },
                                                          error: (error,
                                                                  stackTrace) =>
                                                              ErrorText(
                                                                  error: error
                                                                      .toString()),
                                                          loading: () =>
                                                              const Loader(),
                                                        ),
                                                  ),
                                                  Positioned(
                                                    left: 30.w,
                                                    child: ref
                                                        .watch(getUserProvider(
                                                            projectt
                                                                .employeeIds[2]))
                                                        .when(
                                                          data: (data) {
                                                            return CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              radius: 15.h,
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                radius: 13.h,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        data.profilePic),
                                                              ),
                                                            );
                                                          },
                                                          error: (error,
                                                                  stackTrace) =>
                                                              ErrorText(
                                                                  error: error
                                                                      .toString()),
                                                          loading: () =>
                                                              const Loader(),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          BButton(
                                            width: 40.w,
                                            height: 30.h,
                                            radius: 10.r,
                                            color: color,
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (context) => Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: Wrap(
                                                    children: [
                                                      TaskCreationBottomSheet(
                                                        projectName:
                                                            projectt.name,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            isText: false,
                                            item: const Icon(Icons.add),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w,
                                                vertical: 5.h),
                                            decoration: BoxDecoration(
                                                color: _calculateDaysRemaining(
                                                          projectt.endDateTime,
                                                        ) ==
                                                        'Overdue'
                                                    ? Pallete.thickRed
                                                    : color.withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.r)),
                                            child: Text(
                                              _calculateDaysRemaining(
                                                projectt.endDateTime,
                                              ),
                                              style: TextStyle(
                                                color: _calculateDaysRemaining(
                                                          projectt.endDateTime,
                                                        ) ==
                                                        'Overdue'
                                                    ? Pallete.whiteColor
                                                    : color,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return const SizedBox();
                          },
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    ),

                    //! DONE PROJECTS
                    projectsStream.when(
                      data: (projectss) {
                        int done = getNumberOfProjectsDoneNumber(projectss);
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
                          padding: EdgeInsets.symmetric(horizontal: 22.w)
                              .copyWith(top: 20.h),
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            final random = Random();
                            final color = Color.fromRGBO(
                              random.nextInt(200), // red component
                              random.nextInt(200), // green component
                              random.nextInt(200), // blue component
                              1, // opacity
                            );
                            final projectt = projects[index];
                            if (projectt.status == 'done') {
                              return InkWell(
                                // onTap: () =>
                                //     navigateToProject(context, projectt.name),
                                child: Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  .format(
                                                      projectt.startDateTime),
                                              style: TextStyle(
                                                color: Colors.green,
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
                                              width: 280.w,
                                              decoration: BoxDecoration(
                                                  color: Pallete.greey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r)),
                                            ),
                                            //! indicator
                                            Consumer(
                                                child: const SizedBox.shrink(),
                                                builder: (context, ref, child) {
                                                  return ref
                                                      .watch(
                                                          getTasksInProjectProvider(
                                                              projectt.name))
                                                      .when(
                                                        data: (tasks) {
                                                          int totalTasks =
                                                              tasks.length;
                                                          final numberOfTasksDone =
                                                              getNumberOfTasksDone(
                                                                  tasks);

                                                          double percentage =
                                                              (numberOfTasksDone /
                                                                      totalTasks) *
                                                                  100;
                                                          int percent =
                                                              percentage
                                                                  .toInt();

                                                          return Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Container(
                                                              height: 10.h,
                                                              width: (numberOfTasksDone /
                                                                      totalTasks) *
                                                                  280.h,
                                                              decoration: BoxDecoration(
                                                                  color: color,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.r)),
                                                            ),
                                                          );
                                                        },
                                                        error: (error,
                                                                stackTrace) =>
                                                            ErrorText(
                                                                error: error
                                                                    .toString()),
                                                        loading: () =>
                                                            const Loader(),
                                                      );
                                                }),
                                          ],
                                        ),
                                      ),

                                      10.sbH,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Progress',
                                            style: TextStyle(
                                              color: Pallete.newblueColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          //! percentage
                                          Consumer(
                                              child: const SizedBox.shrink(),
                                              builder: (context, ref, child) {
                                                return ref
                                                    .watch(
                                                        getTasksInProjectProvider(
                                                            projectt.name))
                                                    .when(
                                                      data: (tasks) {
                                                        int totalTasks =
                                                            tasks.length;
                                                        final numberOfTasksDone =
                                                            getNumberOfTasksDone(
                                                                tasks);

                                                        double percentage =
                                                            (numberOfTasksDone /
                                                                    totalTasks) *
                                                                100;
                                                        int percent =
                                                            percentage.toInt();

                                                        return Text(
                                                          '${percent}%',
                                                          style: TextStyle(
                                                            color: Pallete
                                                                .newblueColor,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        );
                                                      },
                                                      error: (error,
                                                              stackTrace) =>
                                                          ErrorText(
                                                              error: error
                                                                  .toString()),
                                                      loading: () =>
                                                          const Loader(),
                                                    );
                                              }),
                                        ],
                                      ),
                                      const Spacer(),
                                      const Divider(
                                        color: Pallete.greyColor,
                                      ),
                                      10.sbH,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //! the stack holding the avatars
                                          if (projectt.employeeIds.isEmpty)
                                            30.sbH,

                                          if (projectt.employeeIds.length == 1)
                                            SizedBox(
                                              height: 30.h,
                                              width: 65.w,
                                              child: Stack(
                                                children: [
                                                  ref
                                                      .watch(getUserProvider(
                                                          projectt
                                                              .employeeIds[0]))
                                                      .when(
                                                        data: (data) {
                                                          return CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: 15.h,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              radius: 13.h,
                                                              backgroundImage:
                                                                  NetworkImage(data
                                                                      .profilePic),
                                                            ),
                                                          );
                                                        },
                                                        error: (error,
                                                                stackTrace) =>
                                                            ErrorText(
                                                                error: error
                                                                    .toString()),
                                                        loading: () =>
                                                            const Loader(),
                                                      ),
                                                ],
                                              ),
                                            ),

                                          if (projectt.employeeIds.length == 2)
                                            SizedBox(
                                              height: 30.h,
                                              width: 65.w,
                                              child: Stack(
                                                children: [
                                                  ref
                                                      .watch(getUserProvider(
                                                          projectt
                                                              .employeeIds[0]))
                                                      .when(
                                                        data: (data) {
                                                          return CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: 15.h,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              radius: 13.h,
                                                              backgroundImage:
                                                                  NetworkImage(data
                                                                      .profilePic),
                                                            ),
                                                          );
                                                        },
                                                        error: (error,
                                                                stackTrace) =>
                                                            ErrorText(
                                                                error: error
                                                                    .toString()),
                                                        loading: () =>
                                                            const Loader(),
                                                      ),
                                                  Positioned(
                                                    left: 15.w,
                                                    child: ref
                                                        .watch(getUserProvider(
                                                            projectt
                                                                .employeeIds[1]))
                                                        .when(
                                                          data: (data) {
                                                            return CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              radius: 15.h,
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                radius: 13.h,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        data.profilePic),
                                                              ),
                                                            );
                                                          },
                                                          error: (error,
                                                                  stackTrace) =>
                                                              ErrorText(
                                                                  error: error
                                                                      .toString()),
                                                          loading: () =>
                                                              const Loader(),
                                                        ),
                                                  ),
                                                  // Positioned(
                                                  //   left: 30.w,
                                                  //   child: CircleAvatar(
                                                  //     backgroundColor: Colors.white,
                                                  //     radius: 15.h,
                                                  //     child: CircleAvatar(
                                                  //       backgroundColor: Colors.blue,
                                                  //       radius: 13.h,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          if (projectt.employeeIds.length > 2)
                                            SizedBox(
                                              height: 30.h,
                                              width: 65.w,
                                              child: Stack(
                                                children: [
                                                  ref
                                                      .watch(getUserProvider(
                                                          projectt
                                                              .employeeIds[0]))
                                                      .when(
                                                        data: (data) {
                                                          return CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: 15.h,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              radius: 13.h,
                                                              backgroundImage:
                                                                  NetworkImage(data
                                                                      .profilePic),
                                                            ),
                                                          );
                                                        },
                                                        error: (error,
                                                                stackTrace) =>
                                                            ErrorText(
                                                                error: error
                                                                    .toString()),
                                                        loading: () =>
                                                            const Loader(),
                                                      ),
                                                  Positioned(
                                                    left: 15.w,
                                                    child: ref
                                                        .watch(getUserProvider(
                                                            projectt
                                                                .employeeIds[1]))
                                                        .when(
                                                          data: (data) {
                                                            return CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              radius: 15.h,
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                radius: 13.h,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        data.profilePic),
                                                              ),
                                                            );
                                                          },
                                                          error: (error,
                                                                  stackTrace) =>
                                                              ErrorText(
                                                                  error: error
                                                                      .toString()),
                                                          loading: () =>
                                                              const Loader(),
                                                        ),
                                                  ),
                                                  Positioned(
                                                    left: 30.w,
                                                    child: ref
                                                        .watch(getUserProvider(
                                                            projectt
                                                                .employeeIds[2]))
                                                        .when(
                                                          data: (data) {
                                                            return CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              radius: 15.h,
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                radius: 13.h,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        data.profilePic),
                                                              ),
                                                            );
                                                          },
                                                          error: (error,
                                                                  stackTrace) =>
                                                              ErrorText(
                                                                  error: error
                                                                      .toString()),
                                                          loading: () =>
                                                              const Loader(),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          BButton(
                                            width: 100.w,
                                            height: 30.h,
                                            radius: 10.r,
                                            color: Pallete.thickRed,
                                            onTap: () {
                                              ref
                                                  .read(
                                                      taskProjectControllerProvider
                                                          .notifier)
                                                  .updateProjectStatusProgress(
                                                      context, projectt.name);
                                            },
                                            isText: false,
                                            item: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.remove_circle_outline,
                                                    size: 18.sp,
                                                  ),
                                                  Text(
                                                    'Remove',
                                                    style: TextStyle(
                                                      color: Pallete.whiteColor,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w,
                                                vertical: 5.h),
                                            decoration: BoxDecoration(
                                                color: color.withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.r)),
                                            child: Text(
                                              'Completed',
                                              style: TextStyle(
                                                color: color,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return const SizedBox();
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
          );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}
