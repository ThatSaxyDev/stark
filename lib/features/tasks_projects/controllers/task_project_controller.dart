import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/core/providers/storage_repository_provider.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/organisation/controllers/organisation_controller.dart';
import 'package:stark/features/tasks_projects/repositories/task_project_repository.dart';
import 'package:stark/models/project_model.dart';
import 'package:stark/utils/snack_bar.dart';

//! get projects provider
final getProjectsForOrganisationsProvider = StreamProvider((ref) {
  final taskProjectController =
      ref.watch(taskProjectControllerProvider.notifier);
  return taskProjectController.getProjectsForOrganisation();
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

  //! get projects per organisation
  Stream<List<ProjectModel>> getProjectsForOrganisation() {
    String orgName = '';
    final ress = _ref.watch(getManagerOrganisationsProvider);
    ress.whenData((organisation) => orgName = organisation[0].name);
    return _taskProjectRepository.getProjectsForOrganisation(orgName);
  }
}
