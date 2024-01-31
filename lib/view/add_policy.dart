import 'package:carrier_jobs_app/controller/instances.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helpers/colors.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController urlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Privacy Policy',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: TextFormField(
                focusNode: focusNode,
                controller: urlController,
                style: GoogleFonts.poppins(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter privacy policy link here',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    color: blackColor.withOpacity(0.4),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter link before proceeding next';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 40),
            MaterialButton(
              color: mainColor,
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  focusNode.unfocus();
                  firestoreInstance
                      .collection('policies')
                      .doc('PWYkLh20ErYOCTuaO1wJ')
                      .update(
                    {
                      'url': urlController.text.toString(),
                    },
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        'Privacy Policy updated successfully',
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
          ],
        ),
      ),
    );
  }
}
