import 'dart:developer';

import 'package:carrier_jobs_app/controller/instances.dart';
import 'package:carrier_jobs_app/controller/notification_controller.dart';
import 'package:carrier_jobs_app/view/edit_job_additional_data.dart';
import 'package:carrier_jobs_app/view/helpers/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JobEditPage extends StatefulWidget {
  final String documentId;
  const JobEditPage({super.key, required this.documentId});

  @override
  State<JobEditPage> createState() => _JobEditPageState();
}

class _JobEditPageState extends State<JobEditPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  String quillData = '';

  String selectedValue = '';
  List<String> options = [];

  String selectedValue1 = '';
  List<String> options1 = [];

  Future getJobDetails() async {
    await jobsCollection.doc(widget.documentId).get().then(
      (value) {
        log("data received is ${value.get('job_name')}");
        setState(() {
          nameController.text = value.get('job_name');
          detailsController.text = value.get('details');
          quillData = value.get('additional_details');
        });
      },
    );
  }

  Future<void> fetchCategoryData() async {
    QuerySnapshot querySnapshot =
        await categoriesCollection.where('isLive', isEqualTo: 'live').get();
    List<String> fetchedOptions = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      fetchedOptions.add(doc['cat']);
    }

    setState(() {
      options = fetchedOptions;
      selectedValue = options.isNotEmpty ? options[0] : '';
    });
  }

  Future<void> fetchCountryData() async {
    QuerySnapshot querySnapshot =
        await countriesCollection.where('isLive', isEqualTo: 'live').get();
    List<String> fetchedOptions = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      fetchedOptions.add(doc['name']);
    }

    setState(() {
      options1 = fetchedOptions;
      selectedValue1 = options1.isNotEmpty ? options1[0] : '';
    });
  }

  @override
  void initState() {
    getJobDetails();
    fetchCategoryData();
    fetchCountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Job',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fields(
                  nameController,
                  'Please enter job name',
                  'Please enter job name',
                ),
                fields(
                  detailsController,
                  'How to apply',
                  'How to apply',
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      MaterialButton(
                        color: mainColor,
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            jobsCollection.doc(widget.documentId).update(
                              {
                                'job_name': nameController.text,
                                'date':
                                    "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
                                'details': detailsController.text,
                                'isLive': 'live',
                              },
                            ).then(
                              (value) async {
                                await FirebaseFirestore.instance
                                    .collection('tokens')
                                    .get()
                                    .then(
                                  (value1) {
                                    for (var i = 0;
                                        i < value1.docs.length;
                                        i++) {
                                      sendPushMessage(
                                        value1.docs[i]['token'],
                                        "Vacancy in ${nameController.text}",
                                        "New Job Uploaded!!!",
                                        widget.documentId,
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
                                  'Job updated successfully',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Update Now',
                          style: GoogleFonts.poppins(
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      MaterialButton(
                        color: mainColor,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditJobAdditionalDetail(
                              quillData: quillData,
                              documentId: widget.documentId,
                            ),
                          ),
                        ),
                        child: Text(
                          'Update Additional Details',
                          style: GoogleFonts.poppins(
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  fields(controller, hint, validator) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.poppins(
          color: blackColor,
          fontWeight: FontWeight.w500,
        ),
        maxLines: hint.toString().contains('additional') ||
                hint.toString().contains('sharing')
            ? 5
            : 1,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: 12,
            color: blackColor.withOpacity(0.4),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return validator;
          }
          return null;
        },
      ),
    );
  }
}
