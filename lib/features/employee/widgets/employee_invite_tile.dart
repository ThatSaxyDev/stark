// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stark/core/constants/constants.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/employee/controllers/employee_controller.dart';
import 'package:stark/features/organisation/controllers/organisation_controller.dart';
import 'package:stark/models/invite_model.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/widget_extensions.dart';

class EmployeeInviteTile extends ConsumerWidget {
  final InviteModel invite;
  final void Function()? approve;
  final void Function()? reject;

  const EmployeeInviteTile({
    super.key,
    required this.invite,
    this.approve,
    this.reject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(employeeControllerProvider);
    //!
    final getUser = ref.watch(getUserProvider(invite.managerId));
    final organisationByName =
        ref.watch(getOrganisationByNameProvider(invite.organisationName));

    //! reject invitaion
    void rejectInvite() {
      ref
          .read(employeeControllerProvider.notifier)
          .rejectInvite(invite, context);
    }

    //! accept invite
    void acceptInvite() {
      ref
          .read(employeeControllerProvider.notifier)
          .acceptInvite(invite, context);
    }

    return getUser.when(
      data: (manager) {
        return Container(
          padding: EdgeInsets.all(10.w),
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20.w)
              .copyWith(bottom: 20.h, top: 20.h),
          decoration: BoxDecoration(
            color: Pallete.whiteColor,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: Pallete.greyColor),
          ),
          child: isLoading
              ? const Loader()
              : Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 13.w,
                          backgroundImage: organisationByName.when(
                            data: (org) => NetworkImage(org.avatar),
                            error: (error, stackTrace) => const NetworkImage(
                                Constants.communityAvatarDefault),
                            loading: () => const NetworkImage(
                                Constants.communityAvatarDefault),
                          ),
                        ),
                        10.sbW,
                        Text(
                          invite.organisationName.toUpperCase(),
                          style: TextStyle(
                            color: Pallete.blackish,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        7.sbW,
                        CircleAvatar(
                          radius: 7.w,
                          backgroundColor: Pallete.primaryGreen,
                        ),
                      ],
                    ),
                    10.sbH,
                    Wrap(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${manager.firstName} ${manager.lastName} ',
                                style: TextStyle(
                                  color: Pallete.blackish,
                                  fontSize: 14.sp,
                                  // fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '(${manager.email})',
                                style: TextStyle(
                                  color: Pallete.primaryGreen,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: ' invited you to this organisation on ',
                                style: TextStyle(
                                  color: Pallete.blackish,
                                  fontSize: 14.sp,
                                  // fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: DateFormat.yMMMMEEEEd()
                                    .format(invite.sentAt),
                                style: TextStyle(
                                    color: Pallete.blackish,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    13.sbH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: rejectInvite,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Pallete.thickRed,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Text(
                              'Reject',
                              style: TextStyle(
                                color: Pallete.whiteColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: acceptInvite,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Pallete.primaryGreen,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Text(
                              'Accept',
                              style: TextStyle(
                                color: Pallete.whiteColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
