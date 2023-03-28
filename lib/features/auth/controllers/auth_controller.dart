import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/core/failure.dart';
import 'package:stark/features/auth/repositories/auth_repository.dart';
import 'package:stark/features/auth/views/new.dart';
import 'package:stark/models/user_model.dart';

import '../../../utils/snack_bar.dart';

//! the auth controller proviider
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
      authRepository: ref.watch(authRepositoryProvider),
      // communityRepository: ref.watch(communityRepositoryProvider),
      ref: ref),
);

//! the user provider
final userProvider = StateProvider<UserModel?>((ref) => null);

//! the auth state change provider
final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

//! the authcontroller state notifier
class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false);

  //! this is the stream that lets us know when there are chnages to the
  //! auth state of the user {logged in/logged out}
  Stream<User?> get authStateChange => _authRepository.authStateChange;

  //! sign up the admin
  void signUpAdmin({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required bool isAdmin,
  }) async {
    state = true;
    late UserModel userM;
    Either<Failure, UserModel> res = await _authRepository.signUpAdmin(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      isAdmin: isAdmin,
    );
    state = false;
    res.fold((l) {
      log(l.message);
      showSnackBar(context, l.message);
    }, (userModel) {
      Routemaster.of(context).pop();
      _ref.read(userProvider.notifier).update((state) => userM = userModel);
    });
  }

  //! login admin
  void loginAdmin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true;
    late UserModel userM;
    Either<Failure, UserModel> res = await _authRepository.logInAdmin(
      email: email,
      password: password,
    );
    state = false;
    res.fold((l) {
      log(l.message);
      showSnackBar(context, l.message);
    }, (userModel) {
      Routemaster.of(context).pop();
      _ref.read(userProvider.notifier).update((state) => userM = userModel);
    });
  }

  //! get user
  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  //! log out user
  void logOut() async {
    _ref.read(userProvider.notifier).update((state) => null);
    _authRepository.logOut();
  }
}
