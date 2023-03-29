import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stark/core/constants/firebase_constants.dart';
import 'package:stark/core/failure.dart';
import 'package:stark/core/providers/firebase_provider.dart';
import 'package:stark/core/type_defs.dart';
import 'package:stark/models/organisation_model.dart';
import 'package:stark/models/user_model.dart';

import '../../../models/attemdance_model.dart';

//! the organisation repo provider
final organisationsRepositoryProvider = Provider((ref) {
  return OrganisationsRepository(firestore: ref.watch(firestoreProvider));
});

//! org repo
class OrganisationsRepository {
  final FirebaseFirestore _firestore;
  OrganisationsRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  //! create organisation
  FutureVoid createOrganisation(OrganisationModel organisation) async {
    try {
      var organisationDoc = await _organisations.doc(organisation.name).get();
      if (organisationDoc.exists) {
        throw 'Organisation with the same name exists';
      }

      return right(
          _organisations.doc(organisation.name).set(organisation.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! create attendance instances
  FutureVoid createAttendance(
      AttendanceModel attendance, String orgName) async {
    try {
      var organisationDoc = await _organisations.doc(orgName).get();

      Map<String, dynamic>? orgData =
          organisationDoc.data() as Map<String, dynamic>?;

      OrganisationModel organisation = OrganisationModel.fromMap(orgData!);

      List<Future<void>> futures = [];

      for (var id in organisation.employees) {
        Future<void> res = _attendance
            .doc(id)
            .set(attendance.copyWith(employeeId: id).toMap());
        futures.add(res);
      }

      await Future.wait(futures);

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

  //! get attendance stream
  Stream<List<AttendanceModel>> getAttendanceList(String orgName) {
    return _attendance
        .where('organisationName', isEqualTo: orgName)
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

  //! get managers organisations
  Stream<List<OrganisationModel>> getManagerOrganisations(String uid) {
    return _organisations.where('managers', arrayContains: uid).snapshots().map(
      (event) {
        List<OrganisationModel> organisations = [];
        for (var doc in event.docs) {
          organisations.add(
              OrganisationModel.fromMap(doc.data() as Map<String, dynamic>));
        }
        return organisations;
      },
    );
  }

  //! get employees organisations
  Stream<List<OrganisationModel>> getEmployeeOrganisations(String uid) {
    return _organisations
        .where('employees', arrayContains: uid)
        .snapshots()
        .map(
      (event) {
        List<OrganisationModel> organisations = [];
        for (var doc in event.docs) {
          organisations.add(
              OrganisationModel.fromMap(doc.data() as Map<String, dynamic>));
        }
        return organisations;
      },
    );
  }

  //! sack employee
  FutureVoid sackEmployee({
    required String organisationName,
    required String employeeId,
  }) async {
    try {
      await _invites.doc(employeeId).delete();
      return right(_organisations.doc(organisationName).update({
        'employees': FieldValue.arrayRemove([employeeId])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! get organisation
  Stream<OrganisationModel> getOrganisationByName(String name) {
    return _organisations.doc(name).snapshots().map((event) =>
        OrganisationModel.fromMap(event.data() as Map<String, dynamic>));
  }

  //! search for employees
  Stream<List<UserModel>> searchForEmployees(String query) {
    return _organisations
        .where(
          'email',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query.toLowerCase(),
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        // .where('isAdmin', isEqualTo: false)
        .snapshots()
        .map((event) {
      List<UserModel> employees = [];
      for (var employee in event.docs) {
        employees
            .add(UserModel.fromMap(employee.data() as Map<String, dynamic>));
      }
      return employees;
    });
  }

  //! get applicatiions
  // Stream<List<ApplicationModel>> getPendingApplications() {
  //   return _approvals
  //       .where('approvalStatus', isEqualTo: 'pending')
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map((event) => event.docs
  //           .map((e) =>
  //               ApplicationModel.fromMap(e.data() as Map<String, dynamic>))
  //           .toList());
  // }

  // //! give approval
  // FutureVoid giveApproval(ApplicationModel application) async {
  //   try {
  //     return right(_approvals
  //         .doc(application.communityName)
  //         .update({'approvalStatus': 'approved'}));
  //   } on FirebaseException catch (e) {
  //     throw e.message!;
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

  // //! reject application
  // FutureVoid rejectApplication(ApplicationModel application) async {
  //   try {
  //     return right(_approvals
  //         .doc(application.communityName)
  //         .update({'approvalStatus': 'rejected'}));
  //   } on FirebaseException catch (e) {
  //     throw e.message!;
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

  // //! add applicant to community
  // FutureVoid addApplicantToCommunity(
  //     ApplicationModel application, List<String> uids) async {
  //   try {
  //     return right(_approvals.doc(application.communityName).update({
  //       'mods': uids,
  //       'members': uids,
  //     }));
  //   } on FirebaseException catch (e) {
  //     throw e.message!;
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

  // Stream<List<ApplicationModel>> getApprovedApplications() {
  //   return _approvals
  //       .where('approvalStatus', isEqualTo: 'approved')
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map((event) => event.docs
  //           .map((e) =>
  //               ApplicationModel.fromMap(e.data() as Map<String, dynamic>))
  //           .toList());
  // }

  // Stream<List<ApplicationModel>> getRejectedApplications() {
  //   return _approvals
  //       .where('approvalStatus', isEqualTo: 'rejected')
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map((event) => event.docs
  //           .map((e) =>
  //               ApplicationModel.fromMap(e.data() as Map<String, dynamic>))
  //           .toList());
  // }

  // //
  CollectionReference get _organisations =>
      _firestore.collection(FirebaseConstants.organisationsCollection);

  CollectionReference get _invites =>
      _firestore.collection(FirebaseConstants.invitesCollection);

  CollectionReference get _attendance =>
      _firestore.collection(FirebaseConstants.attendanceCollection);

  // CollectionReference get _posts =>
  //     _firestore.collection(FirebaseConstants.postsCollection);

  // CollectionReference get _approvals =>
  //     _firestore.collection(FirebaseConstants.approvalCollection);
}
