import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stark/features/tasks_projects/controllers/task_project_controller.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/picker.dart';
import 'package:stark/utils/widget_extensions.dart';

class CreateProjectView extends ConsumerStatefulWidget {
  const CreateProjectView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateProjectViewState();
}

class _CreateProjectViewState extends ConsumerState<CreateProjectView> {
  final TextEditingController _projectNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
//!
  void createProject(String projectName, DateTime endDateTime) {
    ref.read(taskProjectControllerProvider.notifier).createProject(
          context: context,
          name: projectName,
          endDateTime: endDateTime,
        );
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(taskProjectControllerProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Pallete.blackTint,
        title: Text(
          'Create Project',
          style: TextStyle(
              color: Pallete.blackish,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: 24.padH,
              child: Column(
                children: [
                  20.sbH,
                  //! name
                  TextField(
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.deny(RegExp(' '))
                    // ],
                    controller: _projectNameController,
                    // onChanged: (value) {
                    //   _nameController.value = TextEditingValue(
                    //       text: value.toLowerCase(),
                    //       selection: _nameController.selection);
                    // },
                    decoration: InputDecoration(
                        hintText: 'Project Name',
                        hintStyle: TextStyle(fontSize: 15.sp),
                        filled: true,
                        fillColor: Pallete.greey.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        contentPadding: EdgeInsets.all(18.w)),
                    maxLength: 21,
                  ),
                  20.sbH,

                  //! pick end date
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'When does this project end?',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  10.sbH,
                  InkWell(
                    onTap: () => showPicker(
                      context,
                      CupertinoDatePicker(
                        initialDateTime: _selectedDate,
                        mode: CupertinoDatePickerMode.dateAndTime,
                        use24hFormat: true,
                        // This is called when the user changes the time.
                        onDateTimeChanged: (DateTime newTime) {
                          setState(() => _selectedDate = newTime);
                        },
                      ),
                    ),
                    child: Container(
                      height: 56.h,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      decoration: BoxDecoration(
                        color: Pallete.greey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}  ${_selectedDate.hour}:${_selectedDate.minute}',
                            '${DateFormat.yMMMEd().format(_selectedDate)} : ${DateFormat.jm().format(_selectedDate)}',
                            style: TextStyle(
                                color: Pallete.blackTint,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          const Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Pallete.blackTint,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  BButton(
                    width: 300.w,
                    onTap: () {
                      if (_projectNameController.text.isNotEmpty) {
                        createProject(
                          _projectNameController.text,
                          _selectedDate,
                        );
                      }
                    },
                    text: 'Create',
                  ),
                  50.sbH,
                ],
              ),
            ),
    );
  }
}
