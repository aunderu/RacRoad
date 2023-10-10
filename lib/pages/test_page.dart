import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:rac_road/utils/colors.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> photo = <XFile>[];
  List<XFile> itemImagesList = <XFile>[];
  XFile? camera;
  List<File> imageFile = <File>[];

  pickCamera() async {
    camera = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (camera != null) {
      setState(() {
        itemImagesList.add(camera!);
      });
    } else {
      Get.snackbar(
        'คำเตือน',
        'คุณยังไม่ได้เลือกรูป',
        backgroundGradient: const LinearGradient(colors: [
          Color.fromARGB(255, 255, 191, 0),
          Color.fromARGB(255, 255, 234, 172),
        ]),
        barBlur: 15,
        animationDuration: const Duration(milliseconds: 500),
        icon: const Icon(
          Icons.warning,
          size: 30,
          color: Colors.red,
        ),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  pickPhotoFromGallery() async {
    photo = await _picker.pickMultiImage(imageQuality: 50);
    if (photo.isNotEmpty) {
      setState(() {
        itemImagesList += photo;
        photo.clear();
      });
    } else {
      Get.snackbar(
        'คำเตือน',
        'คุณยังไม่ได้เลือกรูป',
        backgroundGradient: const LinearGradient(colors: [
          Color.fromARGB(255, 255, 191, 0),
          Color.fromARGB(255, 255, 234, 172),
        ]),
        barBlur: 15,
        animationDuration: const Duration(milliseconds: 500),
        icon: const Icon(
          Icons.warning,
          size: 30,
          color: Colors.red,
        ),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<bool> testSend(List<File> image) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.racroad.com/api/test/image/array'));

    request
      ..fields.addAll({
        "title": "Suthawee",
      })
      ..headers.addAll(headers);
    for (var i = 0; i < image.length; i++) {
      request.files.add(
        http.MultipartFile(
            'image[$i]',
            File(image[i].path).readAsBytes().asStream(),
            File(image[i].path).lengthSync(),
            filename: image[i].path.split("/").last),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      throw false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Test Code Area',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    color: mainGreen,
                    fontSize: 35,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Ink(
                  width: 50,
                  height: 50,
                  decoration: const ShapeDecoration(
                    gradient: LinearGradient(colors: [mainGreen, lightGreen]),
                    shape: CircleBorder(
                        side: BorderSide(color: Colors.transparent)),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 50 / 2,
                    iconSize: 50 / 2,
                    splashColor: whiteGreen,
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      pickCamera();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Ink(
                    width: 50,
                    height: 50,
                    decoration: const ShapeDecoration(
                      gradient: LinearGradient(colors: [mainGreen, lightGreen]),
                      shape: CircleBorder(
                          side: BorderSide(color: Colors.transparent)),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      splashRadius: 50 / 2,
                      iconSize: 50 / 2,
                      splashColor: whiteGreen,
                      icon: const Icon(
                        Icons.add_photo_alternate,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        pickPhotoFromGallery();
                      },
                    ),
                  ),
                ),
                Ink(
                  width: 50,
                  height: 50,
                  decoration: const ShapeDecoration(
                    color: Colors.red,
                    shape: CircleBorder(
                        side: BorderSide(color: Colors.transparent)),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 50 / 2,
                    iconSize: 50 / 2,
                    splashColor: whiteGreen,
                    icon: const Icon(
                      Icons.upload,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (itemImagesList.isEmpty) {
                        Get.snackbar(
                          'คำเตือน',
                          'คุณยังไม่ได้เลือกรูป',
                          backgroundGradient: const LinearGradient(colors: [
                            Color.fromARGB(255, 255, 191, 0),
                            Color.fromARGB(255, 255, 234, 172),
                          ]),
                          barBlur: 15,
                          animationDuration: const Duration(milliseconds: 500),
                          icon: const Icon(
                            Icons.warning,
                            size: 30,
                            color: Colors.red,
                          ),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        for (var i = 0; i < itemImagesList.length; i++) {
                          // print('index $i , value ${itemImagesList[i].path}');

                          imageFile.add(File(itemImagesList[i].path));
                        }

                        testSend(imageFile).then((value) {
                          if (value == false) {
                            Get.snackbar(
                              'คำเตือน',
                              'เกิด Error บางอย่างนะจ๊ะะะะะ',
                              backgroundGradient: const LinearGradient(colors: [
                                Color.fromARGB(255, 255, 191, 0),
                                Color.fromARGB(255, 255, 234, 172),
                              ]),
                              barBlur: 15,
                              animationDuration:
                                  const Duration(milliseconds: 500),
                              icon: const Icon(
                                Icons.warning,
                                size: 30,
                                color: Colors.red,
                              ),
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                          setState(() {
                            itemImagesList.clear();
                          });
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 120,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: itemImagesList.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        SizedBox(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          child: Image.file(
                            File(itemImagesList[index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: -1.0,
                          right: -1.0,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                itemImagesList.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
