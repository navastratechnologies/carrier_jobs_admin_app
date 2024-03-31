import 'dart:convert';
import 'dart:developer';

import 'package:carrier_jobs_app/view/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({
    super.key,
  });

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  QuillController quillController = QuillController.basic();

  String convertQuillDeltaToJson(String quillDeltaJson) {
    Map<String, dynamic> deltaJson = jsonDecode(quillDeltaJson);

    List<Map<String, dynamic>> ops =
        List<Map<String, dynamic>>.from(deltaJson['ops']);

    String html = '';
    for (var op in ops) {
      if (op['insert'] != null) {
        html += _processInsert(op['insert']);
      }
    }

    return html;
  }

  String _processInsert(dynamic insert) {
    if (insert is String) {
      return insert; // If insert is a string, return as is
    } else if (insert is Map<String, dynamic> && insert['attributes'] != null) {
      // If insert is a map with attributes
      String text = insert['insert'].toString();
      Map<String, dynamic> attributes = insert['attributes'];

      // Check if color attribute exists
      if (attributes.containsKey('color')) {
        String color = attributes['color'].toString();
        return '<span style="color: "$color";">$text</span>'; // Wrap text with color style
      } else {
        return text; // If no color attribute, return text as is
      }
    } else {
      return ''; // Return empty string for unsupported insert type
    }
  }

  @override
  void initState() {
    setState(() {
      quillController.document = Document.fromDelta(
        Document.fromHtml(
            '<h1><span class="ql-size-large color-red" style="color: red;">Test</span></h1>'),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Additional Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: quillController,
              ),
            ),
            Expanded(
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  controller: quillController,
                  readOnly: false,
                  autoFocus: true,
                ),
              ),
            ),
            Center(
              child: MaterialButton(
                color: mainColor,
                onPressed: () async {
                  // String quillDeltaJson =
                  //     '{"ops":${quillController.document.toDelta().toJson()}}';
                  // String html = convertQuillDeltaToJson(
                  //   quillController.document.toDelta().toJson().toString(),
                  // );
                  log('raw data is ${quillController.document.toDelta().toJson()}');
                },
                child: Text(
                  'Update Now',
                  style: GoogleFonts.poppins(
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
