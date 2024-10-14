import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mongo_lab1/controllers/auth_controller.dart';
import 'package:flutter_mongo_lab1/providers/user_provider.dart';
import 'package:flutter_mongo_lab1/varibles.dart';
import 'package:flutter_mongo_lab1/models/information_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class InformationController {
  final _authController = AuthController();
  static int retryCount = 0;

  Future<List<InformationModel>> getInformations(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.get(
        Uri.parse('$apiURL/api/informations'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((info) => InformationModel.fromJson(info))
            .toList();
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception('Wrong Token. Please login again.');
      } else if (response.statusCode == 403 && retryCount <= 1) {
        await _authController.refreshToken(context);
        accessToken = userProvider.accessToken;
        retryCount++;
        return await getInformations(context);
      } else {
        throw Exception('Failed to load informations: ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('Error loading informations: $err');
    }
  }

  Future<void> insertInformation(
      BuildContext context, InformationModel info) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.post(
        Uri.parse('$apiURL/api/information'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(info.toJson()),
      );

      if (response.statusCode == 201) {
        print("Information inserted successfully!");
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception('Wrong Token. Please login again.');
      } else if (response.statusCode == 403 && retryCount <= 1) {
        await _authController.refreshToken(context);
        accessToken = userProvider.accessToken;
        retryCount++;
        return await insertInformation(context, info);
      } else {
        throw Exception('Failed to insert information: ${response.statusCode}');
      }
    } catch (error) {
      print('Error inserting information: $error');
      throw Exception('Error inserting information: $error');
    }
  }

  Future<void> updateInformation(
      BuildContext context, String infoId, InformationModel info) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.put(
        Uri.parse('$apiURL/api/information/$infoId'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(info.toJson()),
      );

      if (response.statusCode == 200) {
        print("Information updated successfully!");
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception('Wrong Token. Please login again.');
      } else if (response.statusCode == 403 && retryCount <= 1) {
        await _authController.refreshToken(context);
        accessToken = userProvider.accessToken;
        retryCount++;
        return await updateInformation(context, infoId, info);
      } else {
        throw Exception('Failed to update information: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating information: $error');
      throw Exception('Error updating information: $error');
    }
  }

  Future<void> deleteInformation(BuildContext context, String infoId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.delete(
        Uri.parse('$apiURL/api/information/$infoId'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      );

      if (response.statusCode == 200) {
        print("Information deleted successfully!");
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception('Wrong Token. Please login again.');
      } else if (response.statusCode == 403 && retryCount <= 1) {
        await _authController.refreshToken(context);
        accessToken = userProvider.accessToken;
        retryCount++;
        return await deleteInformation(context, infoId);
      } else {
        throw Exception('Failed to delete information: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting information: $error');
      throw Exception('Error deleting information: $error');
    }
  }
}
