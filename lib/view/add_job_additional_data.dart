import 'dart:developer';

import 'package:carrier_jobs_app/controller/instances.dart';
import 'package:carrier_jobs_app/controller/notification_controller.dart';
import 'package:carrier_jobs_app/view/helpers/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quill_html_converter/quill_html_converter.dart';

class AddJobAdditionalDetail extends StatefulWidget {
  final String title, location, category, howToApply, sharingDetails;
  final String? quillData;
  const AddJobAdditionalDetail({
    super.key,
    required this.title,
    required this.location,
    required this.category,
    this.quillData,
    required this.howToApply,
    required this.sharingDetails,
  });

  @override
  State<AddJobAdditionalDetail> createState() => _AddJobAdditionalDetailState();
}

class _AddJobAdditionalDetailState extends State<AddJobAdditionalDetail> {
  QuillController quillController = QuillController.basic();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Additional Details',
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
                  jobsCollection.add(
                    {
                      'age_limit': '',
                      'category': widget.category,
                      'job_department': '',
                      'job_location': widget.location,
                      'job_name': widget.title,
                      'no_of_posts': '',
                      'qualification': '',
                      'salary': '',
                      'date':
                          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                      'details': widget.howToApply,
                      'isLive': 'live',
                      'additional_details': quillController.document
                          .toDelta()
                          .toHtml()
                          .toString(),
                      'sharing_data': widget.sharingDetails,
                    },
                  ).then(
                    (value) async {
                      log('new id is ${value.id}');
                      await FirebaseFirestore.instance
                          .collection('tokens')
                          .get()
                          .then(
                        (value1) {
                          for (var i = 0; i < value1.docs.length; i++) {
                            sendPushMessage(
                              value1.docs[i]['token'],
                              "Vacancy in ${widget.title}",
                              "New Job Uploaded!!!",
                              value.id.toString(),
                            );
                          }
                        },
                      );
                    },
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        'Job Added successfully',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Add Now',
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
