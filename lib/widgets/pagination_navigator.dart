// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../core/constants.dart';
import '../core/custom_numeric_formatter.dart';
import '../core/providers.dart';

class PaginationNavigator extends ConsumerWidget {
  const PaginationNavigator({super.key});

  static final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  int inventoryItemCount = ref.watch(inventoryProvider).count;

    // int pages = (inventoryItemCount / itemsPerPage).ceil();

    int currentPage = ref.watch(currentInventoryPage);

    int pages = 100;

    int buttonCount = pages > 10 ? 11 : pages;

    List<Widget> buttons = List.generate(
      buttonCount,
      (index) {
        int buttonNum = currentPage - 4 + index;
        if (pages > 10 && currentPage >= 4 && currentPage <= pages - 5) {
          if (buttonNum == pages + 1) {
            return const Text(
              '...',
              style: TextStyle(fontSize: 30, color: Colors.transparent),
            );
          } else if (index == 0 || index == 10) {
            return const Text(
              '...',
              style: TextStyle(fontSize: 30),
            );
          } else {
            return ElevatedButton(
              style: buttonNum - 1 == currentPage
                  ? null
                  : const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                      foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
                    ),
              onPressed: () async {
                await _goToPage(ref, buttonNum);
              },
              child: Text(
                buttonNum.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            );
          }
        } else {
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
            style: buttonNum - 1 == currentPage
                ? null
                : const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                    foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
                  ),
            onPressed: () async {
              await _goToPage(ref, buttonNum);
            },
            child: Text(
              buttonNum.toString(),
              style: const TextStyle(fontSize: 12),
            ),
          );
        }
      },
    );

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Flexible(
            flex: 5,
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
                    Text((ref.watch(currentInventoryPage) + 1).toString()),
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
              ],
            ),
          ),
          const VerticalDivider(
            width: 40,
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Items per page:'),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField<int>(
                      isExpanded: true,
                      focusColor: Colors.transparent,
                      borderRadius: defaultBorderRadius,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: defaultBorderRadius,
                        ),
                      ),
                      value: 50,
                      items: const [
                        DropdownMenuItem<int>(
                          value: 50,
                          child: Text('50'),
                        ),
                        DropdownMenuItem<int>(
                          value: 100,
                          child: Text('100'),
                        ),
                        DropdownMenuItem<int>(
                          value: 200,
                          child: Text('200'),
                        ),
                      ],
                      onChanged: (int? value) {},
                    ),
                  ),
                  const Spacer(),
                  const Text('Jump to page:'),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: controller,
                          onTapOutside: (event) {
                            if (controller.text.trim().isEmpty) {
                              controller.text = '1';
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
                      const SizedBox(
                        width: 20,
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
            ),
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
    ref.read(checkedItemProvider.notifier).state = [];
  }
}
