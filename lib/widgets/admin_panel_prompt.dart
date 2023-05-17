import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminPanelPrompt extends StatelessWidget {
  const AdminPanelPrompt({super.key, required this.controller, required this.callback, required this.title});

  final TextEditingController controller;

  final AsyncCallback callback;

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  maxLength: 30,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  controller: controller,
                  decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(8)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton.outlined(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton.outlined(
                    onPressed: () async {
                      await callback();
                    },
                    icon: const Icon(Icons.check),
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
