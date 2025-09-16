import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData, Response, MultipartFile;
import '../../screens/login_view/login.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://sssdsy.pythonanywhere.com/api/';
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  bool _isRefreshing = false;

  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.read(key: 'accessToken');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401 &&
              !e.requestOptions.path.endsWith('/refresh/')) {
            if (!_isRefreshing) {
              _isRefreshing = true;

              try {
                final newAccessToken = await refreshToken();

                if (newAccessToken != null) {
                  await storage.write(
                    key: 'accessToken',
                    value: newAccessToken,
                  );
                  e.requestOptions.headers['Authorization'] =
                      'Bearer $newAccessToken';
                  final response = await _dio.fetch(e.requestOptions);
                  _isRefreshing = false;
                  return handler.resolve(response);
                }
              } catch (refreshError) {
                _isRefreshing = false;
                _logoutAndNavigateToLogin();
                return handler.reject(e);
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }
  Future<Response?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String address,
    required String gender,
    required String birthDate,
  }) async {
    try {
      final response = await _dio.post(
        '${_baseUrl}user/register/',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone': phone,
          'password': password,
          'confirm_password': confirmPassword,
          'address': address,
          'gender': gender,
          'birth_date': birthDate,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      print('REGISTER STATUS: ${response.statusCode}');
      print('REGISTER DATA: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('REGISTER ERROR STATUS: ${e.response?.statusCode}');
      print('REGISTER ERROR DATA: ${e.response?.data}');
      print('REGISTER ERROR MESSAGE: ${e.message}');
      return e.response;
    } catch (e) {
      print('REGISTER UNEXPECTED ERROR: $e');
      return null;
    }
  }

  // Future<Response> confirmRegisterOtp({
  //   required String email,
  //   required String otp,
  // }) async {
  //   return await _dio.post(
  //     '${_baseUrl}user/confirm-otp/',
  //     data: {'email': email, 'otp': otp},
  //   );
  // }
  Future<Response> confirmRegisterOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '${_baseUrl}user/confirm-otp/',
        data: {'email': email, 'otp': otp},
      );
      if (response.statusCode == 200) {
        await storage.write(key: 'verified_otp_for_${email}', value: otp);
      }
      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }
  // Future<Response> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   return await _dio.post(
  //     '${_baseUrl}user/login/',
  //     data: {'email': email, 'password': password},
  //   );
  // }

  Future<Response> login({
    required String email,
    required String password,
    // required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '${_baseUrl}user/login/',
        data: {
          'email': email, 'password': password,
          // 'otp': otp
        },
        // options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final accessToken = response.data['access'];
        final refreshToken = response.data['refresh'];
        if (accessToken != null && refreshToken != null) {
          await storage.write(key: 'accessToken', value: accessToken);
          await storage.write(key: 'refreshToken', value: refreshToken);
          await storage.delete(key: 'verified_otp_for_${email}');
        }
      }
      return response;
    } on DioException catch (e) {
      print("Login error: $e");
      rethrow;
    }
  }

  Future<String?> refreshToken() async {
    try {
      final refreshToken = await storage.read(key: 'refreshToken');
      if (refreshToken == null) return null;

      final dioRefresh = Dio();
      final response = await dioRefresh.post(
        '${_baseUrl}token/refresh/',
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        return response.data['access'];
      }
      return null;
    } catch (e) {
      print("Token refresh failed: $e");
      return null;
    }
  }

  void _logoutAndNavigateToLogin() async {
    await storage.deleteAll();
    Get.offAll(() => const Login());
    Get.snackbar('انتهت الجلسة', 'الرجاء تسجيل الدخول مرة أخرى');
  }

  Future<Response> forgotPassword({required String email}) async {
    return await _dio.post(
      '${_baseUrl}user/password/forgot/',
      data: {'email': email},
    );
  }

  Future<Response> confirmForgotPasswordOtp({
    required String email,
    required String otp,
  }) async {
    return await _dio.post(
      '${_baseUrl}user/password/confirm-otp/',
      data: {'email': email, 'otp': otp},
    );
  }

  Future<Response> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await _dio.post(
      '${_baseUrl}user/password/reset/',
      data: {
        'email': email,
        'otp': otp,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );
  }

  Future<Response> getProfile() async {
    return await _dio.get('${_baseUrl}user/profile/');
  }

  Future<Response> updateProfile(
    Map<String, dynamic> data, {
    String? imagePath,
  }) async {
    Map<String, dynamic> formDataMap = Map.from(data);
    if (imagePath != null) {
      formDataMap['profile_picture'] = await MultipartFile.fromFile(imagePath);
    }
    var formData = FormData.fromMap(formDataMap);
    return _dio.patch('${_baseUrl}user/profile/update/', data: formData);
  }

  Future<Response> logout() async {
    final refreshToken = await storage.read(key: 'refreshToken');
    if (refreshToken == null) {
      throw Exception("Refresh token not found. Cannot logout from server.");
    }
    return await _dio.post(
      '${_baseUrl}user/logout/',
      data: {'refresh': refreshToken},
    );
  }

  Future<Response> getBeneficiary() {
    return _dio.get('${_baseUrl}beneficiaries/me/');
  }

  Future<Response> createBeneficiary(Map<String, dynamic> data) {
    return _dio.post(
      '${_baseUrl}beneficiaries/',
      data: data,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<Response> updateBeneficiary(Map<String, dynamic> data) {
    return _dio.patch(
      '${_baseUrl}beneficiaries/me/',
      data: data,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<Response> getNewsList() {
    return _dio.get('${_baseUrl}news/');
  }

  Future<Response> getNewsDetails(int newsId) {
    return _dio.get('${_baseUrl}news/$newsId/');
  }

  Future<Response> getActivitiesList() {
    return _dio.get('${_baseUrl}activities/');
  }

  Future<Response> getActivityDetails(int activityId) {
    return _dio.get('${_baseUrl}activities/$activityId/');
  }

  Future<Response> getMaterialAid() {
    return _dio.get('${_baseUrl}material-aids/me/');
  }

  Future<Response> createMaterialAid({
    required String aidType,
    required String notes,
    required String deliveryDate,
  }) {
    var formData = FormData.fromMap({
      'aid_type': aidType,
      'notes': notes,
      'delivery_date': deliveryDate,
    });
    return _dio.post('${_baseUrl}material-aids/', data: formData);
  }

  Future<Response> deleteMaterialAid() {
    return _dio.delete('${_baseUrl}material-aids/me/delete/');
  }

  Future<Response> getProjectRequest() {
    return _dio.get('${_baseUrl}projects/me/');
  }

  Future<Response> createProjectRequest({
    required String projectType,
    required String ownership,
    required String area,
    required String experience,
    required String tools,
    String? notes,
  }) {
    return _dio.post(
      '${_baseUrl}projects/',
      data: {
        'project_type': projectType,
        'ownership': ownership,
        'area': area,
        'experience': experience,
        'tools': tools,
        'notes': notes,
      },
    );
  }

  Future<Response> deleteProjectRequest() {
    return _dio.delete('${_baseUrl}projects/me/delete/');
  }

  Future<Response> getMedicalAid() {
    return _dio.get('${_baseUrl}medical-aids/me/');
  }

  Future<Response> createMedicalAid({
    required String aidType,
    required String notes,
    required String medicalReportPath,
    required String deliveryDate,
  }) async {
    var formData = FormData.fromMap({
      'aid_type': aidType,
      'notes': notes,
      'medical_report': await MultipartFile.fromFile(medicalReportPath),
      'delivery_date': deliveryDate,
    });
    return _dio.post('${_baseUrl}medical-aids/', data: formData);
  }

  Future<Response> deleteMedicalAid() {
    return _dio.delete('${_baseUrl}medical-aids/me/delete/');
  }

  Future<Response> getFeedback() {
    return _dio.get('${_baseUrl}feedback/get/');
  }

  Future<Response> createFeedback({
    required int rating,
    required bool isSatisfied,
    required bool willUseAgain,
    String? notes,
  }) {
    return _dio.post(
      '${_baseUrl}feedback/add/',
      data: {
        'rating': rating,
        'is_satisfied': isSatisfied,
        'will_use_again': willUseAgain,
        'notes': notes,
      },
      options: Options(contentType: Headers.jsonContentType),
    );
  }
}
