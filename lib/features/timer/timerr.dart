import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stark/features/attendance/controllers/attendance_controller.dart';

final timeNotifierProvider = StateNotifierProvider((ref) => TimeNotifier());

final myFunctionProvider = Provider((ref) => () {
  // ref.read(attendanceControllerProvider.notifier).markAttendanceAsNever(context, employeeId)
});

class TimeNotifier extends StateNotifier<DateTime> {
  Timer? _timer;

  TimeNotifier() : super(DateTime.now());

  void startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => state = DateTime.now());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get isNoon => state.hour == 12 && state.minute == 0 && state.second == 0;
}

