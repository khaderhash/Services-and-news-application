import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../forget_pass_view/forget_pass.dart';
import 'profile_controller.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final controller = Get.put(ProfileController(), permanent: true);

  final Color primaryColor = Color(0xFF4B2E83);

  final Color fieldColor = Color(0xFFE6D6FF);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          } else {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProfileAvatar(),
                  SizedBox(height: screenHeight * 0.012),
                  Text(
                    "المعلومات الشخصية",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  _buildTextField(
                    controller.nameController,
                    Icons.person,
                    screenWidth,
                  ),
                  _buildTextField(
                    controller.emailController,
                    Icons.email,
                    screenWidth,
                  ),
                  _buildTextField(
                    controller.birthController,
                    Icons.calendar_today,
                    screenWidth,
                  ),
                  _buildTextField(
                    controller.phoneController,
                    Icons.phone,
                    screenWidth,
                  ),
                  _buildTextField(
                    controller.addressController,
                    Icons.location_city,
                    screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.012),
                  _buildGenderSelection(screenWidth),
                  _buildChangePassword(screenWidth),
                  SizedBox(height: screenHeight * 0.006),
                  _buildSaveButton(screenWidth, screenHeight),
                  _buildLogoutButton(screenWidth, screenHeight),
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Center(
      child: Stack(
        children: [
          Obx(() {
            if (controller.selectedImageFile.value != null) {
              return CircleAvatar(
                radius: Get.width * 0.15,
                backgroundColor: Colors.grey[200],
                backgroundImage: FileImage(controller.selectedImageFile.value!),
              );
            } else if (controller.profileImageUrl.value != null) {
              return CircleAvatar(
                radius: Get.width * 0.15,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(
                  controller.profileImageUrl.value!,
                ),
              );
            } else {
              return CircleAvatar(
                radius: Get.width * 0.15,
                backgroundColor: Colors.grey[200],
                child: Icon(
                  Icons.person,
                  size: Get.width * 0.18,
                  color: Colors.grey[400],
                ),
              );
            }
          }),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: controller.pickProfileImage,
              child: CircleAvatar(
                radius: Get.width * 0.04,
                backgroundColor: primaryColor,
                child: Icon(
                  Icons.camera_alt,
                  size: Get.width * 0.05,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controllerField,
    IconData icon,
    double screenWidth,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.035),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
      ),
      child: TextFormField(
        controller: controllerField,
        decoration: InputDecoration(
          hintText: '',
          hintStyle: TextStyle(fontSize: screenWidth * 0.033),
          prefixIcon: Icon(
            icon,
            color: primaryColor,
            size: screenWidth * 0.037,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenWidth * 0.035,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelection(double screenWidth) {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: ListTile(
              title: Text(
                'ذكر',
                style: TextStyle(fontSize: screenWidth * 0.033),
              ),
              leading: Radio<String>(
                value: 'ذكر',
                groupValue: controller.selectedGender.value,
                activeColor: primaryColor,
                onChanged: (value) => controller.changeGender(value),
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(
                'أنثى',
                style: TextStyle(fontSize: screenWidth * 0.033),
              ),
              leading: Radio<String>(
                value: 'أنثى',
                groupValue: controller.selectedGender.value,
                activeColor: primaryColor,
                onChanged: (value) => controller.changeGender(value),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildChangePassword(double screenWidth) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Get.to(() => const ForgetPass());
        },
        child: Text(
          "تغيير كلمة السر",
          style: TextStyle(
            fontSize: screenWidth * 0.03,
            color: primaryColor,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(double screenWidth, double screenHeight) {
    return ElevatedButton(
      onPressed: controller.saveProfile,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        minimumSize: Size(double.infinity, screenHeight * 0.055),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.02),
        ),
      ),
      child: Text(
        "حفظ التغييرات",
        style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.white),
      ),
    );
  }

  Widget _buildLogoutButton(double screenWidth, double screenHeight) {
    return TextButton.icon(
      onPressed: () {
        Get.defaultDialog(
          buttonColor: primaryColor,
          title: "تأكيد تسجيل الخروج",
          middleText: "هل أنت متأكد أنك تريد تسجيل الخروج؟",
          textConfirm: "نعم",
          textCancel: "إلغاء",
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
            controller.logout();
          },
        );
      },
      icon: Icon(Icons.logout, color: Colors.red, size: screenWidth * 0.05),
      label: Text(
        "تسجيل الخروج",
        style: TextStyle(
          fontSize: screenWidth * 0.04,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
      ),
    );
  }
}
