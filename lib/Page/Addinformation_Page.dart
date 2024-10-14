import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_mongo_lab1/Widget/customCliper.dart'; // Assuming you already have customClipper
import 'package:flutter_mongo_lab1/controllers/information_controller.dart'; // Import InformationController
import 'package:flutter_mongo_lab1/models/information_model.dart';

class AddInformationPage extends StatefulWidget {
  const AddInformationPage({super.key});

  @override
  _AddInformationPageState createState() => _AddInformationPageState();
}

class _AddInformationPageState extends State<AddInformationPage> {
  final _formKey = GlobalKey<FormState>();
  final InformationController _informationController =
      InformationController(); // Create InformationController instance

  // Define fields
  String fullName = '';
  String workHours = '';
  int sickLeave = 0;
  String personalLeave = '';
  String vacationLeave = '';
  String offsiteWork = '';
  String nonWorkingDays = '';

  // Function to add new information
  void _addNewInformation() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create an instance of InformationModel
      final information = InformationModel(
        fullName: fullName,
        workHours: workHours,
        sickLeave: sickLeave,
        personalLeave: personalLeave,
        vacationLeave: vacationLeave,
        offsiteWork: offsiteWork,
        nonWorkingDays: nonWorkingDays,
        id: '', // Provide an ID if available
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save new information using the insertInformation function
      _informationController.insertInformation(context, information).then((_) {
        // Success action here (e.g., navigate back or show success message)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เพิ่มข้อมูลเรียบร้อยแล้ว')),
        );
        Navigator.pushReplacementNamed(context, '/admin');
      }).catchError((error) {
        // Check if the error is due to expired token
        if (error.toString().contains('401')) {
          // Token expired, navigate to login screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('token หมดอายุแล้ว กรุณา login ใหม่')),
          );
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        } else {
          // Error action here (e.g., show error message)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            // Background
            Positioned(
              top: -height * .15,
              right: -width * .4,
              child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: height * .5,
                    width: width,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffa3c4e0), // Light Blue
                          Color(0xff005f99), // Dark Blue
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Form content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: 'เพิ่ม',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff005B6C), // Darker Blue
                        ),
                        children: [
                          TextSpan(
                            text: 'ข้อมูลใหม่',
                            style: TextStyle(
                                color: Color(0xff005B6C), // Dark Blue
                                fontSize: 35),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildTextField(
                            label: 'ชื่อเต็ม',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกชื่อเต็ม';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              fullName = value!;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'ลงเวลาปฏิบัติงาน',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกลงเวลาปฏิบัติงาน';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              workHours = value!;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'วันที่ลาป่วย',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกวันที่ลาป่วย';
                              }
                              if (int.tryParse(value) == null) {
                                return 'กรุณากรอกจำนวนเต็มที่ถูกต้อง';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              sickLeave = int.parse(value!);
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'วันที่ลากิจ',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกวันที่ลากิจ';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              personalLeave = value!;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'วันที่ลาพักร้อน',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกวันวันที่ลาพักร้อน';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              vacationLeave = value ?? '';
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'ปฏิบัติงาน นอกพื้นที่',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกงานปฏิบัติงาน นอกพื้นที่';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              offsiteWork = value ?? '';
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'วันที่ไม่ลงเวลา',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกวันที่ไม่ลงเวลา';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              nonWorkingDays = value ?? '';
                            },
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _addNewInformation,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xff005B6C), // Deep Blue
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  child: Text(
                                    'บันทึก',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context,
                                      '/admin'); // Navigate to admin page
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                      0xffC7253E), // Another shade of blue
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  child: Text(
                                    'ยกเลิก',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
