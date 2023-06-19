import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'search_popup.dart';
import 'slide_route.dart';

class AdvancedInventorySearch extends ConsumerStatefulWidget {
  const AdvancedInventorySearch({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdvancedInventorySearchState();
}

class _AdvancedInventorySearchState extends ConsumerState<AdvancedInventorySearch> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _clearFilterChip();
  }

  Directionality _clearFilterChip() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ActionChip(
        label: const Text('Search'),
        avatar: const Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context,
            SlideRoute(
              builder: (context) {
                return const SearchPopup();
              },
            ),
          );
        },
      ),
    );
  }
}

// Widget _assetIDTextField() {
//   return SizedBox(
//     width: 200,
//     child: TextField(
//       decoration: InputDecoration(
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         labelText: 'Asset ID',
//         isDense: true,
//         contentPadding: const EdgeInsets.all(10),
//         border: OutlineInputBorder(
//           borderRadius: defaultBorderRadius,
//         ),
//       ),
//     ),
//   );
// }

// Widget _itemNameTextField() {
//   return SizedBox(
//     width: 200,
//     child: TextField(
//       decoration: InputDecoration(
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         labelText: 'Item Name',
//         isDense: true,
//         contentPadding: const EdgeInsets.all(10),
//         border: OutlineInputBorder(
//           borderRadius: defaultBorderRadius,
//         ),
//       ),
//     ),
//   );
// }

// Widget _departmentActionChip() {
//   return _customActionChip('Department', () {});
// }

// Widget _personAccountableTextField() {
//   return const SizedBox(
//     width: 200,
//     child: TextField(),
//   );
// }

// Widget _categoryActionChip() {
//   return _customActionChip('Category', () {});
// }

// Widget _statusActionChip() {
//   return _customActionChip('Status', () {});
// }

// Widget _unitTextField() {
//   return const SizedBox(
//     width: 200,
//     child: TextField(),
//   );
// }

// Widget _priceTextField() {
//   return const SizedBox(
//     width: 200,
//     child: TextField(),
//   );
// }

// Widget _datePurchasedActionChip() {
//   return _customActionChip('Date Purchased', () {});
// }

// Widget _dateReceivedActionChip() {
//   return _customActionChip('Date Received', () {});
// }

// Widget _lastScannedActionChip() {
//   return _customActionChip('Last Scanned', () {});
// }

// Widget _customActionChip(String text, VoidCallback onPressed) {
//   return Directionality(
//     textDirection: TextDirection.rtl,
//     child: ActionChip(
//       avatar: const Icon(Icons.keyboard_arrow_down),
//       label: Text(text),
//       onPressed: onPressed,
//     ),
//   );
// }
