import 'dart:developer';
import 'dart:io';

import 'package:carrier_jobs_app/controller/instances.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'helpers/colors.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  FocusNode focusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController urlController = TextEditingController();

  String uploadedImage = '';
  bool picFound = false;
  bool showLoader = false;
  UploadTask? uploadTask;
  File? image;
  String originalImageName = '';

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      final imageName = path.basenameWithoutExtension(imageTemporary.path);
      final newFile = await imageTemporary
          .rename('${imageTemporary.parent.path}/$imageName.png');
      log('picked image is $newFile ${imageTemporary.parent.path}');

      setState(() {
        this.image = newFile;
        originalImageName = "$imageName.png";
      });
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  Future uploadFile() async {
    final path = 'categories/$originalImageName';
    final file = File(image!.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    log('Download link : $urlDownload');

    setState(() {
      uploadTask = null;
    });

    categoriesCollection.add(
      {
        'isLive': 'live',
        'cat': urlController.text,
        'logo': urlDownload,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Category',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InkWell(
              onTap: () => pickImage(),
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: image == null
                    ? const Icon(
                        Icons.camera_alt_rounded,
                        size: 100,
                      )
                    : Image.file(
                        File(
                          image!.path,
                        ),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 10),
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
                  hintText: 'Enter category name here',
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: mainColor,
                      content: Text(
                        'Category Uploading...',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                  uploadFile().then(
                    (value) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            'category updated successfully',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
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
