// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stark/features/employee/controllers/employee_controller.dart';
import 'package:stark/features/organisation/controllers/organisation_controller.dart';

import 'package:stark/theme/palette.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/widget_extensions.dart';

class InviteEmployeeTile extends ConsumerWidget {
  final String uid;
  final String name;
  final String email;
  final String status;
  final String profilePic;
  final void Function()? onTap;
  const InviteEmployeeTile({
    super.key,
    required this.name,
    required this.email,
    required this.status,
    required this.profilePic,
    this.onTap,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(employeeControllerProvider);
    final organisationsStream = ref.watch(getManagerOrganisationsProvider);
    final invitesStream = ref.watch(getInvitesForManagerProvider);

    void invite(String organisationName) {
      ref.read(employeeControllerProvider.notifier).sendInvite(
            context: context,
            receiverId: uid,
            organisationName: organisationName,
          );
    }

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Pallete.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Pallete.greyColor,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.w,
                backgroundColor: Pallete.greyColor,
                backgroundImage: NetworkImage(profilePic),
              ),
              10.sbW,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Pallete.blackish,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  7.sbH,
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.envelopeFill,
                        size: 16.sp,
                      ),
                      7.sbW,
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          13.sbH,

          //! invite button
          Align(
            alignment: Alignment.centerRight,
            child: organisationsStream.when(
              data: (organisations) {
                return isLoading
                    ? const Loader()
                    : invitesStream.when(
                        data: (invites) => invites.isEmpty
                            ? BButton(
                                height: 30.h,
                                width: 100.w,
                                onTap: () => invite(organisations[0].name),
                                color: Pallete.primaryGreen,
                                text: '+ invite',
                              )
                            : Text(
                                invites[0].status,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      );
              },
              error: (error, stackTrace) {
                log(error.toString());
                return ErrorText(error: error.toString());
              },
              loading: () => const Loader(),
            ),
          ),
        ],
      ),
    );
  }
}
