import 'package:eon_asset_tracker/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../core/custom_numeric_formatter.dart';

class PaginationNavigator extends ConsumerWidget {
  const PaginationNavigator({super.key});

  static final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int inventoryItemCount = ref.watch(inventoryProvider).count;

    int pages = (inventoryItemCount / itemsPerPage).ceil();

    int buttonCount = pages > 10 ? 11 : pages;

    List<Widget> buttons = List.generate(
      buttonCount,
      (index) {
        int buttonNum = index + 1;

        if (index == 5 && pages > 10) {
          return const Text(
            '...',
            style: TextStyle(fontSize: 30),
          );
        }

        if (pages > 10) {
          if (index >= buttonCount ~/ 2) {
            buttonNum = pages + index - 10;
          }
        }

        return ElevatedButton(
          onPressed: () async {
            await _goToPage(ref, buttonNum);
          },
          child: Text(
            buttonNum.toString(),
            style: const TextStyle(fontSize: 12),
          ),
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await _goToPage(ref, 1);
                },
                child: const Text(
                  'First',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  int prevPage = ref.read(currentInventoryPage);

                  if (prevPage <= 0) return;

                  await _goToPage(ref, ref.read(currentInventoryPage));
                },
                child: const Text(
                  'Previous',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  int nextPage = ref.read(currentInventoryPage) + 2;

                  if (nextPage > pages) return;

                  await _goToPage(ref, nextPage);
                },
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _goToPage(ref, pages);
                },
                child: const Text(
                  'Last',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            runAlignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            alignment: WrapAlignment.start,
            children: buttons,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Jump to page:'),
              SizedBox(
                width: 50,
                child: TextField(
                  controller: controller,
                  onTapOutside: (event) {
                    if (controller.text.trim().isEmpty) {
                      controller.text = '0';
                    }
                  },
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp("[0-9]"), allow: true),
                    CustomNumericFormatter(pages),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  int? page = int.tryParse(controller.text.trim());

                  if (page == null) return;

                  _goToPage(ref, page);
                },
                child: const Text('Go'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _goToPage(WidgetRef ref, int buttonNum) async {
    await ref
        .read(inventoryProvider.notifier)
        .getInventoryFromPage(page: buttonNum - 1, query: ref.read(searchQueryProvider), filter: ref.read(searchFilterProvider));
    ref.read(currentInventoryPage.notifier).state = buttonNum - 1;
  }
}
