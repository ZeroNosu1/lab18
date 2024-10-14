import 'package:flutter/material.dart';
import 'package:flutter_mongo_lab1/Page/EditInformation_page.dart';
import 'dart:math';
import 'package:flutter_mongo_lab1/Widget/customCliper.dart';
import 'package:flutter_mongo_lab1/controllers/auth_controller.dart';
import 'package:flutter_mongo_lab1/providers/user_provider.dart';
import 'package:flutter_mongo_lab1/models/information_model.dart';
import 'package:flutter_mongo_lab1/controllers/information_controller.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http; // เพิ่ม dependency http

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  List<InformationModel> informationList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchInformation();
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Log Out'),
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false).onLogout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchInformation() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final infoList = await InformationController().getInformations(context);
      setState(() {
        informationList = infoList;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching information: $error';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching information: $error')));
    }
  }

  void updateInformation(InformationModel info) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditInformationPage(information: info),
      ),
    );
  }

  Future<void> deleteInformation(InformationModel info) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content:
              const Text('Are you sure you want to delete this information?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await InformationController().deleteInformation(context, info.id);
        await _fetchInformation();

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Information deleted successfully')));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting information: $error')));
      }
    }
  }

  Future<void> sendLineNotify(String message) async {
    const String accessToken =
        'qHKnhNveeuBNN3cQj3UPEESNllHB5Gu2J6nIeHMnFf9'; // Access Token ของคุณ

    final response = await http.post(
      Uri.parse('https://notify-api.line.me/api/notify'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'message': message,
      },
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification sent successfully')),
      );
    } else {
      print('Failed to send notification: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send notification')),
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
                          Color(0xffA8D8EA),
                          Color(0xff007C92),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: 'แอป ',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff007C92), // ฟอนต์สีฟ้าเข้ม
                        ),
                        children: [
                          TextSpan(
                            text: 'ระบบแจ้งเตือน',
                            style: TextStyle(
                                color: Color(0xff005B6C),
                                fontSize: 35), // ฟอนต์สีฟ้าเข้ม
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Button to add new information
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/add_information');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff005B6C),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Add New Information',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Information List
                    if (isLoading)
                      const CircularProgressIndicator()
                    else if (errorMessage != null)
                      Text(errorMessage!)
                    else
                      _buildInformationList(),
                  ],
                ),
              ),
            ),
            // LogOut Button
            Positioned(
              top: 50.0,
              right: 16.0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
                child: const Icon(
                  Icons.logout,
                  color: Color(0xff005B6C), // ฟอนต์สีฟ้าเข้ม
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInformationList() {
    return Column(
      children: List.generate(informationList.length, (index) {
        final info = informationList[index];
        return Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.fullName,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff007C92)), // ฟอนต์สีฟ้าเข้ม
                    ),
                    // รายละเอียดอื่น ๆ ไม่ต้องแสดงที่นี่
                    Text(
                      'วันที่ไม่ลงเวลา: ${info.nonWorkingDays}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Color(0xffA8D8EA), // ฟอนต์สีฟ้าอ่อน
                ),
                onPressed: () {
                  updateInformation(info);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Color(0xffC7253E), // สีแดงสำหรับลบ
                ),
                onPressed: () {
                  deleteInformation(info);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Color(0xff007C92), // ฟอนต์สีฟ้าเข้ม
                ),
                onPressed: () {
                  // ปรับให้ส่งเฉพาะชื่อและวันที่ไม่ลงเวลา
                  sendLineNotify(
                      'ชื่อ: ${info.fullName}\n วันที่ไม่ลงเวลา: ${info.nonWorkingDays}');
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
