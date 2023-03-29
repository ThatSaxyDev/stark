import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/app_bar.dart';

class EmployeeTaskView extends ConsumerStatefulWidget {
  const EmployeeTaskView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmployeeTaskViewState();
}

class _EmployeeTaskViewState extends ConsumerState<EmployeeTaskView> {

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Tasks',
      ),
      body: Center(
        child: Text(
          'You do not belong to any organisation, kindly contact your administrator',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Pallete.blackish,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}