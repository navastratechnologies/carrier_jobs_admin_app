import 'dart:developer';

import 'package:carrier_jobs_app/controller/instances.dart';
import 'package:carrier_jobs_app/view/add_job_additional_data.dart';
import 'package:carrier_jobs_app/view/helpers/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

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
  TextEditingController sharingController = TextEditingController();

  late MultiSelectController multiSelectController;

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
      multiSelectController = MultiSelectController();
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
                      child: MultiSelectDropDown(
                        inputDecoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: blackColor.withOpacity(0.3),
                              width: 1.2,
                            ),
                          ),
                        ),
                        controller: multiSelectController,
                        onOptionSelected: (options) {
                          debugPrint(options.toString());
                        },
                        hint: 'Category',
                        hintPadding: EdgeInsets.zero,
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: blackColor.withOpacity(0.4),
                        ),
                        options: options
                            .map((option) =>
                                ValueItem(label: option, value: option))
                            .toList(),
                        selectionType: SelectionType.multi,
                        chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                        dropdownHeight: 300,
                        optionTextStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                        ),
                        selectedOptionIcon: const Icon(Icons.check_circle),
                      ),
                    ),
                  ],
                ),
                fields(
                  sharingController,
                  'Please add sharing description',
                  'Please add sharing description',
                ),
                fields(
                  detailsController,
                  'How to apply',
                  'How to apply',
                ),
                const SizedBox(height: 20),
                Center(
                  child: MaterialButton(
                    color: mainColor,
                    onPressed: () async {
                      List<String> categoryList = [];
                      if (formKey.currentState?.validate() ?? false) {
                        for (var i = 0;
                            i < multiSelectController.selectedOptions.length;
                            i++) {
                          log("controller value is ${multiSelectController.selectedOptions[i].value}");
                          categoryList.add(
                            multiSelectController.selectedOptions[i].value
                                .toString(),
                          );
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddJobAdditionalDetail(
                              title: nameController.text,
                              location: selectedValue1,
                              category: categoryList
                                  .toString()
                                  .replaceAll('[', '')
                                  .replaceAll(']', '')
                                  .replaceAll(' , ', ','),
                              howToApply: detailsController.text,
                              sharingDetails: sharingController.text,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Next',
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
          fontWeight: FontWeight.w500,
        ),
        maxLines: hint.toString().contains('How to apply') ||
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
