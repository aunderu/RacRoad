import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:rac_road/colors.dart';
import 'package:rac_road/models/all_car_models.dart';

import '../../../services/remote_service.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({super.key, required this.getToken});

  final String getToken;

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  AllCarModel? allCar;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<CarDatum>? foundCars;
  bool haveCar = false;
  File? imageFile;
  bool isLoaded = false;
  TextEditingController? searchController;

  @override
  void dispose() {
    searchController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();

    getCarData();
  }

  getCarData() async {
    setState(() {
      isLoaded = true;
    });
    allCar = await RemoteService().getAllCar();
    if (allCar != null) {
      final bool haveData = allCar!.data.carData.isNotEmpty;
      if (haveData == true) {
        if (mounted) {
          setState(() {
            haveCar = true;
            foundCars = allCar!.data.carData.toList();
            isLoaded = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            haveCar = false;
            isLoaded = false;
          });
        }
      }
    }
  }

  void showImageDialog(String carId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('กรุณาเลือกรูปรถของคุณ', textAlign: TextAlign.center),
          titleTextStyle: GoogleFonts.sarabun(
            color: Colors.black,
            fontSize: 20,
          ),
          alignment: Alignment.center,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  getFromCamera(carId);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black,
                        size: 65,
                      ),
                    ),
                    Text(
                      'กล้อง',
                      style: GoogleFonts.sarabun(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  getFromGallery(carId);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.black,
                        size: 65,
                      ),
                    ),
                    Text(
                      'รูปภาพ',
                      style: GoogleFonts.sarabun(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void getFromGallery(String carId) async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });

      carSend(imageFile!.path, carId).then((value) => value == true
          ? Get.offNamedUntil('/profile', (route) => false)
          : null);
    } else {
      Fluttertoast.showToast(
        msg: 'คุณยังไม่ได้เลือกรูป',
        backgroundColor: Colors.yellow[100],
        textColor: Colors.black,
        fontSize: 15,
        gravity: ToastGravity.SNACKBAR,
      );
    }
    Navigator.pop(context);
  }

  void getFromCamera(String carId) async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });

      carSend(imageFile!.path, carId).then((value) => value == true
          ? Get.offNamedUntil('/profile', (route) => false)
          : null);
    } else {
      Fluttertoast.showToast(
        msg: 'คุณยังไม่ได้เลือกรูป',
        backgroundColor: Colors.yellow[100],
        textColor: Colors.black,
        fontSize: 15,
        gravity: ToastGravity.SNACKBAR,
      );
    }
    Navigator.pop(context);
  }

  Future<bool> carSend(String filePath, String carId) async {
    Map<String, String> headers = {"Context-Type": "multipart/formdata"};
    var requset = http.MultipartRequest(
        "POST", Uri.parse("https://api.racroad.com/api/mycar/store"))
      ..fields.addAll({
        "user_id": widget.getToken,
        "car_id": carId,
      })
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('profile_car', filePath));
    var response = await requset.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(response.toString()));
    }
  }

  void _runFilter(String enterdKeyword) {
    List<CarDatum> result;
    if (enterdKeyword.isEmpty) {
      result = allCar!.data.carData;
    } else {
      result = allCar!.data.carData
          .where((car) =>
              car.model.toLowerCase().contains(enterdKeyword.toLowerCase()) ||
              car.brand.toLowerCase().contains(enterdKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      foundCars = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: formKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'เพิ่มรถของคุณ',
            style: GoogleFonts.sarabun(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: mainGreen,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        'assets/imgs/logos/car.png',
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'รถของคุณ',
                          style: GoogleFonts.sarabun(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            height: 0.8,
                          ),
                        ),
                        Text(
                          'เพิ่มรถสุดโปรดของคุณเพื่อให้คุณรู้เวลาเปลี่ยนอะไหล่ตอนไหน !',
                          style: GoogleFonts.sarabun(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: searchController,
                obscureText: false,
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                  labelText: 'ค้นหารุ่นรถของคุณ',
                  labelStyle: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF757575),
                    size: 22,
                  ),
                ),
                style: GoogleFonts.sarabun(),
              ),
              const SizedBox(height: 20),
              isLoaded
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(mainGreen),
                          strokeWidth: 8,
                        ),
                      ),
                    )
                  : haveCar
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: foundCars!.length,
                            itemBuilder: (context, index) => Card(
                              key: ValueKey(foundCars![index].carId),
                              color: whiteGrey,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 7),
                              child: ListTile(
                                title: Text(
                                  foundCars![index].brand,
                                  style: GoogleFonts.sarabun(),
                                ),
                                subtitle: Text(
                                  "${foundCars![index].model}, ${foundCars![index].makeover}, ${foundCars![index].subversion}, ${foundCars![index].fuel}",
                                  style: GoogleFonts.sarabun(),
                                ),
                                onTap: () {
                                  Get.defaultDialog(
                                    title: 'เลือกรถ ${foundCars![index].brand}',
                                    middleText:
                                        'รุ่น ${foundCars![index].model} โฉม ${foundCars![index].makeover}, รุ่นย่อย ${foundCars![index].subversion} เชื้อเพลิง ${foundCars![index].fuel} หรือไม่?',
                                    titleStyle: GoogleFonts.sarabun(),
                                    middleTextStyle: GoogleFonts.sarabun(),
                                    textConfirm: "ยืนยัน",
                                    textCancel: "ยกเลิก",
                                    confirmTextColor: Colors.white,
                                    onConfirm: () {
                                      showImageDialog(
                                          allCar!.data.carData[index].carId);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      : const Center(
                          child: Text('ดูเหมือนยังไม่มีข้อมูลรถในขณะนี้'),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
