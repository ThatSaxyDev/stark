import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/employee/views/invite_employees_search_delegate.dart';
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
        data: (organisations) => organisations.isEmpty
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
            : Center(
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
              ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}
