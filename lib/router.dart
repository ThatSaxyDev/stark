import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/features/attendance/views/mark_attendance_view.dart';
import 'package:stark/features/auth/views/login_view.dart';
import 'package:stark/features/auth/views/sign_up_view.dart';
import 'package:stark/features/auth/views/user_type_view.dart';
import 'package:stark/features/base_drawer_wrapper/views/base_drawer_wrapper.dart';
import 'package:stark/features/base_drawer_wrapper/views/employee_base_drawer_wrapper.dart';
import 'package:stark/features/organisation/views/create_organisation_view.dart';
import 'package:stark/features/profile/views/edit_profile_view.dart';
import 'package:stark/features/tasks_projects/views/create_project_view.dart';
import 'package:stark/features/tasks_projects/views/project_view.dart';
import 'package:stark/features/tasks_projects/views/task_creation_bottom_sheet.dart';

//! these routes would be desplayed when the user is logged out
final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: SelectUserTypeView(),
        ),
    '/sign-up/:type': (routeData) => MaterialPage(
          child: SignUpView(
            type: routeData.pathParameters['type']!,
          ),
        ),
    '/login': (_) => const MaterialPage(
          child: LoginView(),
        ),
  },
);

//! these routes would be displayed when the user is logged in as an admin/manager
final adminLoggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: BaseDrawerWrapper(),
        ),
    '/create-organisation': (_) => const MaterialPage(
          child: CreateOrganisationView(),
        ),
    '/mark-attendance': (_) => const MaterialPage(
          child: MarkAttendanceView(),
        ),
    '/project/:name': (routeData) => MaterialPage(
          child: ProjectView(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/create-project': (_) => const MaterialPage(
          child: CreateProjectView(),
        ),
    '/edit-profile': (_) => const MaterialPage(
          child: EditProfileView(),
        ),
  },
  onUnknownRoute: (path) => const MaterialPage(
    child: BaseDrawerWrapper(),
  ),
);

//! these routes would be displayed when the user is logged in as an employee
final employeeLoggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: EmployeeBaseDrawerWrapper(),
        ),
    '/edit-profile': (_) => const MaterialPage(
          child: EditProfileView(),
        ),
    '/project/:name': (routeData) => MaterialPage(
          child: ProjectView(
            name: routeData.pathParameters['name']!,
          ),
        ),
  },
  onUnknownRoute: (path) => const MaterialPage(
    child: EmployeeBaseDrawerWrapper(),
  ),
);
