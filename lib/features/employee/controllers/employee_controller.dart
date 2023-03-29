import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/core/providers/storage_repository_provider.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/employee/repositories/employee_repository.dart';
import 'package:stark/models/invite_model.dart';
import 'package:stark/models/user_model.dart';

import '../../../utils/snack_bar.dart';

//! provider to get invite by receiver Id
final getInviteByIdProvider = StreamProvider.family((ref, String receiverId) {
  return ref
      .watch(employeeControllerProvider.notifier)
      .getInViteModel(receiverId);
});

//! the search for employees provider to invite
final searchEmployeeToInviteProvider =
    StreamProvider.family((ref, String query) {
  return ref
      .watch(employeeControllerProvider.notifier)
      .searchForEmployeesToInvite(query);
});

//! the get invites for manager provider
final getInvitesForManagerProvider = StreamProvider((ref) {
  final employeeController = ref.watch(employeeControllerProvider.notifier);
  return employeeController.getInvitesForManager();
});

//! the get invites for employee provider
final getInvitesForEmployeeProvider = StreamProvider((ref) {
  final employeeController = ref.watch(employeeControllerProvider.notifier);
  return employeeController.getInvitesForEmployee();
});

//! the notifier provider
final employeeControllerProvider =
    StateNotifierProvider<EmployeeController, bool>((ref) {
  final employeeRepository = ref.watch(employeeRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return EmployeeController(
    employeeRepository: employeeRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

//! employee state notifier
class EmployeeController extends StateNotifier<bool> {
  final EmployeeRepository _employeeRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  EmployeeController({
    required EmployeeRepository employeeRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _employeeRepository = employeeRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  //! send invite
  void sendInvite({
    required BuildContext context,
    required String receiverId,
    required String organisationName,
  }) async {
    state = true;
    final user = _ref.read(userProvider)!;
    InviteModel invite = InviteModel(
      organisationName: organisationName,
      receiverId: receiverId,
      managerId: user.uid,
      sentAt: DateTime.now(),
      actionAt: DateTime.now(),
      status: 'pending',
    );

    final res = await _employeeRepository.sendInvite(invite, organisationName);

    state = false;

    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        showSnackBar(context, 'Invite sent');
        // Routemaster.of(context).pop();
      },
    );
  }

  //! reject invite
  void rejectInvite(InviteModel invite, BuildContext context) async {
    final res = await _employeeRepository.rejectInvite(invite);
    res.fold(
      (l) => null,
      (r) => showSnackBar(context, 'Invitation Rejected!'),
    );
  }

  //! accept invite
  void acceptInvite(InviteModel invite, BuildContext context) async {
    final res = await _employeeRepository.acceptInvite(invite);
    res.fold(
      (l) => null,
      (r) => showSnackBar(context, 'Invitation Accepted!'),
    );
  }

  //! get an invite moder
  Stream<InviteModel> getInViteModel(String receiverId) {
    return _employeeRepository.getInViteModel(receiverId: receiverId);
  }

  //! search for employees
  Stream<List<UserModel>> searchForEmployeesToInvite(String query) {
    return _employeeRepository.searchForEmployeesToInvite(query);
  }

  //! get streams of invites for managers
  Stream<List<InviteModel>> getInvitesForManager() {
    final user = _ref.read(userProvider)!;
    return _employeeRepository.getInvitesForManager(managerId: user.uid);
  }

  //! get streams of invites for employees
  Stream<List<InviteModel>> getInvitesForEmployee() {
    final user = _ref.read(userProvider)!;
    return _employeeRepository.getInvitesForEmployee(employeeId: user.uid);
  }
}
