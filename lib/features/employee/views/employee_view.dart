import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/employee/views/invite_employees_search_delegate.dart';
import 'package:stark/features/employee/widgets/employee_card.dart';
import 'package:stark/features/organisation/controllers/organisation_controller.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/app_bar.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/string_extensions.dart';
import 'package:stark/utils/widget_extensions.dart';
import 'package:unicons/unicons.dart';

class EmployeeView extends ConsumerWidget {
  const EmployeeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! navigation
    //! navigation
    void navigateToCreateOrg(BuildContext context) {
      Routemaster.of(context).push('/create-organisation');
    }

    final user = ref.watch(userProvider)!;
    final organisationsStream = ref.watch(getManagerOrganisationsProvider);

    return Scaffold(
      appBar: const MyAppBar(
        title: 'Employees',
      ),
      body: organisationsStream.when(
        data: (organisations) {
          if (organisations.isEmpty) {
            return Center(
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
            );
          }
          //
          return organisations[0].employees.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Invite your employees to ${organisations[0].name.toUpperCase()}',
                        style: TextStyle(
                          color: Pallete.blackTint,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      20.sbH,
                      BButton(
                        onTap: () {
                          showSearch(
                              context: context,
                              delegate: InviteEmployeesSearchDelegate(ref));
                        },
                        width: 300.w,
                        text: '+ Invite',
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Column(
                    children: [
                      15.sbH,
                      //! search box
                      Container(
                        height: 50.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                            color: Pallete.whiteColor,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: Pallete.greey)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Search...',
                                style: TextStyle(
                                  color: Pallete.greey,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Icon(
                                PhosphorIcons.magnifyingGlass,
                                color: Pallete.greey,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                      24.sbH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            organisations[0].employees.length == 1
                                ? '${organisations[0].employees.length.toString()} employee'
                                : '${organisations[0].employees.length.toString()} employees',
                            style: TextStyle(
                              color: Pallete.blackTint,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showSearch(
                                  context: context,
                                  delegate: InviteEmployeesSearchDelegate(ref));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: Pallete.primaryGreen,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Text(
                                '+ Add Employee',
                                style: TextStyle(
                                  color: Pallete.whiteColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          itemCount: organisations[0].employees.length,
                          itemBuilder: (context, index) {
                            return EmployeeCard(
                              employeeUid: organisations[0].employees[index],
                            );
                          },
                        ),
                      ),
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
