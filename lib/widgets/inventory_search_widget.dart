// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../core/constants.dart';
// import '../core/providers.dart';
// import '../core/utils.dart';
// import '../models/category_model.dart';
// import '../models/department_model.dart';
// import '../notifiers/categories_notifier.dart';
// import '../notifiers/departments_notifier.dart';
// import '../notifiers/inventory_notifier.dart';
// import 'search_daterange_picker.dart';

// class InventorySearchWidget extends ConsumerStatefulWidget {
//   const InventorySearchWidget({super.key, required this.controller});

//   final TextEditingController controller;

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _InventorySearchWidgetState();
// }

// class _InventorySearchWidgetState extends ConsumerState<InventorySearchWidget> {
//   Widget _searchField = Container();

//   DateTimeRange range = DateTimeRange(start: DateTime.now(), end: DateTime.now());

//   @override
//   void initState() {
//     _searchField = _queryTextField();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         _searchByDropdown(ref),
//         const SizedBox(
//           width: 20,
//         ),
//         _searchField,
//         const SizedBox(
//           width: 20,
//         ),
//         _searchButton(ref),
//       ],
//     );
//   }

//   ElevatedButton _searchButton(WidgetRef ref) {
//     return ElevatedButton(
//       onPressed: () async {
//         await _search();
//       },
//       child: const Text('Search'),
//     );
//   }

//   Future<void> _search() async {
//     InventorySearchFilter filter = ref.read(searchFilterProvider);

//     if (filter == InventorySearchFilter.assetID ||
//         filter == InventorySearchFilter.itemName ||
//         filter == InventorySearchFilter.personAccountable ||
//         filter == InventorySearchFilter.unit ||
//         filter == InventorySearchFilter.itemDescription ||
//         filter == InventorySearchFilter.remarks) {
//       ref.read(searchQueryProvider.notifier).state = widget.controller.text.trim();
//     } else if (filter == InventorySearchFilter.datePurchased || filter == InventorySearchFilter.dateReceived) {
//       ref.read(searchQueryProvider.notifier).state = range;
//     }

//     ref.read(currentInventoryPage.notifier).state = 0;

//     dynamic query = ref.read(searchQueryProvider);
//     if (query is DateTimeRange) {
//       await ref.read(inventoryNotifierProvider.notifier).initFilteredInventory();
//     } else if (query.trim().isEmpty) {
//       ref.invalidate(inventoryNotifierProvider);
//     } else {
//       await ref.read(inventoryNotifierProvider.notifier).initFilteredInventory();
//     }
//   }

//   SizedBox _searchByDropdown(WidgetRef ref) {
//     return SizedBox(
//       width: 200,
//       child: ButtonTheme(
//         alignedDropdown: true,
//         child: DropdownButtonFormField<InventorySearchFilter>(
//           isExpanded: true,
//           iconSize: 12,
//           focusColor: Colors.transparent,
//           borderRadius: defaultBorderRadius,
//           decoration: InputDecoration(
//             labelText: 'Search By',
//             isDense: true,
//             contentPadding: const EdgeInsets.all(12),
//             border: OutlineInputBorder(
//               borderRadius: defaultBorderRadius,
//             ),
//           ),
//           value: ref.watch(searchFilterProvider),
//           items: InventorySearchFilter.values.map((value) {
//             return DropdownMenuItem<InventorySearchFilter>(
//               value: value,
//               child: Text(
//                 inventoryFilterEnumToDisplayString(value) ?? '',
//                 overflow: TextOverflow.ellipsis,
//               ),
//             );
//           }).toList(),
//           onChanged: (InventorySearchFilter? filter) {
//             if (filter == null) return;

//             if (filter == InventorySearchFilter.assetID ||
//                 filter == InventorySearchFilter.itemName ||
//                 filter == InventorySearchFilter.personAccountable ||
//                 filter == InventorySearchFilter.unit ||
//                 filter == InventorySearchFilter.itemDescription ||
//                 filter == InventorySearchFilter.remarks) {
//               setState(() {
//                 _searchField = _queryTextField();
//               });
//             } else if (filter == InventorySearchFilter.status) {
//               setState(
//                 () {
//                   ref.read(searchQueryProvider.notifier).state = ItemStatus.values.first.name;
//                   _searchField = _queryDropdownField(
//                     ItemStatus.values.map(
//                       (e) {
//                         return DropdownMenuItem(
//                           onTap: () {
//                             ref.read(searchQueryProvider.notifier).state = e.name;
//                           },
//                           value: e.name,
//                           child: Text(e.name),
//                         );
//                       },
//                     ).toList(),
//                   );
//                 },
//               );
//             } else if (filter == InventorySearchFilter.department) {
//               ref.watch(departmentsNotifierProvider).when(
//                     data: (List<Department> departments) {
//                       ref.read(searchQueryProvider.notifier).state = departments.first.departmentID;
//                       setState(
//                         () {
//                           _searchField = _queryDropdownField(
//                             departments.map(
//                               (e) {
//                                 return DropdownMenuItem(
//                                   onTap: () {
//                                     ref.read(searchQueryProvider.notifier).state = e.departmentID;
//                                   },
//                                   value: e.departmentID,
//                                   child: Text(e.departmentName),
//                                 );
//                               },
//                             ).toList(),
//                           );
//                         },
//                       );
//                     },
//                     error: (e, st) => Center(
//                       child: Text(e.toString()),
//                     ),
//                     loading: () => const Center(
//                       child: Text('Loading...'),
//                     ),
//                   );
//             } else if (filter == InventorySearchFilter.category) {
//               ref.watch(categoriesNotifierProvider).when(
//                     data: (List<ItemCategory> categories) {
//                       ref.read(searchQueryProvider.notifier).state = categories.first.categoryID!;

