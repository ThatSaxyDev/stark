import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stark/core/constants/firebase_constants.dart';
import 'package:stark/core/failure.dart';
import 'package:stark/core/providers/firebase_provider.dart';
import 'package:stark/core/type_defs.dart';
import 'package:stark/models/project_model.dart';
import 'package:stark/models/task_model.dart';

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

  //! create tasks
  FutureVoid createTask(TaskModel task) async {
    try {
      var taskDoc = await _tasks.doc(task.taskName).get();
      if (taskDoc.exists) {
        throw 'Project with the same name exists';
      }
      await _projects.doc(task.projectName).update({
        'employeeIds': FieldValue.arrayUnion([task.employeeId]),
        'taskIds': FieldValue.arrayUnion([task.taskName]),
      });

      return right(_tasks.doc(task.taskName).set(task.toMap()));
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

  //! get projects for an employee
  Stream<List<ProjectModel>> getProjectsForEmployee(String employeeId) {
    return _projects
        .where('employeeIds', arrayContains: employeeId)
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

  //! get tasks in projects
  Stream<List<TaskModel>> getTasksInProjects(String projectName) {
    return _tasks.where('projectName', isEqualTo: projectName).snapshots().map(
      (event) {
        List<TaskModel> tasks = [];
        for (var doc in event.docs) {
          tasks.add(TaskModel.fromMap(doc.data() as Map<String, dynamic>));
        }
        return tasks;
      },
    );
  }

  //! get tasks in projects
  Stream<List<TaskModel>> getOngoingTasksInProjects(String projectName) {
    return _tasks
        .where('projectName', isEqualTo: projectName)
        .where('status')
        .snapshots()
        .map(
      (event) {
        List<TaskModel> tasks = [];
        for (var doc in event.docs) {
          tasks.add(TaskModel.fromMap(doc.data() as Map<String, dynamic>));
        }
        return tasks;
      },
    );
  }

  //! get particular project
  Stream<ProjectModel> getParticularProject(String projectName) {
    return _projects.doc(projectName).snapshots().map(
        (event) => ProjectModel.fromMap(event.data() as Map<String, dynamic>));
  }

  //! get particular task
  Stream<TaskModel> getParticularTask(String taskName) {
    return _tasks.doc(taskName).snapshots().map(
        (event) => TaskModel.fromMap(event.data() as Map<String, dynamic>));
  }

  //! update project done
  FutureVoid updateProjectStatusDone(String projectName) async {
    try {
      return right(_projects.doc(projectName).update({
        'status': 'done',
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! update project not done
  FutureVoid updateProjectStatusProgress(String projectName) async {
    try {
      return right(_projects.doc(projectName).update({
        'status': 'ongoing',
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! update task status done
  FutureVoid updateTaskStatusDone(String taskName) async {
    try {
      return right(_tasks.doc(taskName).update({
        'status': 'done',
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! update task status in progress
  FutureVoid updateTaskStatusProgress(String taskName) async {
    try {
      return right(_tasks.doc(taskName).update({
        'status': 'not started',
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _organisations =>
      _firestore.collection(FirebaseConstants.organisationsCollection);

  CollectionReference get _projects =>
      _firestore.collection(FirebaseConstants.projectsCollection);

  CollectionReference get _tasks =>
      _firestore.collection(FirebaseConstants.tasksCollection);
}
