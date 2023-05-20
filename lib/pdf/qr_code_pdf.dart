// ignore_for_file: public_member_api_docs, sort_constructors_first

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Project imports:
import '../models/category_model.dart';
import '../models/department_model.dart';
import '../models/item_model.dart';

class QRCodePDF {
  List<Item> items;
  List<Department> departments;
  List<ItemCategory> categories;
  QRCodePDF({
    required this.items,
    required this.departments,
    required this.categories,
  });

  Future<Uint8List> generate() {
    final pw.Document pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(0.0),
        pageFormat: PdfPageFormat.letter.portrait,
        build: (context) {
          return [
            stickerGrid(),
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget stickerGrid() {
    return pw.GridView(
      childAspectRatio: 0.30,
      crossAxisCount: 2,
      children: items.map((Item item) {
        return qrCodeSticker(
          item,
        );
      }).toList(),
    );
  }

  pw.Widget qrCodeSticker(
    Item item,
  ) {
    String assetID = item.assetID;
    String departmentName = item.department.departmentName;

    String personAccountable = item.personAccountable ?? '';
    String name = item.name;
    String category = item.category.categoryName;

    return pw.Padding(
      padding: const pw.EdgeInsets.all(1),
      child: pw.Container(
        decoration: pw.BoxDecoration(border: pw.Border.all()),
        padding: const pw.EdgeInsets.all(2),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          mainAxisSize: pw.MainAxisSize.min,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Flexible(
              flex: 3,
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.BarcodeWidget(
                    height: 50,
                    width: 50,
                    data: assetID,
                    drawText: true,
                    barcode: pw.Barcode.qrCode(),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    assetID,
                    overflow: pw.TextOverflow.clip,
                    style: const pw.TextStyle(fontSize: 7),
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 0),
            pw.Flexible(
              flex: 7,
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.max,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 10),
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      name,
                      maxLines: 1,
                      softWrap: false,
                      overflow: pw.TextOverflow.clip,
                      style: const pw.TextStyle(fontSize: 7),
                    ),
                  ),
                  pw.Divider(),
                  pw.Column(
                    mainAxisSize: pw.MainAxisSize.max,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        departmentName,
                        style: const pw.TextStyle(fontSize: 6),
                      ),
                      pw.SizedBox(height: 8),
                      if (personAccountable.isNotEmpty)
                        pw.Text(
                          personAccountable,
                          style: const pw.TextStyle(fontSize: 6),
                        ),
                      if (personAccountable.isNotEmpty) pw.SizedBox(height: 8),
                      pw.Text(
                        category,
                        style: const pw.TextStyle(fontSize: 6),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
