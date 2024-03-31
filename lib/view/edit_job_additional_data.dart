import 'dart:developer';

import 'package:carrier_jobs_app/controller/instances.dart';
import 'package:carrier_jobs_app/view/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quill_html_converter/quill_html_converter.dart';

class EditJobAdditionalDetail extends StatefulWidget {
  final String documentId, quillData;
  const EditJobAdditionalDetail({
    super.key,
    required this.quillData,
    required this.documentId,
  });

  @override
  State<EditJobAdditionalDetail> createState() =>
      _EditJobAdditionalDetailState();
}

class _EditJobAdditionalDetailState extends State<EditJobAdditionalDetail> {
  QuillController quillController = QuillController.basic();

  @override
  void initState() {
    setState(() {
      quillController.document = Document.fromDelta(
        Document.fromHtml(widget.quillData),
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
                  log('raw data is ${quillController.document.toPlainText()}');
                  jobsCollection.doc(widget.documentId).update(
                    {
                      'additional_details': quillController.document
                          .toDelta()
                          .toHtml()
                          .toString(),
                      'sharing_data':
                          quillController.document.toPlainText().toString(),
                    },
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        'Additional details updated successfully',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
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
