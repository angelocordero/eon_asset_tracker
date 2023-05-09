// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:eon_asset_tracker/core/utils.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/category_model.dart';
import '../models/department_model.dart';
import '../models/item_model.dart';

class ReportPDF {
  List<Item> inventoryItems;
  List<Department> departments;
  List<ItemCategory> categories;

  ReportPDF({
    required this.inventoryItems,
    required this.departments,
    required this.categories,
  });

  Future<Uint8List> generate() async {
    final pw.Document pdf = pw.Document();
    var data = await rootBundle.load("fonts/Roboto-Regular.ttf");
    pw.Font fallbackFont = pw.Font.ttf(data);

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: fallbackFont)),
        margin: const pw.EdgeInsets.all(10.0),
        pageFormat: PdfPageFormat.letter.landscape,
        header: (context) {
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            mainAxisSize: pw.MainAxisSize.max,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text('Asset Tracker'),
                  pw.Text('Inventory Report'),
                  pw.Text(
                    dateTimeToString(DateTime.now()),
                  ),
                  pw.SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          );
        },
        build: (context) {
          return [
            pw.Table.fromTextArray(
              columnWidths: {
                0: const pw.FlexColumnWidth(12.25),
                1: const pw.FlexColumnWidth(12.25),
                2: const pw.FlexColumnWidth(9.8),
                3: const pw.FlexColumnWidth(12.25),
                4: const pw.FlexColumnWidth(9.8),
                5: const pw.FlexColumnWidth(7.35),
                6: const pw.FlexColumnWidth(7.35),
                7: const pw.FlexColumnWidth(7.35),
                8: const pw.FlexColumnWidth(10.78),
                9: const pw.FlexColumnWidth(10.78),
              },
              headerStyle: const pw.TextStyle(fontSize: 8),
              data: inventoryItems.map((Item item) {
              
                return [
                  item.assetID,
                  item.name,
                  item.department.departmentName,
                  item.personAccountable ?? '',
                  item.category.categoryName,
                  item.status.name,
                  item.unit,
                  priceToString(item.price ?? 0),
                  item.datePurchased == null
                      ? ''
                      : dateToString(item.datePurchased!),
                  dateToString(item.dateReceived),
                ];
              }).toList(),
              headerCount: 10,
              headers: [
                'Asset ID',
                'Item Name',
                'Department',
                'Person Accountable',
                'Category',
                'Status',
                'Unit',
                'Price',
                'Date Purchased',
                'Date Received',
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
