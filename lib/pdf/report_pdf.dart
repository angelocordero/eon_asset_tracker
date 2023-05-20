// ignore_for_file: public_member_api_docs, sort_constructors_first

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Project imports:
import '../core/utils.dart';
import '../models/item_model.dart';

class ReportPDF {
  List<Item> inventoryItems;

  ReportPDF({
    required this.inventoryItems,
  });

  Future<Uint8List> generate() async {
    final pw.Document pdf = pw.Document();
    var data = await rootBundle.load("fonts/Roboto-Regular.ttf");
    pw.Font fallbackFont = pw.Font.ttf(data);

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData(
          textAlign: pw.TextAlign.center,
          defaultTextStyle: pw.TextStyle(
            font: fallbackFont,
            fontSize: 6,
          ),
        ),
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
                  pw.Text('E O N   A S S E T   T R A C K E R'),
                  pw.Text('I N V E N T O R Y   R E P O R T'),
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
            // ignore: deprecated_member_use
            pw.Table.fromTextArray(
              cellAlignment: pw.Alignment.center,
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(12.25),
                2: const pw.FlexColumnWidth(12.25),
                3: const pw.FlexColumnWidth(9.8),
                4: const pw.FlexColumnWidth(12.25),
                5: const pw.FlexColumnWidth(9.8),
                6: const pw.FlexColumnWidth(7.35),
                7: const pw.FlexColumnWidth(7.35),
                8: const pw.FlexColumnWidth(7.35),
                9: const pw.FlexColumnWidth(10.78),
                10: const pw.FlexColumnWidth(10.78),
              },
              headerStyle: const pw.TextStyle(fontSize: 7),
              data: generateData(inventoryItems),
              headerCount: 11,
              headers: [
                '',
                'A S S E T   I D',
                'I T E M   N A M E',
                'D E P A R T M E N T',
                'P E R S O N\nA C C O U N T A B L E',
                'C A T E G O R Y',
                'S T A T U S',
                'U N I T',
                'P R I C E',
                'D A T E\nP U R C H A S E D',
                'D A T E\nR E C E I V E D',
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  List<List<dynamic>> generateData(List<Item> items) {
    List<List<dynamic>> data = [];

    for (int i = 0; i < items.length; i++) {
      Item item = items[i];

      data.add([
        (i + 1).toString(),
        item.assetID,
        item.name,
        item.department.departmentName,
        item.personAccountable ?? '',
        item.category.categoryName,
        item.status.name,
        item.unit,
        item.datePurchased == null ? '' : priceToString(item.price ?? 0),
        item.datePurchased == null ? '' : dateToString(item.datePurchased!),
        dateToString(item.dateReceived),
      ]);
    }

    return data;
  }
}
