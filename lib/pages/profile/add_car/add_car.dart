import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rac_road/colors.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({super.key});

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  TextEditingController? carNameController;

  final _carList = ["Toyota", "BMW", "Honda", "Izusu"];
  String? _selectedVal = "";

  @override
  void initState() {
    super.initState();
    carNameController = TextEditingController();
  }

  @override
  void dispose() {
    carNameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const SizedBox(height: 10),
            Text(
              'รถของคุณ',
              style: GoogleFonts.sarabun(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Text(
              'เพิ่มรถสุดโปรดของคุณเพื่อให้คุณรู้เวลาเปลี่ยนอะไหล่ตอนไหน !',
              style: GoogleFonts.sarabun(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              hint: const Text('ยี่ห้อรถ'),
              icon: const Icon(
                Icons.arrow_drop_down_circle,
                color: mainGreen,
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: mainGreen, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: mainGreen, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (val) => val == null ? "Select a country" : null,
              items: _carList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedVal = val as String;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              hint: const Text('รุ่น'),
              icon: const Icon(
                Icons.arrow_drop_down_circle,
                color: mainGreen,
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: mainGreen, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: mainGreen, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (val) => val == null ? "Select a country" : null,
              items: _carList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedVal = val as String;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              hint: const Text('โฉม'),
              icon: const Icon(
                Icons.arrow_drop_down_circle,
                color: mainGreen,
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: mainGreen, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: mainGreen, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (val) => val == null ? "Select a country" : null,
              items: _carList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedVal = val as String;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              hint: const Text('รุ่นย่อย'),
              icon: const Icon(
                Icons.arrow_drop_down_circle,
                color: mainGreen,
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: mainGreen, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: mainGreen, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (val) => val == null ? "Select a country" : null,
              items: _carList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedVal = val as String;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              hint: const Text('เชื้อเพลิง'),
              icon: const Icon(
                Icons.arrow_drop_down_circle,
                color: mainGreen,
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: mainGreen, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: mainGreen, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (val) => val == null ? "Select a country" : null,
              items: _carList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedVal = val as String;
                });
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Fluttertoast.showToast(
                  //   msg: "เพิ่มรถเรียบร้อย",
                  //   backgroundColor: mainGreen,
                  //   fontSize: 17,
                  // );
                  // Get.to(ScreensPage());
                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainGreen,
                  minimumSize: const Size(
                    300,
                    40,
                  ),
                ),
                child: Text(
                  'เพิ่มรถ',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
