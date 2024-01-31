import 'dart:async';

import 'package:carrier_jobs_app/controller/login_managing_controller.dart';
import 'package:carrier_jobs_app/view/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/instances.dart';
import 'helpers/colors.dart';
import 'helpers/responsive_size.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode1 = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        body: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                whiteColor,
                whiteColor,
                mainColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset('assets/icon.png', height: 100),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Login To Admin Panel",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: mainColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          focusNode: _focusNode,
                          controller: usernameController,
                          style: GoogleFonts.poppins(
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter admin username here',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              color: blackColor.withOpacity(0.4),
                            ),
                            errorStyle: GoogleFonts.poppins(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          focusNode: _focusNode1,
                          controller: passwordController,
                          obscureText: showPassword,
                          obscuringCharacter: '*',
                          style: GoogleFonts.poppins(
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            suffixIcon: MaterialButton(
                              minWidth: 0,
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              child: Icon(
                                showPassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                              ),
                            ),
                            hintText: 'Enter password here',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              color: blackColor.withOpacity(0.4),
                            ),
                            errorStyle: GoogleFonts.poppins(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    color: mainColor,
                    minWidth: displayWidth(context) / 1.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await firestoreInstance
                            .collection('admin')
                            .where(
                              'username',
                              isEqualTo: usernameController.text.toLowerCase(),
                            )
                            .where(
                              'password',
                              isEqualTo: passwordController.text.toLowerCase(),
                            )
                            .get()
                            .then(
                          (value) {
                            if (value.docs.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: mainColor,
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        strokeWidth: 5,
                                        color: whiteColor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              _focusNode.unfocus();
                              _focusNode1.unfocus();
                              storeLogin(usernameController.text);
                              Timer(
                                const Duration(seconds: 3),
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Dashboard(),
                                    ),
                                  );
                                },
                              );
                            } else {
                              setState(() {
                                usernameController.clear();
                                passwordController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      'Password or Username is not matched. Please check and try again.',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              });
                            }
                          },
                        );
                      }
                    },
                    child: Text(
                      'Proceed',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: whiteColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
