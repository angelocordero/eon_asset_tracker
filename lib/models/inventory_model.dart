// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import '../core/utils.dart';
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

  Inventory sort(TableSort tableSort) {
    switch (tableSort.tableColumn) {
      case TableColumn.assetID:
        if (tableSort.sortOrder == SortOrder.ascending) {
          items.sort((a, b) => a.assetID.compareTo(b.assetID));
        } else if (tableSort.sortOrder == SortOrder.descending) {
          items.sort((a, b) => b.assetID.compareTo(a.assetID));
        }
        break;

      case TableColumn.itemName:
        if (tableSort.sortOrder == SortOrder.ascending) {
          items.sort((a, b) => a.name.compareTo(b.name));
        } else if (tableSort.sortOrder == SortOrder.descending) {
          items.sort((a, b) => b.name.compareTo(a.name));
        }
        break;

      case TableColumn.departmentName:
        if (tableSort.sortOrder == SortOrder.ascending) {
          items.sort((a, b) => a.department.departmentName.compareTo(b.department.departmentName));
        } else if (tableSort.sortOrder == SortOrder.descending) {
          items.sort((a, b) => b.department.departmentName.compareTo(a.department.departmentName));
        }
        break;

      case TableColumn.personAccountable:
        if (tableSort.sortOrder == SortOrder.ascending) {
          items.sort((a, b) => compareStrings(a.personAccountable, b.personAccountable, descending: false));
        } else if (tableSort.sortOrder == SortOrder.descending) {
          items.sort((a, b) => compareStrings(a.personAccountable, b.personAccountable, descending: true));
        }
        break;

      case TableColumn.category:
        if (tableSort.sortOrder == SortOrder.ascending) {
          items.sort((a, b) => a.category.categoryName.compareTo(b.category.categoryName));
        } else if (tableSort.sortOrder == SortOrder.descending) {
          items.sort((a, b) => b.category.categoryName.compareTo(a.category.categoryName));
        }
        break;

      case TableColumn.status:
        if (tableSort.sortOrder == SortOrder.ascending) {
          items.sort((a, b) => a.status.name.compareTo(b.status.name));
        } else if (tableSort.sortOrder == SortOrder.descending) {
          items.sort((a, b) => b.status.name.compareTo(a.status.name));
        }

      case TableColumn.unit:
        if (tableSort.sortOrder == SortOrder.ascending) {
          items.sort((a, b) => compareStrings(a.unit, b.unit, descending: false));
        } else if (tableSort.sortOrder == SortOrder.descending) {
          items.sort((a, b) => compareStrings(a.unit, b.unit, descending: true));
        }
        break;

      case TableColumn.price:
        if (tableSort.sortOrder == SortOrder.ascending) {
          items.sort((a, b) => compareValues(a.price, b.price, descending: false));
        } else {
          items.sort((a, b) => compareValues(a.price, b.price, descending: true));
        }
        break;

      case TableColumn.datePurchased:
        if (tableSort.sortOrder == SortOrder.ascending) {
          items.sort((a, b) => compareDates(a.datePurchased, b.datePurchased, descending: false));
        } else if (tableSort.sortOrder == SortOrder.descending) {
          items.sort((a, b) => compareDates(a.datePurchased, b.datePurchased, descending: true));
        }
        break;

      case TableColumn.dateReceived:
        if (tableSort.sortOrder == SortOrder.ascending) {
          items.sort((a, b) => a.dateReceived.compareTo(b.dateReceived));
        } else if (tableSort.sortOrder == SortOrder.descending) {
          items.sort((a, b) => b.dateReceived.compareTo(a.dateReceived));
        }
        break;

      case TableColumn.lastScanned:
        if (tableSort.sortOrder == SortOrder.ascending) {
          items.sort((a, b) => a.lastScanned.compareTo(b.lastScanned));
        } else if (tableSort.sortOrder == SortOrder.descending) {
          items.sort((a, b) => b.lastScanned.compareTo(a.lastScanned));
        }
        break;

      default:
    }

    return Inventory(items: items, count: count);
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
