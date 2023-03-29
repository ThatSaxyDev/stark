import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
            ],
          );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}
