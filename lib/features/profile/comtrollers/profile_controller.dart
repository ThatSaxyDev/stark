import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/core/providers/storage_repository_provider.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/models/user_model.dart';
import 'package:stark/utils/snack_bar.dart';

import '../repositories/profile_repository.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _userProfileRepository = userProfileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void editUserProfile({
    required BuildContext context,
    required File? profileFile,
    Uint8List? file,
    required String firstName,
    required String lastName,
    required String role,
    required String phone,
  }) async {
    state = true;
    String profilePhoto = _ref.watch(userProvider)!.profilePic;
    UserModel user = _ref.read(userProvider)!;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.uid,
        file: profileFile,
        webFile: file,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (profilePicUrl) => profilePhoto = profilePicUrl,
        // (r) => user = user.copyWith(profilePic: r),
      );
    }

    if (firstName == '') {
      firstName = user.firstName;
    }

    if (lastName == '') {
      lastName = user.lastName;
    }

    if (role == '') {
      role = user.role;
    }

    if (phone == '') {
      phone = user.phone;
    }

    final res = await _userProfileRepository.editProfile(user.copyWith(
      profilePic: profilePhoto,
      firstName: firstName,
      lastName: lastName,
      role: role,
      phone: phone,
    ));
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Done!');
        _ref.read(userProvider.notifier).update((state) => user);
        // Routemaster.of(context).pop();
      },
    );
  }
}
