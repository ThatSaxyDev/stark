import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stark/core/constants/firebase_constants.dart';
import 'package:stark/core/failure.dart';
import 'package:stark/core/providers/firebase_provider.dart';
import 'package:stark/core/type_defs.dart';
import 'package:stark/models/organisation_model.dart';

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

  // CollectionReference get _posts =>
  //     _firestore.collection(FirebaseConstants.postsCollection);

  // CollectionReference get _approvals =>
  //     _firestore.collection(FirebaseConstants.approvalCollection);
}
