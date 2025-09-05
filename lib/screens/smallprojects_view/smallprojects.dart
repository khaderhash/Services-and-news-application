import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app11/screens/smallprojects_view/smallprojects_controller.dart';

class SmallProjects extends StatefulWidget {
  final String imagePath;

  const SmallProjects({super.key, required this.imagePath});

  @override
  State<SmallProjects> createState() => _SmallProjectsState();
}

class _SmallProjectsState extends State<SmallProjects> {
  final SmallProjectsController controller = Get.put(SmallProjectsController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                widget.imagePath,
                width: screenWidth,
                height: screenHeight * 0.45,
                fit: BoxFit.cover,
              ),
            ],
          ),
          Transform.translate(
            offset: Offset(0, -screenHeight * 0.03),
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(screenWidth * 0.08),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: controller.buttons.map((button) {
                    return OutlinedButton(
                      onPressed: () {
                        Get.to(button['page']());
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: controller.violetColor),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.03,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.015,
                        ),
                      ),
                      child: Text(
                        button['title'],
                        style: TextStyle(
                          color: controller.violetColor,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
