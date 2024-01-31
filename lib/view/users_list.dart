import 'package:carrier_jobs_app/controller/instances.dart';
import 'package:carrier_jobs_app/view/helpers/colors.dart';
import 'package:carrier_jobs_app/view/helpers/responsive_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UsersList extends StatefulWidget {
  final String type;
  const UsersList({
    super.key,
    required this.type,
  });

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Users List',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: widget.type == 'all'
            ? usersCollection.snapshots()
            : usersCollection.where('isLive', isEqualTo: 'yes').snapshots(),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
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
                                    Text(
                                      documentSnapshot['number'],
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
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
                                        usersCollection
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
                                      color: Colors.amber,
                                      onPressed: () {
                                        usersCollection
                                            .doc(documentSnapshot.id)
                                            .update(
                                          {
                                            'status': 'banned',
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.block_rounded,
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
