import 'package:carrier_jobs_app/controller/instances.dart';
import 'package:carrier_jobs_app/view/helpers/colors.dart';
import 'package:carrier_jobs_app/view/helpers/responsive_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbacksList extends StatefulWidget {
  const FeedbacksList({
    super.key,
  });

  @override
  State<FeedbacksList> createState() => _FeedbacksListState();
}

class _FeedbacksListState extends State<FeedbacksList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jobs List',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: feedbacksCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something Wrong !!!, Please contact with developer',
                style: GoogleFonts.poppins(),
              ),
            );
          } else if (snapshot.hasData) {
            return snapshot.data!.docs.isEmpty
                ? Center(
                    child: Text(
                      'No data available right now',
                      style: GoogleFonts.poppins(),
                    ),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      return MaterialButton(
                        color: whiteColor,
                        padding: const EdgeInsets.all(20),
                        onPressed: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: mainColor,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                documentSnapshot['number'],
                                style: GoogleFonts.poppins(
                                  color: whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$index.',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    width: 2,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: blackColor.withOpacity(0.05),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) / 1.3,
                                  child: Text(
                                    documentSnapshot['msg'],
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                documentSnapshot['time'],
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: blackColor.withOpacity(0.4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
          }
          return SizedBox(
            height: displayHeight(context) / 1.5,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
