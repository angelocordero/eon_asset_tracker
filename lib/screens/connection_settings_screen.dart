import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../models/connection_setttings_model.dart';

class ConnectionSettingsScreen extends ConsumerWidget {
  const ConnectionSettingsScreen({
    Key? key,
    required this.localIPController,
    required this.portController,
    required this.userController,
    required this.passwordController,
    required this.dbNameController,
  }) : super(key: key);

  final TextEditingController localIPController;
  final TextEditingController portController;
  final TextEditingController userController;
  final TextEditingController passwordController;
  final TextEditingController dbNameController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 6,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'C O N N E C T I O N \nS E T T I N G S',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text('IP'),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: localIPController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text('Port'),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp("[0-9.]"), allow: true)
                  ],
                  controller: portController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text('Username'),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: userController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text('Password'),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text('Database name'),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: dbNameController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      ConnectionSettings connectionSettings =
                          ConnectionSettings(
                        databaseName: dbNameController.text.trim(),
                        username: userController.text.trim(),
                        password: passwordController.text.trim(),
                        ip: localIPController.text.trim(),
                        port: int.tryParse(portController.text.trim()) ?? 0,
                      );

                      await settingsBox.putAll(connectionSettings.toMap());

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