//                       setState(
//                         () {
//                           _searchField = _categoryField(categories);
//                         },
//                       );
//                     },
//                     error: (e, st) => Center(
//                       child: Text(e.toString()),
//                     ),
//                     loading: () => const Center(
//                       child: Text('Loading...'),
//                     ),
//                   );
//             } else if (filter == InventorySearchFilter.datePurchased || filter == InventorySearchFilter.dateReceived) {
//               setState(
//                 () {
//                   _searchField = SearchDaterangePicker(
//                     callback: (DateTimeRange newRange) {
//                       range = newRange;
//                     },
//                   );
//                 },
//               );
//             }

//             ref.read(searchFilterProvider.notifier).state = filter;
//           },
//         ),
//       ),
//     );
//   }

//   Widget _categoryField(List<ItemCategory> categories) {
//     return SizedBox(
//       width: 300,
//       child: Autocomplete<ItemCategory>(
//         fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
//           focusNode.addListener(
//             () {
//               if (!focusNode.hasFocus) {
//                 // checks if the current text in the controller is a category name
//                 // if true, returns that category,
//                 // if false, returns last category that was matched
//                 ItemCategory? buffer = categories.singleWhere((element) => element.categoryName == textEditingController.text.trim(),
//                     orElse: () => categories.firstWhere((element) => element.categoryID == ref.read(searchQueryProvider).toString()));

//                 textEditingController.text = buffer.categoryName;
//               }
//             },
//           );

//           return TextFormField(
//             decoration: const InputDecoration(
//               isDense: true,
//               contentPadding: EdgeInsets.all(14),
//             ),
//             controller: textEditingController,
//             focusNode: focusNode,
//             onFieldSubmitted: (String value) {
//               onFieldSubmitted();
//             },
//           );
//         },
//         initialValue: TextEditingValue(text: categories.first.categoryName),
//         optionsBuilder: (TextEditingValue option) {
//           return ref.watch(categoriesNotifierProvider).when(
//                 data: (List<ItemCategory> categories) {
//                   return categories.where(
//                     (element) => element.categoryName.toLowerCase().contains(
//                           option.text.toLowerCase().trim(),
//                         ),
//                   );
//                 },
//                 error: (e, st) => [],
//                 loading: () => [],
//               );
//         },
//         displayStringForOption: (option) => option.categoryName,
//         onSelected: (option) {
//           setState(() {
//             ref.read(searchQueryProvider.notifier).state = option.categoryID;
//           });
//         },
//         optionsViewBuilder: (context, onSelected, options) {
//           /// sets the max number of displayed options in dropdown
//           int maxOptionsInView = options.length >= 5 ? 5 : options.length;

//           return Align(
//             alignment: Alignment.topLeft,
//             child: Material(
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
//               ),
//               child: SizedBox(
//                 width: 300,
//                 height: 50 * maxOptionsInView.toDouble(),
//                 child: ListView.builder(
//                   itemCount: options.length,
//                   itemBuilder: (context, index) {
//                     ItemCategory category = options.elementAt(index);

//                     return InkWell(
//                       onTap: () {
//                         onSelected(category);
//                       },
//                       child: Builder(
//                         builder: (BuildContext context) {
//                           final bool highlight = AutocompleteHighlightedOption.of(context) == index;
//                           if (highlight) {
//                             SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
//                               Scrollable.ensureVisible(context, alignment: 0.5);
//                             });
//                           }
//                           return Container(
//                             color: highlight ? Theme.of(context).focusColor : null,
//                             padding: const EdgeInsets.all(16.0),
//                             child: Text(category.categoryName),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   SizedBox _queryTextField() {
//     return SizedBox(
//       width: 200,
//       child: TextField(
//         onSubmitted: (value) {
//           _search();
//         },
//         controller: widget.controller,
//         decoration: const InputDecoration(
//           prefixIcon: Icon(
//             Icons.search,
//             size: 20,
//           ),
//           isDense: true,
//           contentPadding: EdgeInsets.all(8),
//         ),
//       ),
//     );
//   }

//   SizedBox _queryDropdownField(List<DropdownMenuItem<String>> items) {
//     return SizedBox(
//       width: 200,
//       child: DropdownButtonFormField(
//         value: ref.watch(searchQueryProvider),
//         focusColor: Colors.transparent,
//         borderRadius: defaultBorderRadius,
//         decoration: InputDecoration(
//           labelText: 'Search By',
//           isDense: true,
//           contentPadding: const EdgeInsets.all(12),
//           border: OutlineInputBorder(
//             borderRadius: defaultBorderRadius,
//           ),
//         ),
//         items: items,
//         onChanged: (value) {
//           if (value == null) return;

//           ref.read(searchQueryProvider.notifier).state = value;
//         },
//       ),
//     );
//   }
// }
