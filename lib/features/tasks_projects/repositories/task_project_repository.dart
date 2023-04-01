import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stark/core/constants/firebase_constants.dart';
import 'package:stark/core/failure.dart';
import 'package:stark/core/providers/firebase_provider.dart';
import 'package:stark/core/type_defs.dart';
import 'package:stark/models/project_model.dart';

//! the tasksProject repo provider
final tasksProjectRepositoryProvider = Provider((ref) {
  return TaskProjectRepository(firestore: ref.watch(firestoreProvider));
});

//!  tasksProject repo class
class TaskProjectRepository {
  final FirebaseFirestore _firestore;
  TaskProjectRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  //! create project
  FutureVoid createProject(ProjectModel project) async {
    try {
      var projectDoc = await _projects.doc(project.name).get();
      if (projectDoc.exists) {
        throw 'Project with the same name exists';
      }

      return right(_projects.doc(project.name).set(project.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! get projects per organisation
  Stream<List<ProjectModel>> getProjectsForOrganisation(String orgName) {
    return _projects
        .where('organisationName', isEqualTo: orgName)
        .snapshots()
        .map(
      (event) {
        List<ProjectModel> projects = [];
        for (var doc in event.docs) {
          projects
              .add(ProjectModel.fromMap(doc.data() as Map<String, dynamic>));
        }
        return projects;
      },
    );
  }

  CollectionReference get _organisations =>
      _firestore.collection(FirebaseConstants.organisationsCollection);

  CollectionReference get _projects =>
      _firestore.collection(FirebaseConstants.projectsCollection);

  CollectionReference get _tasks =>
      _firestore.collection(FirebaseConstants.tasksCollection);
}
