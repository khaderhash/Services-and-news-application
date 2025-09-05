import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app11/core/services/api_service.dart';
import 'package:my_app11/screens/login_view/login.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final birthController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  var isLoading = true.obs;
  var selectedGender = 'ذكر'.obs;

  var profileImageUrl = Rxn<String>();
  var selectedImageFile = Rxn<File>();

  String originalFullName = '',
      originalPhone = '',
      originalAddress = '',
      originalGender = '';
  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      selectedImageFile.value = null;
      final response = await _apiService.getProfile();
      if (response.statusCode == 200) {
        final data = response.data;

        originalFullName =
            '${data['first_name'] ?? ''} ${data['last_name'] ?? ''}';
        nameController.text = originalFullName;
        emailController.text = data['email'] ?? '';
        birthController.text = data['birth_date'] ?? '';
        originalPhone = data['phone'] ?? '';
        phoneController.text = originalPhone;
        originalAddress = data['address'] ?? '';
        addressController.text = originalAddress;
        originalGender = (data['gender'] == 'male') ? 'ذكر' : 'أنثى';
        selectedGender.value = originalGender;

        if (data['profile_picture'] != null &&
            data['profile_picture'].isNotEmpty) {
          final imageUrl =
              'https://sssdsy.pythonanywhere.com${data['profile_picture']}';
          profileImageUrl.value =
              '$imageUrl?v=${DateTime.now().millisecondsSinceEpoch}';
          print("image:$imageUrl");
        } else {
          profileImageUrl.value = null;
        }
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب بيانات الملف الشخصي');
    } finally {
      isLoading.value = false;
    }
  }

  void changeGender(String? gender) {
    if (gender != null) selectedGender.value = gender;
  }

  void saveProfile() async {
    Map<String, dynamic> updatedData = {};
    List<String> nameParts = nameController.text.trim().split(' ');
    String newFirstName = nameParts.isNotEmpty ? nameParts.first : '';
    String newLastName = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : '';
    if (nameController.text != originalFullName) {
      updatedData['first_name'] = newFirstName;
      updatedData['last_name'] = newLastName;
    }
    if (phoneController.text != originalPhone) {
      updatedData['phone'] = phoneController.text;
    }
    if (addressController.text != originalAddress) {
      updatedData['address'] = addressController.text;
    }
    if (selectedGender.value != originalGender) {
      updatedData['gender'] = (selectedGender.value == 'ذكر')
          ? 'male'
          : 'female';
    }
    if (updatedData.isEmpty && selectedImageFile.value == null) {
      Get.snackbar('معلومات', 'لم تقم بإجراء أي تغييرات لحفظها');
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await _apiService.updateProfile(
        updatedData,
        imagePath: selectedImageFile.value?.path,
      );

      Get.back();
      if (response.statusCode == 200) {
        Get.snackbar('نجاح', 'تم حفظ التغييرات بنجاح');
        final newData = response.data;
        originalFullName =
            '${newData['first_name'] ?? ''} ${newData['last_name'] ?? ''}';
        nameController.text = originalFullName;
        emailController.text = newData['email'] ?? '';
        birthController.text = newData['birth_date'] ?? '';
        originalPhone = newData['phone'] ?? '';
        phoneController.text = originalPhone;
        originalAddress = newData['address'] ?? '';
        addressController.text = originalAddress;
        originalGender = (newData['gender'] == 'male') ? 'ذكر' : 'أنثى';
        selectedGender.value = originalGender;
        if (newData['profile_picture'] != null &&
            newData['profile_picture'].isNotEmpty) {
          final imageUrl =
              'https://sssdsy.pythonanywhere.com${newData['profile_picture']}';
          profileImageUrl.value =
              '$imageUrl?v=${DateTime.now().millisecondsSinceEpoch}';
        } else {
          profileImageUrl.value = null;
        }
        selectedImageFile.value = null;
      } else {
        Get.snackbar('خطأ', 'حدث خطأ غير متوقع ');
      }
    } catch (e) {
      Get.back();
      Get.snackbar('خطأ', 'فشل حفظ التغييرات');
      print(e);
    }
  }

  void logout() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await _apiService.logout();
      Get.snackbar('نجاح', 'تم تسجيل الخروج من السيرفر بنجاح');
    } catch (e) {
      print(
        "Could not logout from server, but proceeding with local logout. Error: $e",
      );
      Get.snackbar('تنبيه', 'تم تسجيل الخروج من الجهاز فقط');
    } finally {
      await _storage.deleteAll();
      if (Get.isDialogOpen ?? false) Get.back();
      Get.offAll(() => const Login());
    }
  }

  void pickProfileImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      selectedImageFile.value = File(image.path);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    birthController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
