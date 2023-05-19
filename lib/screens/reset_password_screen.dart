import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';

class ResetPasswordScreen extends ConsumerWidget {
  const ResetPasswordScreen({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Reset Password',
                style: TextStyle(fontSize: 50),
              ),
              const SizedBox(
                height: 30,
              ),
              _passwordField(),
              const SizedBox(
                height: 30,
              ),
              _confirmPasswordField(context, ref),
              const SizedBox(
                height: 30,
              ),
              _buttons(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Column _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter new password'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(
            obscureText: true,
            maxLength: 30,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            controller: passwordController,
            decoration: const InputDecoration(hintText: '(required)'),
          ),
        ),
      ],
    );
  }

  Column _confirmPasswordField(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Confirm password'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(
            onSubmitted: (value) async {
              await _submit(context, ref);
            },
            obscureText: true,
            maxLength: 30,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            controller: confirmPasswordController,
          ),
        ),
      ],
    );
  }

  Row _buttons(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);

            if (ref.read(userProvider)!.isAdmin && ref.read(adminPanelSelectedUserProvider)!.isAdmin) {
              Navigator.pop(context);
            }
          },
          child: const Text('Cancel'),
        ),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            await _submit(context, ref);
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  _submit(BuildContext context, WidgetRef ref) async {
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty) {
      EasyLoading.showError('Required fields must not be empty');
      return;
    }

    if (password != confirmPassword) {
      EasyLoading.showError('Passwords do not match');
      return;
    }

    try {
      User? user = ref.read(adminPanelSelectedUserProvider);

      if (user == null) return;

      ref.read(adminPanelProvider.notifier).resetPassword(ref, user, passwordController.text.trim());

      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      if (ref.read(userProvider)!.isAdmin && ref.read(adminPanelSelectedUserProvider)!.isAdmin) {
        Navigator.pop(context);
      }
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }
  }
}
