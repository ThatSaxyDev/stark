// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/employee/controllers/employee_controller.dart';
import 'package:stark/features/organisation/controllers/organisation_controller.dart';
import 'package:stark/features/tasks_projects/controllers/task_project_controller.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/picker.dart';
import 'package:stark/utils/string_extensions.dart';
import 'package:stark/utils/widget_extensions.dart';

class TaskCreationBottomSheet extends ConsumerStatefulWidget {
  final String projectName;
  const TaskCreationBottomSheet({
    super.key,
    required this.projectName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TaskCreationBottomSheetState();
}

class _TaskCreationBottomSheetState
    extends ConsumerState<TaskCreationBottomSheet> {
  ValueNotifier<int> selectedEmployeeIndex = ValueNotifier(0);
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  ValueNotifier<String> selectedEmployeeId = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    final employeesStream = ref.watch(getEmployeesProvider);
    final isLoading = ref.watch(taskProjectControllerProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 2500),
      padding: EdgeInsets.symmetric(horizontal: 20.w).copyWith(top: 15.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Pallete.whiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.r),
        ),
      ),
      child: employeesStream.when(
        data: (employees) {
          selectedEmployeeId.value = employees[selectedEmployeeIndex.value].uid;
          return SingleChildScrollView(
            child: Column(
              children: [
                //! create task, close
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    24.sbH,
                    Row(
                      children: [
                        SvgPicture.asset('send'.svg),
                        11.sbW,
                        Text(
                          'Create Task',
                          style: TextStyle(
                              color: Pallete.blackTint,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => Routemaster.of(context).pop(),
                      child: Container(
                        color: Colors.transparent,
                        height: 24.h,
                        width: 24.w,
                        child: Icon(
                          PhosphorIcons.x,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                34.sbH,
                //! PROJECT NAME
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Project: ',
                          style: TextStyle(
                              color: Pallete.blackTint,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      12.sbH,
                      Text(
                        widget.projectName,
                        style: TextStyle(
                            color: Pallete.blackTint,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                12.sbH,
                //! inputs
                //! employee
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Employee',
                    style: TextStyle(
                        color: Pallete.blackTint,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                12.sbH,
                //! employee select
                ValueListenableBuilder(
                  valueListenable: selectedEmployeeIndex,
                  child: const SizedBox.shrink(),
                  builder: (context, value, child) {
                    return InkWell(
                      onTap: () => showPicker(
                        context,
                        CupertinoPicker(
                          scrollController: FixedExtentScrollController(
                              initialItem: selectedEmployeeIndex.value),
                          magnification: 1,
                          squeeze: 1.2,
                          useMagnifier: false,
                          itemExtent: 32,
                          onSelectedItemChanged: (int selectedEmployee) {
                            // setState(() {
                            selectedEmployeeIndex.value = selectedEmployee;
                            log('${selectedEmployeeId.value} 1');
                            selectedEmployeeId.value =
                                employees[selectedEmployeeIndex.value].uid;
          
                            // });
                          },
                          children: List<Widget>.generate(
                            employees.length,
                            (index) => Text(
                              '${employees[index].firstName} ${employees[index].lastName}',
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 7.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: Pallete.blueColor,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Center(
                          child: Wrap(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${employees[selectedEmployeeIndex.value].firstName} ${employees[selectedEmployeeIndex.value].lastName}',
                                style: TextStyle(
                                  color: Pallete.whiteColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              10.sbW,
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Pallete.whiteColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                20.sbH,
                //! task name input
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Task Name',
                    style: TextStyle(
                        color: Pallete.blackTint,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                12.sbH,
                TextField(
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.deny(RegExp(' '))
                  // ],
                  controller: _taskNameController,
                  // onChanged: (value) {
                  //   _nameController.value = TextEditingValue(
                  //       text: value.toLowerCase(),
                  //       selection: _nameController.selection);
                  // },
                  decoration: InputDecoration(
                      hintText: 'Task Name',
                      hintStyle: TextStyle(fontSize: 15.sp),
                      filled: true,
                      fillColor: Pallete.greey.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      contentPadding: EdgeInsets.all(18.w)),
                  maxLength: 21,
                ),
                20.sbH,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Task Description',
                    style: TextStyle(
                        color: Pallete.blackTint,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                12.sbH,
          
                //! description
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      hintText: 'Type something...',
                      hintStyle: TextStyle(fontSize: 14.sp),
                      filled: true,
                      fillColor: Pallete.greey.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      contentPadding: EdgeInsets.all(18.w)),
                  // maxLength: 21,
                  maxLines: 7,
                ),
          
                // //!
                50.sbH,
                isLoading
                    ? const Loader()
                    : BButton(
                        onTap: () {
                          if (_taskNameController.text.isNotEmpty ||
                              _descriptionController.text.isNotEmpty) {
                            ref
                                .read(taskProjectControllerProvider.notifier)
                                .createTask(
                                  context: context,
                                  taskName: _taskNameController.text,
                                  projectName: widget.projectName,
                                  employeeId: selectedEmployeeId.value,
                                  description: _descriptionController.text,
                                );
                          }
                        },
                        width: 200.w,
                        text: 'Add Task',
                      ),
                60.sbH,
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

// ref.watch(getUserProvider(employeeUid))
