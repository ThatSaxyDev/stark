import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stark/core/constants/firebase_constants.dart';
import 'package:stark/core/failure.dart';
import 'package:stark/core/providers/firebase_provider.dart';
import 'package:stark/core/type_defs.dart';
import 'package:stark/models/invite_model.dart';
import 'package:stark/models/user_model.dart';

//! the provider for the employees repo
final employeeRepositoryProvider = Provider((ref) {
  return EmployeeRepository(firestore: ref.watch(firestoreProvider));
});

//! the employee repository class handling everything related to employees
class EmployeeRepository {
  final FirebaseFirestore _firestore;
  EmployeeRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  //! send invitation to employee
  FutureVoid sendInvite(InviteModel invite) async {
    try {
      return right(_invites.doc(invite.receiverId).set(invite.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! get stream of invites for manager
  Stream<List<InviteModel>> getInvitesForManager({required String managerId}) {
    return _invites
        .where('managerId', isEqualTo: managerId)
        // .orderBy('actionAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => InviteModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  //! search for employees
  Stream<List<UserModel>> searchForEmployeesToInvite(String query) {
    return _users
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

  CollectionReference get _invites =>
      _firestore.collection(FirebaseConstants.invitesCollection);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
}
