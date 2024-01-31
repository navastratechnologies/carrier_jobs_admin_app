import 'package:carrier_jobs_app/controller/instances.dart';
import 'package:carrier_jobs_app/view/add_country.dart';
import 'package:carrier_jobs_app/view/helpers/colors.dart';
import 'package:carrier_jobs_app/view/helpers/responsive_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountriesList extends StatefulWidget {
  final String type;
  const CountriesList({
    super.key,
    required this.type,
  });

  @override
  State<CountriesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Countries List',
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
                builder: (context) => const CountryyPage(),
              ),
            ),
            child: Text(
              '+ Add Country',
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
            ? countriesCollection.where('isLive', isEqualTo: 'live').snapshots()
            : countriesCollection
                .where('isLive', isEqualTo: 'expired')
                .snapshots(),
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
                                        documentSnapshot['name'],
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
                                        countriesCollection
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
                                                  countriesCollection
                                                      .doc(documentSnapshot.id)
                                                      .update(
                                                    {
                                                      'isLive': 'expired',
                                                    },
                                                  );
                                                }
                                              : () {
                                                  countriesCollection
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
