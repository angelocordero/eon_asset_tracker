import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database_api.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        try {
          DatabaseAPI.init(ref);

          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, 'login');
        } catch (e) {
          debugPrint(e.toString());
          EasyLoading.showError(e.toString());
        }
      },
    );

    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Loading'),
          SizedBox(
            width: 50,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
