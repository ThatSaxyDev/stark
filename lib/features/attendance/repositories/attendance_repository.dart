import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:stark/core/constants/firebase_constants.dart';
import 'package:stark/core/failure.dart';
import 'package:stark/core/providers/firebase_provider.dart';
import 'package:stark/core/type_defs.dart';
import 'package:stark/models/attemdance_model.dart';
import 'package:stark/models/attendance_record_model.dart';
import 'package:stark/models/organisation_model.dart';

//! the organisation repo provider
final attendanceRepositoryProvider = Provider((ref) {
  return AttendanceRepository(firestore: ref.watch(firestoreProvider));
});

//! attendance repo class
class AttendanceRepository {
  final FirebaseFirestore _firestore;
  AttendanceRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  //! create attendance instances
  //! fire this at 7am
  FutureVoid createAttendance(
      AttendanceModel attendance, String orgName) async {
    try {
      var organisationDoc = await _organisations.doc(orgName).get();

      Map<String, dynamic>? orgData =
          organisationDoc.data() as Map<String, dynamic>?;

      OrganisationModel organisation = OrganisationModel.fromMap(orgData!);

      List<Future<void>> futures = [];

      AttendanceRecordModel attendanceRecord = AttendanceRecordModel(
        day: DateTime.now(),
        organisationName: organisation.name,
        early: [],
        late: [],
        present: [],
        absent: [],
      );

      for (var id in organisation.employees) {
        Future<void> res = _attendance
            .doc(id)
            .set(attendance.copyWith(employeeId: id).toMap());
        futures.add(res);
      }

      await Future.wait(futures);

      var dateStr = DateFormat.yMMMMEEEEd().format(DateTime.now());
      var attendanceDocRef = _attendanceRecords.doc(dateStr);
      if (!(await attendanceDocRef.get()).exists) {
        await attendanceDocRef.set(attendanceRecord.toMap());
      }

      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! mark attendance
  FutureVoid markAttendance(String employeeId) async {
    try {
      return right(_attendance.doc(employeeId).update({
        'status': 'signed',
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! mark attendance as never
  FutureVoid markAttendanceAsNever(String employeeId) async {
    try {
      return right(_attendance.doc(employeeId).update({
        'status': 'neversigned',
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! update attendance record
  FutureVoid updateAtendanceEarlyOrLate(String employeeId) async {
    try {
      if (DateTime.now().isBefore(DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 9))) {
        return right(_attendanceRecords
            .doc(DateFormat.yMMMMEEEEd().format(DateTime.now()))
            .update({
          'early': FieldValue.arrayUnion([employeeId]),
        }));
      } else {
        return right(_attendanceRecords
            .doc(DateFormat.yMMMMEEEEd().format(DateTime.now()))
            .update({
          'late': FieldValue.arrayUnion([employeeId]),
        }));
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //
  FutureVoid updateAtendancePresent(String employeeId) async {
    try {
      return right(_attendanceRecords
          .doc(DateFormat.yMMMMEEEEd().format(DateTime.now()))
          .update({
        'present': FieldValue.arrayUnion([employeeId]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //
  FutureVoid updateAttendanceAbsent(String employeeId) async {
    try {
      return right(_attendanceRecords
          .doc(DateFormat.yMMMMEEEEd().format(DateTime.now()))
          .update({
        'absent': FieldValue.arrayUnion([employeeId]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // //! create attendance record
  // FutureVoid createAttendanceRecord(
  //     AttendanceRecordModel attendanceRecord) async {
  //   try {
  //     var attendanceDoc = await _organisations
  //         .doc(DateFormat.yMMMMEEEEd().format(DateTime.now()))
  //         .get();
  //     if (attendanceDoc.exists) {}

  //     return right(_attendanceRecords
  //         .doc(DateFormat.yMMMMEEEEd().format(DateTime.now()))
  //         .set(attendanceRecord.toMap()));
  //   } on FirebaseException catch (e) {
  //     throw e.message!;
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

  //! get attendance record
  Stream<AttendanceRecordModel> getAttendanceRecord() {
    return _attendanceRecords
        .doc(DateFormat.yMMMMEEEEd().format(DateTime.now()))
        .snapshots()
        .map((event) => AttendanceRecordModel.fromMap(
            event.data() as Map<String, dynamic>));
  }

  //! get attendance record for partiular days
  Stream<List<AttendanceRecordModel>> getListAttendanceRecords(
      String orgName, DateTime date) {
    return _attendanceRecords
        .where('organisationName', isEqualTo: orgName)
        .where('date', isEqualTo: date)
        .snapshots()
        .map(
      (event) {
        List<AttendanceRecordModel> attendanceRecord = [];
        for (var doc in event.docs) {
          attendanceRecord.add(AttendanceRecordModel.fromMap(
              doc.data() as Map<String, dynamic>));
        }
        return attendanceRecord;
      },
    );
  }

  //! fire this at 12pm
  //! clear attendance sign in for the day
  FutureVoid clearAttendance(String employeeId) async {
    try {
      return right(_attendance.doc(employeeId).update({
        'status': 'never',
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! get attendance stream
  Stream<List<AttendanceModel>> getAttendanceList(String orgName) {
    return _attendance
        .where('organisationName', isEqualTo: orgName)
        .where('status', isEqualTo: 'notsigned')
        .snapshots()
        .map(
      (event) {
        List<AttendanceModel> attendance = [];
        for (var doc in event.docs) {
          attendance
              .add(AttendanceModel.fromMap(doc.data() as Map<String, dynamic>));
        }
        return attendance;
      },
    );
  }

//! get attendance signed stream
  Stream<List<AttendanceModel>> getAttendanceListSigned(String orgName) {
    return _attendance
        .where('organisationName', isEqualTo: orgName)
        .where('status', isEqualTo: 'signed')
        .snapshots()
        .map(
      (event) {
        List<AttendanceModel> attendance = [];
        for (var doc in event.docs) {
          attendance
              .add(AttendanceModel.fromMap(doc.data() as Map<String, dynamic>));
        }
        return attendance;
      },
    );
  }

  CollectionReference get _organisations =>
      _firestore.collection(FirebaseConstants.organisationsCollection);

  CollectionReference get _attendance =>
      _firestore.collection(FirebaseConstants.attendanceCollection);

  CollectionReference get _attendanceRecords =>
      _firestore.collection(FirebaseConstants.attendanceRecordsCollection);
}
