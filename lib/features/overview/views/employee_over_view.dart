import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stark/utils/app_bar.dart';

class EmployeeOverView extends ConsumerStatefulWidget {
  const EmployeeOverView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmployeeOverViewState();
}

class _EmployeeOverViewState extends ConsumerState<EmployeeOverView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: const MyAppBar(
        title: 'Overview',
      ),
    );
  }
}