import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/employee/views/employee_view.dart';
import 'package:stark/features/messaging/views/messaging_view.dart';
import 'package:stark/features/profile/views/profile_view.dart';
import 'package:stark/features/tasks_projects/views/employee_task_view.dart';
import 'package:stark/features/tasks_projects/views/tasks_view.dart';
import 'package:stark/features/overview/views/over_view.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/string_extensions.dart';
import 'package:stark/utils/widget_extensions.dart';

import '../../overview/views/employee_over_view.dart';

class EmployeeBaseDrawerWrapper extends StatelessWidget {
  const EmployeeBaseDrawerWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleHiddenDrawer(
      menu: const Menu(),
      screenSelectedBuilder: (position, controller) {
        Widget? screenCurrent;
        switch (position) {
          case 0:
            screenCurrent = const EmployeeOverView();
            break;
          case 1:
            screenCurrent = const EmployeeTaskView();
            break;
          case 2:
            screenCurrent = const MessagingView();
            break;
          case 9:
            screenCurrent = const ProfileView();
            break;
        }

        return Scaffold(
          body: screenCurrent,
        );
      },
    );
  }
}

class Menu extends ConsumerStatefulWidget {
  const Menu({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late SimpleHiddenDrawerController _controller;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _controller = SimpleHiddenDrawerController.of(context);
    _controller.addListener(() {
      if (_controller.state == MenuState.open) {
        _animationController.forward();
      }

      if (_controller.state == MenuState.closing) {
        _animationController.reverse();
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Material(
      child: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: Colors.cyan,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.maxFinite,
              height: double.maxFinite,
              color: Pallete.primaryGreen,
              // child: Image.network(
              //   'https://wallpaperaccess.com/full/529044.jpg',
              //   fit: BoxFit.cover,
              // ),
            ),
            FadeTransition(
              opacity: _animationController,
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //! name and edit profile
                    InkWell(
                      onTap: () {
                        _controller.setSelectedMenuPosition(9);
                      },
                      child: Container(
                        height: 200.h,
                        width: 239.w,
                        padding: 20.padH,
                        decoration: BoxDecoration(
                          color: Pallete.whiteColor,
                          borderRadius: BorderRadius.only(
                            // bottomLeft: Radius.circular(20.r),
                            bottomRight: Radius.circular(20.r),
                          ),
                        ),
                        child: Row(
                          children: [
                            //! dp
                            CircleAvatar(
                              radius: 20.w,
                              backgroundColor: Pallete.greey,
                              backgroundImage: NetworkImage(user.profilePic),
                            ),
                            21.sbW,
                            //! name edit profile
                            SizedBox(
                              height: 50.h,
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${user.firstName} ${user.lastName}',
                                        style: TextStyle(
                                          color: Pallete.blackTint,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      5.sbH,
                                      InkWell(
                                        onTap: () {},
                                        child: Text(
                                          'View Profile',
                                          style: TextStyle(
                                            color: Pallete.primaryGreen,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 10.sbW,
                    SizedBox(
                      height: 10.h,
                    ),

                    Container(
                      width: 239.w,
                      padding: EdgeInsets.symmetric(vertical: 57.h)
                          .copyWith(left: 16.w),
                      decoration: BoxDecoration(
                        color: Pallete.whiteColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          drawerItems.length,
                          (index) => ListTile(
                            leading:
                                SvgPicture.asset(drawerItems[index].icon.svg),
                            title: Text(drawerItems[index].title),
                            onTap: () {
                              _controller.setSelectedMenuPosition(index);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem {
  final String title;
  final String icon;

  DrawerItem(this.title, this.icon);
}

List<DrawerItem> drawerItems = [
  DrawerItem('Attendance', 'overview'),
  DrawerItem('Tasks', 'task'),
  DrawerItem('Message', 'message'),
  DrawerItem('Leave Request', 'request'),
  DrawerItem('Help center', 'help'),
  // DrawerItem('Settings', 'settings'),
];
