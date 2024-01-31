import 'package:carrier_jobs_app/controller/instances.dart';
import 'package:carrier_jobs_app/controller/login_managing_controller.dart';
import 'package:carrier_jobs_app/view/add_category.dart';
import 'package:carrier_jobs_app/view/add_country.dart';
import 'package:carrier_jobs_app/view/add_policy.dart';
import 'package:carrier_jobs_app/view/add_terms.dart';
import 'package:carrier_jobs_app/view/feedbacks_list.dart';
import 'package:carrier_jobs_app/view/helpers/colors.dart';
import 'package:carrier_jobs_app/view/helpers/responsive_size.dart';
import 'package:carrier_jobs_app/view/jobs_list.dart';
import 'package:carrier_jobs_app/view/splash_screen.dart';
import 'package:carrier_jobs_app/view/users_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_job.dart';
import 'categories_list.dart';
import 'countries_list.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Panel',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.add_rounded,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: mainColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              drawerButtons(
                'Add Job',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JobPage(),
                  ),
                ),
              ),
              drawerButtons(
                'Add Categories',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryPage(),
                  ),
                ),
              ),
              drawerButtons(
                'Add Countries',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CountryyPage(),
                  ),
                ),
              ),
              drawerButtons(
                'Add Terms & Conditions',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsPage(),
                  ),
                ),
              ),
              drawerButtons(
                'Add Privacy Policy',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PolicyPage(),
                  ),
                ),
              ),
              const Divider(),
              drawerButtons(
                'Log Out',
                () async {
                  await storage.delete(key: 'token');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SplashScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Users Section :',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: blackColor.withOpacity(0.5),
                  ),
                ),
              ),
              Row(
                children: [
                  StreamBuilder(
                    stream: usersCollection.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return detailardsWidget(
                          'Total Users',
                          snapshot.data!.docs.length.toString(),
                          'Users',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const UsersList(type: 'all'),
                            ),
                          ),
                        );
                      } else {
                        return detailardsWidget(
                          'Total Users Live Now',
                          '00',
                          'Users',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const UsersList(type: 'all'),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  StreamBuilder(
                    stream: usersCollection
                        .where('isLive', isEqualTo: 'yes')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return detailardsWidget(
                          'Total Users Logged in',
                          snapshot.data!.docs.length.toString(),
                          'Users',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const UsersList(type: 'logged_in'),
                            ),
                          ),
                        );
                      } else {
                        return detailardsWidget(
                          'Total Users Logged in',
                          '00',
                          'Users',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const UsersList(type: 'logged_in'),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Jobs Section :',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: blackColor.withOpacity(0.5),
                  ),
                ),
              ),
              Row(
                children: [
                  StreamBuilder(
                    stream: jobsCollection
                        .where('isLive', isEqualTo: 'live')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return detailardsWidget(
                          'Total Jobs Live Now',
                          snapshot.data!.docs.length.toString(),
                          'Jobs',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const JobsList(type: 'live'),
                            ),
                          ),
                        );
                      } else {
                        return detailardsWidget(
                          'Total Jobs Live Now',
                          '00',
                          'Jobs',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const JobsList(type: 'live'),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  StreamBuilder(
                    stream: jobsCollection
                        .where('isLive', isEqualTo: 'expired')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return detailardsWidget(
                          'Total Jobs Expired',
                          snapshot.data!.docs.length.toString(),
                          'Jobs',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const JobsList(type: 'expired'),
                            ),
                          ),
                        );
                      } else {
                        return detailardsWidget(
                          'Total Jobs Expired',
                          '00',
                          'Jobs',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const JobsList(type: 'expired'),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Categories Section :',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: blackColor.withOpacity(0.5),
                  ),
                ),
              ),
              Row(
                children: [
                  StreamBuilder(
                    stream: categoriesCollection
                        .where('isLive', isEqualTo: 'live')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return detailardsWidget(
                          'Total Categories Live Now',
                          snapshot.data!.docs.length.toString(),
                          'Categories',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CategoriesList(type: 'live'),
                            ),
                          ),
                        );
                      } else {
                        return detailardsWidget(
                          'Total Categories Live Now',
                          '00',
                          'Categories',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CategoriesList(type: 'live'),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  StreamBuilder(
                    stream: categoriesCollection
                        .where('isLive', isEqualTo: 'expired')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return detailardsWidget(
                          'Total Categories Expired',
                          snapshot.data!.docs.length.toString(),
                          'Categories',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CategoriesList(type: 'expired'),
                            ),
                          ),
                        );
                      } else {
                        return detailardsWidget(
                          'Total Categories Expired',
                          '00',
                          'Categories',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CategoriesList(type: 'expired'),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Countries Section :',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: blackColor.withOpacity(0.5),
                  ),
                ),
              ),
              Row(
                children: [
                  StreamBuilder(
                    stream: countriesCollection
                        .where('isLive', isEqualTo: 'live')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return detailardsWidget(
                          'Total Countries Live Now',
                          snapshot.data!.docs.length.toString(),
                          'Countries',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CountriesList(type: 'live'),
                            ),
                          ),
                        );
                      } else {
                        return detailardsWidget(
                          'Total Countries Live Now',
                          '00',
                          'Countries',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CountriesList(type: 'live'),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  StreamBuilder(
                    stream: countriesCollection
                        .where('isLive', isEqualTo: 'expired')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return detailardsWidget(
                          'Total Countries Expired or Paused',
                          snapshot.data!.docs.length.toString(),
                          'Countries',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CountriesList(type: 'expired'),
                            ),
                          ),
                        );
                      } else {
                        return detailardsWidget(
                          'Total Countries Expired or Paused',
                          '00',
                          'Countries',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CountriesList(type: 'expired'),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Feedbacks Section :',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: blackColor.withOpacity(0.5),
                  ),
                ),
              ),
              Row(
                children: [
                  StreamBuilder(
                    stream: feedbacksCollection.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return detailardsWidget(
                          'Total Feedbacks Received',
                          snapshot.data!.docs.length.toString(),
                          'Feedbacks',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FeedbacksList(),
                            ),
                          ),
                        );
                      } else {
                        return detailardsWidget(
                          'Total Feedbacks Received',
                          '00',
                          'Feedbacks',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FeedbacksList(),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  drawerButtons(title, method) {
    return MaterialButton(
      padding: const EdgeInsets.all(20),
      onPressed: method,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.add_rounded,
                color: whiteColor,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                ),
              ),
            ],
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: whiteColor,
          ),
        ],
      ),
    );
  }

  detailardsWidget(label, data, subLabel, tap) {
    return Expanded(
      child: InkWell(
        onTap: tap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: blackColor.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    data,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                      fontSize: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      ' /$subLabel',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: blackColor.withOpacity(0.3),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
