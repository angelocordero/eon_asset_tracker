import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminPanelTab extends ConsumerWidget {
  const AdminPanelTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10),
      child: Visibility(
        visible: false,
        replacement: Container(),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
