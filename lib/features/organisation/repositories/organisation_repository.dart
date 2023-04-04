import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stark/core/constants/firebase_constants.dart';
import 'package:stark/core/failure.dart';
import 'package:stark/core/providers/firebase_provider.dart';
import 'package:stark/core/type_defs.dart';
import 'package:stark/models/org_message_model.dart';
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
  FutureVoid createOrganisation(
      OrganisationModel organisation, String uid) async {
    try {
      var organisationDoc = await _organisations.doc(organisation.name).get();
      if (organisationDoc.exists) {
        throw 'Organisation with the same name exists';
      }

      _users.doc(uid).update({
        'organisation': organisation.name,
      });

      return right(
          _organisations.doc(organisation.name).set(organisation.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! create message group
  FutureVoid createMessageGroup(OrgMessagingModel orgMessaging) async {
    try {
      var orgMessagingDoc = await _organisations.doc(orgMessaging.name).get();
      if (orgMessagingDoc.exists) {
        throw 'Group with the same name exists';
      }

      return right(
          _messageGroup.doc(orgMessaging.name).set(orgMessaging.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! get org messaging group

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

  // //
  CollectionReference get _organisations =>
      _firestore.collection(FirebaseConstants.organisationsCollection);

  CollectionReference get _invites =>
      _firestore.collection(FirebaseConstants.invitesCollection);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _messageGroup =>
      _firestore.collection(FirebaseConstants.messageGroupCollection);
}
