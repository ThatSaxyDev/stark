//! organisation state notifier class
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stark/core/failure.dart';
import 'package:stark/core/providers/storage_repository_provider.dart';
import 'package:stark/features/attendance/repositories/attendance_repository.dart';
import 'package:stark/features/organisation/controllers/organisation_controller.dart';
import 'package:stark/models/attemdance_model.dart';
import 'package:stark/models/attendance_record_model.dart';

import '../../../utils/snack_bar.dart';

//! provider to get attendance
final getAttendanceStreamProvider = StreamProvider((ref) {
  final attendanceController = ref.watch(attendanceControllerProvider.notifier);
  return attendanceController.getAttendanceList();
});

//! provider to get signed attendance
final getAttendanceSignedStreamProvider = StreamProvider((ref) {
  final attendanceController = ref.watch(attendanceControllerProvider.notifier);
  return attendanceController.getAttendanceListSigned();
});

//! the attendance controller provider
final attendanceControllerProvider =
    StateNotifierProvider<AttendanceController, bool>((ref) {
  final attendanceRepository = ref.watch(attendanceRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return AttendanceController(
    attendanceRepository: attendanceRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

//! attendance state notifier class
class AttendanceController extends StateNotifier<bool> {
  final AttendanceRepository _attendanceRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  AttendanceController({
    required AttendanceRepository attendanceRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _attendanceRepository = attendanceRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

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
        await _attendanceRepository.createAttendance(attendance, orgName);

    state = false;

    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        showSnackBar(context, 'Attendance created successfully');
        // Navigate to another page or refresh the current page.
      },
    );
  }

// Mark attendance for the given employee
  void markAttendance(BuildContext context, String employeeId) async {
    // Get the name of the organization
    String orgName = '';

    // Update the state of the app
    state = true;

    // Get the name of the organization
    final ress = _ref.watch(getManagerOrganisationsProvider);
    ress.whenData((organisation) => orgName = organisation[0].name);

    // Define res here
    Either<Failure, void> res;

    if (DateTime.now().isBefore(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 12))) {
      await _attendanceRepository.updateAtendancePresent(employeeId);
      await _attendanceRepository.updateAtendanceEarlyOrLate(employeeId);
      res = await _attendanceRepository.markAttendance(employeeId);
    } else {
      await _attendanceRepository.updateAttendanceAbsent(employeeId);
      res = await _attendanceRepository.markAttendanceAsNever(employeeId);
    }

    // Update the state of the app
    state = false;

    // Show a snackbar to indicate success or failure
    res.fold(
      (l) => showSnackBar(context, 'An error occurred while signing'),
      (r) => showSnackBar(context, 'Signed!'),
    );
  }

  //! mark attendance as never
  void markAttendanceAsNever(BuildContext context, String employeeId) async {
    state = true;
    final res = await _attendanceRepository.markAttendanceAsNever(employeeId);
    state = false;
    res.fold(
      (l) => null,
      (r) => null,
    );
  }

  //! get attendance stream
  Stream<List<AttendanceModel>> getAttendanceList() {
    String orgName = '';
    final ress = _ref.watch(getManagerOrganisationsProvider);
    ress.whenData((organisation) => orgName = organisation[0].name);
    return _attendanceRepository.getAttendanceList(orgName);
  }

  //! get attendance signed stream
  Stream<List<AttendanceModel>> getAttendanceListSigned() {
    String orgName = '';
    final ress = _ref.watch(getManagerOrganisationsProvider);
    ress.whenData((organisation) => orgName = organisation[0].name);
    return _attendanceRepository.getAttendanceListSigned(orgName);
  }
}
