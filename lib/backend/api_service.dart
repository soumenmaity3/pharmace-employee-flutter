import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pharmace_emp/backend/api_response.dart';
import 'package:pharmace_emp/backend/auth/secure_storage_service.dart';

import 'model/emp_model_invite_id.dart';
import 'model/emp_return_model.dart';
import 'model/medicine_output_model.dart';

class ApiService {
  // static String get baseUrl =>
  //     'http://${defaultTargetPlatform == TargetPlatform.android ? '10.206.168.150' : 'localhost'}:8080/v1';
  static String get baseUrl => 'https://pharmace-backend.onrender.com/v1';

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

  Future<ApiResponse<List<MedicineOutputModel>>> getInventory({
    required String shopId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          data: null,
          message: 'Token is not valid',
        );
      }

      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/inv/get-inv/$shopId'
              '?page=$page'
              '&size=$size',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));

      List<MedicineOutputModel>? medicines;
      String? message;

      if (response.body.trim().isNotEmpty) {
        try {
          final decoded = jsonDecode(response.body);

          if (decoded is List) {
            medicines = MedicineOutputModel.fromJsonList(decoded);
          } else if (decoded is Map<String, dynamic>) {
            message =
                decoded['message']?.toString() ??
                decoded['error']?.toString() ??
                decoded['detail']?.toString();

            final rawList =
                decoded['content'] ??
                decoded['data'] ??
                decoded['items'] ??
                decoded['medicines'];

            if (rawList is List) {
              medicines = MedicineOutputModel.fromJsonList(rawList);
            }
          } else {
            message = decoded.toString();
          }
        } on FormatException {
          message = response.body.trim();
        }
      }

      final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

      return ApiResponse<List<MedicineOutputModel>>(
        statusCode: response.statusCode,
        data: isSuccess ? (medicines ?? []) : null,
        message: message ?? (isSuccess ? null : 'Failed to load inventory'),
      );
    } on FormatException catch (e) {
      return ApiResponse(statusCode: 502, data: null, message: e.toString());
    } catch (e) {
      return ApiResponse(statusCode: 500, data: null, message: e.toString());
    }
  }

  Future<ApiResponse<List<EmpBody>>> getAllEmployee({
    required String shopId,
  }) async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          data: null,
          message: 'Token is not valid',
        );
      }
      final response = await http
          .get(
            Uri.parse('$baseUrl/empe/get-all/$shopId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(Duration(seconds: 15));
      List<EmpBody>? allEmployee;
      String? message;
      if (response.body.trim().isNotEmpty) {
        try {
          final decode = jsonDecode(response.body);
          if (decode is List) {
            allEmployee = EmpBody.fromJsonList(decode);
          } else if (decode is Map<String, dynamic>) {
            message =
                decode['message']?.toString() ??
                decode['error']?.toString() ??
                decode['detail']?.toString();

            final rawList =
                decode['content'] ??
                decode['data'] ??
                decode['items'] ??
                decode['employee'];
            if (rawList is List) {
              allEmployee = EmpBody.fromJsonList(rawList);
            }
          } else {
            message = decode.toString();
          }
        } on FormatException {
          message = response.body.trim();
        }
      }
      return ApiResponse<List<EmpBody>>(
        statusCode: response.statusCode,
        data: response.statusCode >= 200 && response.statusCode < 300
            ? allEmployee
            : null,
        message: message,
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, data: null, message: e.toString());
    }
  }

  Future<ApiResponse<EmpBody>> changeActiveStatus({
    required String empId,
    required String shopId,
  }) async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          data: null,
          message: 'Token is not valid',
        );
      }

      final response = await http
          .put(
            Uri.parse('$baseUrl/empe/change-active/$shopId/$empId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));

      EmpBody? updatedEmp;
      String? message;

      if (response.body.trim().isNotEmpty) {
        try {
          final decode = jsonDecode(response.body);
          if (decode is Map<String, dynamic>) {
            updatedEmp = EmpBody.fromJson(decode);
            message =
                decode['message']?.toString() ??
                decode['error']?.toString() ??
                decode['detail']?.toString();
          } else {
            message = decode.toString();
          }
        } on FormatException {
          message = response.body.trim();
        }
      }

      final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

      return ApiResponse<EmpBody>(
        statusCode: response.statusCode,
        data: isSuccess ? updatedEmp : null,
        message: message ?? (isSuccess ? null : 'Failed to update active status'),
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, data: null, message: e.toString());
    }
  }
}

//
// {
// "id" : "a9ebcd13-149b-443c-9237-5a7d33924c00",
// "name" : "Klai 6",
// "email" : "kali6@gmail.com",
// "password" : "$2a$12$DNkDe.TRIzoV4TEaghy9jeMb2BuMGlNM0LAoC0bzZeswDrbXPmbwO",
// "role" : "Staff",
// "isFromOwner" : false,
// "activeStatus" : true,
// "createdAt" : "2026-10-30 11:56:05",
// "shop" : {
// "id" : "e9bf459e-0307-458a-a580-60768d3eda05",
// "shopName" : "xxx medical hall",
// "shopCode" : "PHM-F403F2",
// "shopEmail" : "xxx@123",
// "phone" : "8338388388",
// "address" : "cgv",
// "city" : "Medinīpur",
// "state" : "West Bengal",
// "pincode" : "721101",
// "licenseNumber" : "",
// "gstNumber" : "",
// "verifyStatus" : "Pending",
// "logoUrl" : null,
// "isOpen" : false,
// "isOwnerEmployee" : false,
// "owner" : {
// "id" : "a3ebeff3-c76b-4b73-9656-29e6f5132f73",
// "name" : "Soumen Maity",
// "email" : "sm8039912@gmail.com",
// "password" : "$2a$12$8Nrrwl9H1tRohhUaXkhqyOvjSZcCPtmoSqaAgeUJsZU0njbA/TVRS",
// "role" : "OWNER",
// "isShopHave" : true,
// "createdAt" : "2026-10-09 09:12:49",
// "hibernateLazyInitializer" : { }
// },
// "createdAt" : "2026-10-09 18:28:55"
// }
// }
