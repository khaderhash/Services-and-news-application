// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'notification_controller.dart';
//
// class Notification extends StatelessWidget {
//   Notification({Key? key}) : super(key: key);
//
//   final controller = Get.put(NotificationController());
//   final Color primaryColor = const Color(0xFF4B2E83);
//   final Color lightPurple = const Color(0xFFCEA9FF);
//
//   Widget buildNotificationCard(
//     Map<String, dynamic> notification,
//     double screenWidth,
//     double screenHeight,
//     int index,
//   ) {
//     final bool isRead = notification['isRead'];
//
//     return GestureDetector(
//       onTap: () {
//         if (!isRead) controller.markAsRead(index);
//       },
//       child: Card(
//         color: isRead ? Colors.white : lightPurple,
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(screenWidth * 0.03),
//         ),
//         margin: EdgeInsets.symmetric(vertical: screenHeight * 0.007),
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             vertical: screenHeight * 0.015,
//             horizontal: screenWidth * 0.04,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 notification['title'],
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: screenWidth * 0.04,
//                   color: primaryColor,
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.008),
//               Text(
//                 notification['body'],
//                 style: TextStyle(
//                   fontSize: screenWidth * 0.035,
//                   color: Colors.black,
//                 ),
//                 textAlign: TextAlign.right,
//               ),
//               SizedBox(height: screenHeight * 0.012),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   notification['time'],
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.03,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildSection(
//     String title,
//     List<Map<String, dynamic>> items,
//     double screenWidth,
//     double screenHeight,
//   ) {
//     return items.isEmpty
//         ? const SizedBox()
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               SizedBox(height: screenHeight * 0.02),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   if (title == "جديد")
//                     TextButton(
//                       onPressed: controller.markAllAsRead,
//                       child: Text(
//                         "تحديد الكل كمقروء",
//                         style: TextStyle(
//                           color: primaryColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: screenWidth * 0.035,
//                         ),
//                       ),
//                     ),
//                   Padding(
//                     padding: EdgeInsets.only(right: screenWidth * 0.02),
//                     child: Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: screenWidth * 0.04,
//                         fontWeight: FontWeight.bold,
//                         color: primaryColor,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               ListView.builder(
//                 itemCount: items.length,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   final originalIndex = controller.notifications.indexOf(
//                     items[index],
//                   );
//                   return buildNotificationCard(
//                     items[index],
//                     screenWidth,
//                     screenHeight,
//                     originalIndex,
//                   );
//                 },
//               ),
//             ],
//           );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Obx(
//           () => ListView(
//             padding: EdgeInsets.symmetric(
//               horizontal: screenWidth * 0.04,
//               vertical: screenHeight * 0.015,
//             ),
//             children: [
//               Center(
//                 child: Text(
//                   "الإشعارات",
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.05,
//                     fontWeight: FontWeight.bold,
//                     color: primaryColor,
//                   ),
//                 ),
//               ),
//               buildSection(
//                 "جديد",
//                 controller.newNotifications,
//                 screenWidth,
//                 screenHeight,
//               ),
//               buildSection(
//                 "البارحة",
//                 controller.yesterdayNotifications,
//                 screenWidth,
//                 screenHeight,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
