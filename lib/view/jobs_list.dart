import 'package:carrier_jobs_app/controller/instances.dart';
import 'package:carrier_jobs_app/view/add_job.dart';
import 'package:carrier_jobs_app/view/edit_job.dart';
import 'package:carrier_jobs_app/view/helpers/colors.dart';
import 'package:carrier_jobs_app/view/helpers/responsive_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JobsList extends StatefulWidget {
  final String type;
  const JobsList({
    super.key,
    required this.type,
  });

  @override
  State<JobsList> createState() => _JobsListState();
}

class _JobsListState extends State<JobsList> {
  DateTime _parseDate(String dateString) {
    List<String> dateAndTimeParts = dateString.split(' ');
    List<String> dateParts = dateAndTimeParts[0].split('/');
    List<String> timeParts = dateAndTimeParts[1].split(':');

    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = int.parse(timeParts[2]);

    return DateTime(year, month, day, hour, minute, second);
  }

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
        actions: [
          MaterialButton(
            color: Colors.green,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const JobPage(),
              ),
            ),
            child: Text(
              '+ Add Job',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: whiteColor,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: widget.type == 'live'
            ? jobsCollection.where('isLive', isEqualTo: 'live').snapshots()
            : jobsCollection.where('isLive', isEqualTo: 'expired').snapshots(),
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
                      List<DocumentSnapshot> documents = snapshot.data!.docs;

                      documents.sort((a, b) {
                        DateTime dateA = _parseDate(a['date']);
                        DateTime dateB = _parseDate(b['date']);
                        return dateB.compareTo(dateA);
                      });

                      DocumentSnapshot documentSnapshot = documents[index];

                      return MaterialButton(
                        color: whiteColor,
                        padding: const EdgeInsets.all(20),
                        onPressed: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: mainColor,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    documentSnapshot['isLive'] == 'live'
                                        ? 'Live Now'
                                        : 'Paused/Expired',
                                    style: GoogleFonts.poppins(
                                      color: whiteColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  minWidth: 0,
                                  color: mainColor,
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobEditPage(
                                        documentId: documentSnapshot.id,
                                      ),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.edit_rounded,
                                    color: whiteColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
                                      width: displayWidth(context) / 2.5,
                                      child: Text(
                                        documentSnapshot['job_name'],
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    MaterialButton(
                                      minWidth: 0,
                                      color: Colors.red,
                                      onPressed: () {
                                        jobsCollection
                                            .doc(documentSnapshot.id)
                                            .delete();
                                      },
                                      child: Icon(
                                        Icons.delete_rounded,
                                        color: whiteColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    MaterialButton(
                                      minWidth: 0,
                                      color:
                                          documentSnapshot['isLive'] == 'live'
                                              ? Colors.amber
                                              : mainColor,
                                      onPressed:
                                          documentSnapshot['isLive'] == 'live'
                                              ? () {
                                                  jobsCollection
                                                      .doc(documentSnapshot.id)
                                                      .update(
                                                    {
                                                      'isLive': 'expired',
                                                    },
                                                  );
                                                }
                                              : () {
                                                  jobsCollection
                                                      .doc(documentSnapshot.id)
                                                      .update(
                                                    {
                                                      'isLive': 'live',
                                                    },
                                                  );
                                                },
                                      child: Icon(
                                        documentSnapshot['isLive'] == 'live'
                                            ? Icons.block_rounded
                                            : Icons.radio_button_on_rounded,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Posted at: ${documentSnapshot['date']}',
                              style: GoogleFonts.poppins(
                                color: blackColor.withOpacity(0.5),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
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
