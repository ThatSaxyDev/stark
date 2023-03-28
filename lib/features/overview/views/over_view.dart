import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/organisation/controllers/organisation_controller.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/app_bar.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/widget_extensions.dart';

class OverView extends ConsumerStatefulWidget {
  const OverView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OverViewState();
}

class _OverViewState extends ConsumerState<OverView> {
  DateTime todaysDate = DateTime.now();

  //! navigation
  void navigateToCreateOrg(BuildContext context) {
    Routemaster.of(context).push('/create-organisation');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final organisationsStream = ref.watch(getManagerOrganisationsProvider);
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Overview',
      ),
      body: organisationsStream.when(
        data: (organisations) => organisations.isEmpty
            //! if you dont have an organisation
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You don\'t have an organisation',
                      style: TextStyle(
                        color: Pallete.blackTint,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    20.sbH,
                    BButton(
                      onTap: () => navigateToCreateOrg(context),
                      width: 300.w,
                      text: '+ Create one',
                    ),
                  ],
                ),
              )
            : //! when an orgaisation has been created
            Column(
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
                        DateFormat.yMMMMEEEEd().format(todaysDate),
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
              ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}
