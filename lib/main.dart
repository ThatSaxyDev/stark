import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routemaster/routemaster.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/auth/views/sign_up_view.dart';
import 'package:stark/firebase_options.dart';
import 'package:stark/models/user_model.dart';
import 'package:stark/router.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'myApp',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override 
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateChangeProvider);
    //! initializing screen utils for responsiveness
    return authState.when(
      data: (user) => ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            routeInformationParser: const RoutemasterParser(),
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (user != null) {
                  getData(ref, user);
                  if (userModel != null) {
                    return userModel!.isAdmin == true
                        ? adminLoggedInRoute
                        : employeeLoggedInRoute;
                  }
                }
                return loggedOutRoute;
              },
            ),
          );
        },
      ),
      error: (error, stactrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
