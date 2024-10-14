import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_mongo_lab1/Widget/customCliper.dart';
import 'package:flutter_mongo_lab1/controllers/information_controller.dart';
import 'package:flutter_mongo_lab1/models/information_model.dart';

class EditInformationPage extends StatefulWidget {
  final InformationModel information;

  const EditInformationPage({super.key, required this.information});

  @override
  _EditInformationPageState createState() => _EditInformationPageState();
}

class _EditInformationPageState extends State<EditInformationPage> {
  final _formKey = GlobalKey<FormState>();

  late String fullName,
      workHours,
      personalLeave,
      vacationLeave,
      offsiteWork,
      nonWorkingDays,
      id;
  late int sickLeave;
  late DateTime createdAt, updatedAt;

  @override
  void initState() {
    super.initState();
    // Initialize form fields with existing data
    fullName = widget.information.fullName;
    workHours = widget.information.workHours;
    sickLeave = widget.information.sickLeave;
    personalLeave = widget.information.personalLeave;
    vacationLeave = widget.information.vacationLeave;
    offsiteWork = widget.information.offsiteWork;
    nonWorkingDays = widget.information.nonWorkingDays;
    id = widget.information.id;
    createdAt = widget.information.createdAt;
    updatedAt = widget.information.updatedAt;
  }

  Future<void> _updateInformation(BuildContext context) async {
    final informationController = InformationController(); // ใช้ชื่อที่ถูกต้อง

    try {
      await informationController.updateInformation(
        context,
        id,
        InformationModel(
          // สร้างอินสแตนซ์ของ InformationModel
          fullName: fullName,
          workHours: workHours,
          sickLeave: sickLeave,
          personalLeave: personalLeave,
          vacationLeave: vacationLeave,
          offsiteWork: offsiteWork,
          nonWorkingDays: nonWorkingDays,
          id: id,
          createdAt: createdAt,
          updatedAt: DateTime.now(), // Update the timestamp
        ),
      );

      Navigator.pushReplacementNamed(context, '/admin');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อยแล้ว')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
      );
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
                          Color(0xffA8D8EA), // ฟ้าอ่อน
                          Color(0xff005B6C), // ฟ้าเข้ม
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: height * .1),
                    const Text(
                      'แก้ไขข้อมูลพนักงาน',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff005B6C), // ฟอนต์สีฟ้าเข้ม
                      ),
                    ),
                    const SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildTextField(
                            label: 'ชื่อ-นามสกุล',
                            initialValue: fullName,
                            onSaved: (value) => fullName = value!,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'ลงเวลาปฏิบัติงาน',
                            initialValue: workHours,
                            onSaved: (value) => workHours = value!,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'วันที่ลาป่วย',
                            initialValue: sickLeave.toString(),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => sickLeave = int.parse(value!),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'วันที่ลากิจ',
                            initialValue: personalLeave,
                            onSaved: (value) => personalLeave = value!,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'วันที่ลาพักร้อน',
                            initialValue: vacationLeave,
                            onSaved: (value) => vacationLeave = value!,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'ปฏิบัติงาน นอกพื้นที่',
                            initialValue: offsiteWork,
                            onSaved: (value) => offsiteWork = value!,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'วันที่ไม่ลงเวลา',
                            initialValue: nonWorkingDays,
                            onSaved: (value) => nonWorkingDays = value!,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    _updateInformation(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xff005B6C), // ปุ่มสีฟ้าเข้ม
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  child: Text(
                                    'แก้ไข',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/admin');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                      0xffC7253E), // สีแดงสำหรับยกเลิก
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
                              ),
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
    required String initialValue,
    TextInputType? keyboardType,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xff007C92)), // ฟอนต์สีฟ้าเข้ม
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff007C92)), // ขอบฟ้าเข้ม
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color(0xff005B6C)), // ขอบฟ้าเข้มเมื่อโฟกัส
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      initialValue: initialValue,
      keyboardType: keyboardType,
      onSaved: onSaved,
    );
  }
}
