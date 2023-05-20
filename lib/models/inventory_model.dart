// ignore_for_file: public_member_api_docs, sort_constructors_first

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'item_model.dart';

class Inventory {
  List<Item> items;
  int count;
  Inventory({
    required this.items,
    required this.count,
  });

  Inventory copyWith({
    List<Item>? items,
    int? count,
  }) {
    return Inventory(
      items: items ?? this.items,
      count: count ?? this.count,
    );
  }

  factory Inventory.empty() {
    return Inventory(items: [], count: 0);
  }

  @override
  String toString() => 'Inventory(items: $items, count: $count)';

  @override
  bool operator ==(covariant Inventory other) {
    if (identical(this, other)) return true;

    return listEquals(other.items, items) && other.count == count;
  }

  @override
  int get hashCode => items.hashCode ^ count.hashCode;
}
