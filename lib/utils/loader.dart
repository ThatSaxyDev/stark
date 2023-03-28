
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stark/theme/palette.dart';

// class Loader extends StatelessWidget {
//   const Loader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: LoadingAnimationWidget.halfTriangleDot(
//         color: Pallete.whiteColor,
//         size: 60.w,
//       ),
//     );
//   }
// }

class Loader extends ConsumerWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenTheme = ref.watch(themeNotifierProvider);
    return  Center(
      child: SizedBox(
        height: 60,
        width: 60,
        // child: CircularProgressIndicator(
        //   color: Pallete.blueColor,
        // ),
        child: LoadingAnimationWidget.inkDrop(
           color: Pallete.primaryGreen,
          size: 60,
        ),
      ),
    );
  }
}
