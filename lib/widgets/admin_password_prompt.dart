import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdminPasswordPrompt extends StatelessWidget {
  const AdminPasswordPrompt(
      {super.key, required this.controller, required this.callback});

  final TextEditingController controller;

  final AsyncCallback callback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please enter admin password',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  onSubmitted: (value) async {
                    await callback();
                  },
                  controller: controller,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await callback();
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
