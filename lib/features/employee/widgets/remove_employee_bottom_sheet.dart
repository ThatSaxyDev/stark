// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stark/features/organisation/controllers/organisation_controller.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/text_input.dart';
import 'package:stark/utils/widget_extensions.dart';

class RemoveEmployeeBottomSheet extends ConsumerStatefulWidget {
  final String employeeFirstName;
  final String orgaName;
  const RemoveEmployeeBottomSheet({
    super.key,
    required this.employeeFirstName,
    required this.orgaName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RemoveEmployeeBottomSheetState();
}

class _RemoveEmployeeBottomSheetState
    extends ConsumerState<RemoveEmployeeBottomSheet> {
  final TextEditingController _nameController = TextEditingController();

  //! remove employee
  void sackEmployee() {
    ref.read(organisationsControllerProvider.notifier).sackEmployee(
          context: context,
          employeeId: widget.employeeFirstName,
          orgName: widget.orgaName,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.h,
      padding: EdgeInsets.only(top: 8.h, right: 24.w, left: 24.w),
      decoration: BoxDecoration(
        color: Pallete.whiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //! bar
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 3.h,
              width: 72.w,
              decoration: BoxDecoration(
                color: Pallete.thickRed,
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
          ),
          20.sbH,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Type ',
                  style: TextStyle(
                    color: Pallete.blackish,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: widget.employeeFirstName,
                  style: TextStyle(
                    color: Pallete.thickRed,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: ' to remove this employee from your organisation.',
                  style: TextStyle(
                    color: Pallete.blackish,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          25.sbH,
          TextInputBox(
            height: 47.h,
            hintText: widget.employeeFirstName,
            controller: _nameController,
            icon: 'password_icon',
          ),

          40.sbH,
          BButton(
            onTap: () {
              if (_nameController.text == widget.employeeFirstName) {
                sackEmployee();
              }
            },
            height: 40.h,
            width: 150.w,
            color: Pallete.thickRed,
            text: 'Remove',
          ),
        ],
      ),
    );
  }
}
