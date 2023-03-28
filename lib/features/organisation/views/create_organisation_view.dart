import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stark/core/utils.dart';
import 'package:stark/features/organisation/controllers/organisation_controller.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/button.dart';
import 'package:stark/utils/loader.dart';
import 'package:stark/utils/widget_extensions.dart';

class CreateOrganisationView extends ConsumerStatefulWidget {
  const CreateOrganisationView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateOrganisationViewState();
}

class _CreateOrganisationViewState
    extends ConsumerState<CreateOrganisationView> {
  final orgNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    orgNameController.dispose();
  }

  void createOrganisation() {
    if (orgNameController.text.isNotEmpty &&
        orgNameController.text.length > 5) {
      ref.read(organisationsControllerProvider.notifier).createOrganisation(
            orgNameController.text.trim(),
            context,
          );
    } else {
      showSnackBar(context, 'Enter a valid name');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(organisationsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Pallete.blackTint,
        title: Text(
          'Create Organisation',
          style: TextStyle(
              color: Pallete.blackish,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Loader()
          : Column(
              children: [
                20.sbH,
                TextField(
                  cursorColor: Pallete.blackish,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(' '))
                  ],
                  controller: orgNameController,
                  onChanged: (value) {
                    orgNameController.value = TextEditingValue(
                        text: value.toLowerCase(),
                        selection: orgNameController.selection);
                  },
                  decoration: InputDecoration(
                      hintText: 'Organisation name e.g org_tech',
                      hintStyle: TextStyle(fontSize: 13.sp),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      contentPadding: EdgeInsets.all(18.w)),
                  maxLength: 21,
                ),
                const Spacer(),
                BButton(
                  width: 300.w,
                  onTap: createOrganisation,
                  text: 'Create',
                ),
                50.sbH,
              ],
            ),
    );
  }
}
