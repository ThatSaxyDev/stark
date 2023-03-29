import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/core/constants/constants.dart';
import 'package:stark/core/providers/storage_repository_provider.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/organisation/repositories/organisation_repository.dart';
import 'package:stark/models/attemdance_model.dart';
import 'package:stark/models/organisation_model.dart';
import 'package:stark/utils/snack_bar.dart';

//! provider to get org by name
final getOrganisationByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(organisationsControllerProvider.notifier)
      .getOrganisationByName(name);
});

//! provider to get attendance
final getAttendanceStreamProvider = StreamProvider((ref) {
  final organisationController =
      ref.watch(organisationsControllerProvider.notifier);
  return organisationController.getAttendanceList();
});

//! get manager organisations provider
final getManagerOrganisationsProvider = StreamProvider((ref) {
  final organisationController =
      ref.watch(organisationsControllerProvider.notifier);
  return organisationController.getManagerOrganisations();
});

//! get employee organisations provider
final getEmployeeOrganisationsProvider = StreamProvider((ref) {
  final organisationController =
      ref.watch(organisationsControllerProvider.notifier);
  return organisationController.getEmployeeOrganisations();
});

//! the organization controller provider
final organisationsControllerProvider =
    StateNotifierProvider<OrganisationController, bool>((ref) {
  final organisationsRepository = ref.watch(organisationsRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return OrganisationController(
    organisationsRepository: organisationsRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

//! organisation state notifier class
class OrganisationController extends StateNotifier<bool> {
  final OrganisationsRepository _organisationsRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  OrganisationController({
    required OrganisationsRepository organisationsRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _organisationsRepository = organisationsRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  // create community
  void createOrganisation(String name, BuildContext context) async {
    state = true;
    final user = _ref.read(userProvider)!;
    OrganisationModel organisation = OrganisationModel(
      id: name,
      name: name,
      avatar: Constants.communityAvatarDefault,
      description: '',
      managers: [user.uid],
      employees: [],
      prospectiveEmployees: [],
    );

    final res = await _organisationsRepository.createOrganisation(organisation);
    state = false;
    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        showSnackBar(context, 'Organisation created successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  //! create attendance instance
  void createAttendance(
    BuildContext context,
  ) async {
    String orgName = '';

    state = true;

    final ress = _ref.watch(getManagerOrganisationsProvider);
    ress.whenData((organisation) => orgName = organisation[0].name);

    AttendanceModel attendance = AttendanceModel(
      timeIn: null,
      status: 'notsigned',
      organisationName: orgName,
      employeeId: '',
    );

    final res =
        await _organisationsRepository.createAttendance(attendance, orgName);

    state = false;

    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        showSnackBar(context, 'Attendance created successfully');
        // Navigate to another page or refresh the current page.
      },
    );
  }

  //! mark attendance
  void markAttendance(BuildContext context, String employeeId) async {
    state = true;
    final res = await _organisationsRepository.markAttendance(employeeId);
    state = false;
    res.fold(
      (l) => showSnackBar(context, 'An error occurred while signing'),
      (r) => showSnackBar(context, 'Signed!'),
    );
  }

  //! get attendance stream
  Stream<List<AttendanceModel>> getAttendanceList() {
    String orgName = '';
    final ress = _ref.watch(getManagerOrganisationsProvider);
    ress.whenData((organisation) => orgName = organisation[0].name);
    return _organisationsRepository.getAttendanceList(orgName);
  }

  //! get manager organisations
  Stream<List<OrganisationModel>> getManagerOrganisations() {
    final uid = _ref.read(userProvider)!.uid;
    return _organisationsRepository.getManagerOrganisations(uid);
  }

  //! get employee organisations
  Stream<List<OrganisationModel>> getEmployeeOrganisations() {
    final uid = _ref.read(userProvider)!.uid;
    return _organisationsRepository.getEmployeeOrganisations(uid);
  }

  //! get an organisation by name
  Stream<OrganisationModel> getOrganisationByName(String name) {
    return _organisationsRepository.getOrganisationByName(name);
  }

  //! sack employee
  void sackEmployee(
      {required BuildContext context,
      required String employeeId,
      required String orgName}) async {
    // String orgName = '';
    state = true;
    // final ress = _ref.watch(getManagerOrganisationsProvider);
    // ress.whenData((organisation) => orgName = organisation[0].name);

    final res = await _organisationsRepository.sackEmployee(
        organisationName: orgName, employeeId: employeeId);
    state = false;

    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        showSnackBar(context, 'Sacked!');
        Routemaster.of(context).pop();
      },
    );
  }

  // //! approve application to create community
  // void approveApplication(
  //     BuildContext context, ApplicationModel application) async {
  //   state = true;
  //   await _communityRepository.giveApproval(application);

  //   Community community = Community(
  //     id: application.communityName,
  //     name: application.communityName,
  //     banner: Constants.bannerDefault,
  //     avatar: Constants.communityAvatarDefault,
  //     members: [application.userId],
  //     mods: [application.userId],
  //     description: '',
  //   );
  //   final res = await _communityRepository.createCommunity(community);
  //   state = false;
  //   res.fold(
  //     (failure) => showSnackBar(context, failure.message),
  //     (success) {
  //       showSnackBar(context, 'Approved');
  //       // Routemaster.of(context).pop();
  //     },
  //   );
  // }

  // void rejectApplication(
  //   BuildContext context,
  //   ApplicationModel application,
  // ) async {
  //   state = true;
  //   final res = await _communityRepository.rejectApplication(application);
  //   state = false;
  //   res.fold(
  //     (failure) => showSnackBar(context, failure.message),
  //     (success) {
  //       showSnackBar(context, 'Rejected');
  //       // Routemaster.of(context).pop();
  //     },
  //   );
  // }

  //! get applications
  // Stream<List<ApplicationModel>> getPendingAPplications() {
  //   return _communityRepository.getPendingApplications();
  // }

  // Stream<List<ApplicationModel>> getApprovedApplications() {
  //   return _communityRepository.getApprovedApplications();
  // }

  // Stream<List<ApplicationModel>> getRejectedApplications() {
  //   return _communityRepository.getRejectedApplications();
  // }
}
