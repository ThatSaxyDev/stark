import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/employee/controllers/employee_controller.dart';
import 'package:stark/features/organisation/controllers/organisation_controller.dart';
import 'package:stark/features/tasks_projects/controllers/task_project_controller.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/app_bar.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';

class EmployeeTaskView extends ConsumerStatefulWidget {
  const EmployeeTaskView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmployeeTaskViewState();
}

class _EmployeeTaskViewState extends ConsumerState<EmployeeTaskView> {
  
  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(userProvider)!;
    final organisationsStream = ref.watch(getEmployeeOrganisationsProvider);
    // final projectsStream = ref.watch(getProjectsForEmployeesProvider);
    final tasksStream = ref.watch(getTasksForEmployeesProvider);
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Tasks',
      ),
      body: organisationsStream.when(
        data: (organisations) {
          if (organisations.isEmpty) {
            return Center(
              child: Text(
                'You do not belong to any organisation, kindly contact your administrator',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Pallete.blackish,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }
          // return const ErrorText(error: 'E dey org!');
          return tasksStream.when(
            data: (tasks) {
              log(tasks.toString());
              if (tasks.isEmpty) {
                return Center(
                  child: Text(
                    'You have no ongoing tasks',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Pallete.blackish,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }

              return const ErrorText(error: 'E dey!');
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}
