import 'package:carrier_jobs_app/controller/instances.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helpers/colors.dart';

class CountryyPage extends StatelessWidget {
  const CountryyPage({super.key});

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController urlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Country',
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
                  hintText: 'Enter country name here',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    color: blackColor.withOpacity(0.4),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter name before proceeding next';
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
                  countriesCollection.add(
                    {
                      'isLive': 'live',
                      'name': urlController.text,
                    },
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        'Country updated successfully',
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
