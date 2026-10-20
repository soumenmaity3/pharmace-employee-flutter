import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pharmace_emp/backend/api_response.dart';

import 'model/emp_model_invite_id.dart';
import 'model/emp_return_model.dart';

class ApiService {
  static const String _host = 'pharmace.servehttp.com';

  static String get baseUrl =>
      'http://${Platform.isAndroid ? _host : 'localhost'}:8080/v1';

  Future<ApiResponse<EmpModelInviteId>> getEmpDataByInviteCode({
    required String inviteCode,
  }) async {
    try {
      // 1. Fetch employee invite info
      final response = await http
          .get(
            Uri.parse('$baseUrl/empe/EmpBYInvtId?inviteId=$inviteCode'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200 || response.body.trim().isEmpty) {
        String? message;
        try {
          final decode = jsonDecode(response.body);
          message = decode['message'] ?? decode['error'];
        } catch (_) {}
        return ApiResponse(
          statusCode: response.statusCode,
          data: null,
          message: message ?? "Invalid invite code.",
        );
      }

      final decode = jsonDecode(response.body);
      if (decode is! Map<String, dynamic>) {
        return ApiResponse(
          statusCode: 400,
          data: null,
          message: "Invalid response format.",
        );
      }

      EmpModelInviteId empData = EmpModelInviteId.fromJson(decode);
      final ownerShipResponse = await getOwnerShip(
        shopId: empData.shopId,
        ownerId: empData.ownerId,
      );
      if (ownerShipResponse.statusCode == 200 &&
          ownerShipResponse.data != null) {
        empData = empData.copyWith(ownershipData: ownerShipResponse.data);
      }
      return ApiResponse(
        statusCode: 200,
        data: empData,
        message: decode['message']?.toString(),
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, data: null, message: e.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getOwnerShip({
    required String shopId,
    required String ownerId,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/empe/owner-shopById/$ownerId/$shopId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      Map<String, dynamic>? data;
      String? message;

      if (response.body.trim().isNotEmpty) {
        final decode = jsonDecode(response.body);
        if (decode is Map<String, dynamic>) {
          data = decode;
          message =
              decode['message']?.toString() ??
              decode['details']?.toString() ??
              decode['error']?.toString();
        } else {
          message = decode.toString();
        }
      }

      return ApiResponse(
        statusCode: response.statusCode,
        data: data,
        message: message,
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, data: null, message: e.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> completeRegistration({
    required String role,
    required String email,
    required String name,
    required String password,
    String? phone,
    required String shopId,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/empe/register/$shopId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'role': role,
              'email': email,
              'name': name,
              'password': password,
              if (phone != null && phone.isNotEmpty) 'phone': phone,
            }),
          )
          .timeout(const Duration(seconds: 15));

      Map<String, dynamic>? data;
      String? message;

      if (response.body.trim().isNotEmpty) {
        try {
          final decode = jsonDecode(response.body);
          if (decode is Map<String, dynamic>) {
            data = decode;
            message =
                decode['message']?.toString() ??
                decode['details']?.toString() ??
                decode['error']?.toString();
          } else {
            message = decode.toString();
          }
        } catch (_) {}
      }

      return ApiResponse(
        statusCode: response.statusCode,
        data: data,
        message: message,
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, data: null, message: e.toString());
    }
  }

  Future<ApiResponse<EmpReturnModel>> empLogin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/empe/sign-in'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(Duration(seconds: 15));
      EmpReturnModel? empReturnModel;
      String? message;
      if (response.body.trim().isNotEmpty) {
        try {
          final decode = jsonDecode(response.body);
          if (decode is Map<String, dynamic>) {
            empReturnModel = EmpReturnModel.fromJson(decode);
            message =
                decode['message']?.toString() ??
                decode['details']?.toString() ??
                decode['error']?.toString();
          } else {
            message = decode.toString();
          }
        } catch (_) {}
      }
      return ApiResponse(
        statusCode: response.statusCode,
        data: empReturnModel,
        message: message,
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, data: null, message: e.toString());
    }
  }
}
