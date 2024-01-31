import 'dart:developer';

import 'package:carrier_jobs_app/controller/instances.dart';
import 'package:carrier_jobs_app/controller/notification_controller.dart';
import 'package:carrier_jobs_app/view/helpers/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController ageController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  String selectedValue = '';
  List<String> options = [];

  String selectedValue1 = '';
  List<String> options1 = [];

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
    fetchCategoryData();
    fetchCountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Jobs',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Select Job Location',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: blackColor.withOpacity(0.4),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedValue1,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue1 = newValue!;
                            log('drop value is $selectedValue1');
                          });
                        },
                        items: options1
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: blackColor.withOpacity(0.4),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                fields(
                  departmentController,
                  'Please enter job department',
                  'Please enter job department',
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Select Category',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: blackColor.withOpacity(0.4),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                            log('drop value is $selectedValue');
                          });
                        },
                        items: options
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: blackColor.withOpacity(0.4),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                fields(
                  ageController,
                  'Please enter required age limit',
                  'Please enter required age limit',
                ),
                fields(
                  postController,
                  'Please enter no of posts available',
                  'Please enter no of posts available',
                ),
                fields(
                  qualificationController,
                  'Please enter your qualification',
                  'Please enter your qualification',
                ),
                fields(
                  salaryController,
                  'Please enter salary',
                  'Please enter salary',
                ),
                fields(
                  detailsController,
                  'Please enter additional details',
                  'Please enter additional details',
                ),
                const SizedBox(height: 20),
                Center(
                  child: MaterialButton(
                    color: mainColor,
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        jobsCollection.add(
                          {
                            'age_limit': ageController.text,
                            'category': selectedValue,
                            'job_department': departmentController.text,
                            'job_location': selectedValue1,
                            'job_name': nameController.text,
                            'no_of_posts': postController.text,
                            'qualification': qualificationController.text,
                            'salary': salaryController.text,
                            'date':
                                "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                            'details': detailsController.text,
                            'isLive': 'live',
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
                                    "${postController.text} posts in ${nameController.text}",
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
                      }
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
          fontWeight: FontWeight.bold,
        ),
        maxLines: hint.toString().contains('additional') ? 5 : 1,
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
