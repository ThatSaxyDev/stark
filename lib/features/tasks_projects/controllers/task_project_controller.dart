import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/core/failure.dart';
import 'package:stark/core/providers/storage_repository_provider.dart';
import 'package:stark/core/type_defs.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/organisation/controllers/organisation_controller.dart';
import 'package:stark/features/tasks_projects/repositories/task_project_repository.dart';
import 'package:stark/models/project_model.dart';
import 'package:stark/models/task_model.dart';
import 'package:stark/utils/snack_bar.dart';

//! get projects provider
final getProjectsForOrganisationsProvider = StreamProvider((ref) {
  final taskProjectController =
      ref.watch(taskProjectControllerProvider.notifier);
  return taskProjectController.getProjectsForOrganisation();
});

//! get projects Emp provider
final getProjectsForEmpOrganisationsProvider = StreamProvider((ref) {
  final taskProjectController =
      ref.watch(taskProjectControllerProvider.notifier);
  return taskProjectController.getProjectsForEmpOrganisation();
});

//! get projects for employees provider
final getProjectsForEmployeesProvider = StreamProvider((ref) {
  final taskProjectController =
      ref.watch(taskProjectControllerProvider.notifier);
  return taskProjectController.getProjectsForEmployee();
});

//! get tasks for employees provider
final getTasksForEmployeesProvider = StreamProvider.autoDispose((ref) {
  final taskProjectController =
      ref.watch(taskProjectControllerProvider.notifier);
  return taskProjectController.getTasksForEmployee();
});

//! get tasks in projects
final getTasksInProjectProvider =
    StreamProvider.family((ref, String projectName) {
  final taskProjectController =
      ref.watch(taskProjectControllerProvider.notifier);
  return taskProjectController.getTasksInProjects(projectName);
});

//! get particular project
final getProjectProvider = StreamProvider.family((ref, String projectName) {
  final taskProjectController =
      ref.watch(taskProjectControllerProvider.notifier);
  return taskProjectController.getParticularProject(projectName);
});

//! get particular task
final getTaskProvider = StreamProvider.family((ref, String taskName) {
  final taskProjectController =
      ref.watch(taskProjectControllerProvider.notifier);
  return taskProjectController.getParticularTask(taskName);
});

//! the organization controller provider
final taskProjectControllerProvider =
    StateNotifierProvider<TaskProjectController, bool>((ref) {
  final taskProjectRepository = ref.watch(tasksProjectRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return TaskProjectController(
    taskProjectRepository: taskProjectRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

//! TaskProject state notifier class
class TaskProjectController extends StateNotifier<bool> {
  final TaskProjectRepository _taskProjectRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  TaskProjectController({
    required TaskProjectRepository taskProjectRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _taskProjectRepository = taskProjectRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  //! create project
  void createProject({
    required BuildContext context,
    required String name,
    required DateTime endDateTime,
  }) async {
    String orgName = '';
    state = true;
    final user = _ref.read(userProvider)!;
    final ress = _ref.watch(getManagerOrganisationsProvider);
    ress.whenData((organisation) => orgName = organisation[0].name);
    ProjectModel project = ProjectModel(
      organisationName: orgName,
      managerId: user.uid,
      name: name,
      employeeIds: [],
      taskIds: [],
      status: 'ongoing',
      type: '',
      endDateTime: endDateTime,
      startDateTime: DateTime.now(),
    );

    final res = await _taskProjectRepository.createProject(project);
    state = false;
    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        showSnackBar(context, 'Project created successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  //! create task
  void createTask({
    required BuildContext context,
    required String taskName,
    required String projectName,
    required employeeId,
    required description,
  }) async {
    String orgName = '';
    final user = _ref.read(userProvider)!;
    final ress = _ref.watch(getManagerOrganisationsProvider);
    ress.whenData((organisation) => orgName = organisation[0].name);
    state = true;
    TaskModel task = TaskModel(
      taskName: taskName,
      projectName: projectName,
      employeeId: employeeId,
      description: description,
      organisationName: orgName,
      status: 'not started',
      managerId: user.uid,
    );

    final res = await _taskProjectRepository.createTask(task);
    state = false;
    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        showSnackBar(context, 'Task created successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  //! update task status
  void updateTaskStatusDone(BuildContext context, String taskName) async {
    state = true;
    Either<Failure, void> res;

    res = await _taskProjectRepository.updateTaskStatusDone(taskName);

    state = false;
    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (r) => null,
    );
  }

  void updateTaskStatusProgress(BuildContext context, String taskName) async {
    state = true;
    Either<Failure, void> res;

    res = await _taskProjectRepository.updateTaskStatusProgress(taskName);

    state = false;
    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (r) => null,
    );
  }

  //! update project status
  void updatProjectStatusDone(BuildContext context, String projectName) async {
    state = true;
    Either<Failure, void> res;

    res = await _taskProjectRepository.updateProjectStatusDone(projectName);

    state = false;
    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) => showSnackBar(context, 'Project done!'),
    );
  }

  void updateProjectStatusProgress(
      BuildContext context, String projectName) async {
    state = true;
    Either<Failure, void> res;

    res = await _taskProjectRepository.updateProjectStatusProgress(projectName);

    state = false;
    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) => showSnackBar(context, 'Project back in progress!'),
    );
  }

  //! get projects per organisation
  Stream<List<ProjectModel>> getProjectsForOrganisation() {
    String orgName = '';
    final ress = _ref.watch(getManagerOrganisationsProvider);
    ress.whenData((organisation) => orgName = organisation[0].name);
    return _taskProjectRepository.getProjectsForOrganisation(orgName);
  }

  //! get projects per organisation
  Stream<List<ProjectModel>> getProjectsForEmpOrganisation() {
    String orgName = '';
    final ress = _ref.watch(getEmployeeOrganisationsProvider);
    ress.whenData((organisation) => orgName = organisation[0].name);
    return _taskProjectRepository.getProjectsForOrganisation(orgName);
  }

  //! get projects for employees
  Stream<List<ProjectModel>> getProjectsForEmployee() {
    final user = _ref.watch(userProvider)!;
    // log(user.email);
    return _taskProjectRepository.getProjectsForEmployee(user.uid);
  }

  //! get tasks for an employee
  Stream<List<TaskModel>> getTasksForEmployee() {
    final user = _ref.watch(userProvider)!;
    return _taskProjectRepository.getTasksForEmployee(user.uid);
  }

  //! get tasks in projects
  Stream<List<TaskModel>> getTasksInProjects(String projectName) {
    return _taskProjectRepository.getTasksInProjects(projectName);
  }

  //! get particular project
  Stream<ProjectModel> getParticularProject(String projectName) {
    return _taskProjectRepository.getParticularProject(projectName);
  }

  //! get particular task
  Stream<TaskModel> getParticularTask(String taskName) {
    return _taskProjectRepository.getParticularTask(taskName);
  }
}
