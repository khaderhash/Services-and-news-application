// import 'package:get/get.dart';
//
// class NotificationController extends GetxController {
//   final notifications = <Map<String, dynamic>>[
//     {
//       'title': 'لديك طلب جديد',
//       'body':
//           'يرجى مراجعة المركز المخصص ضمن المنطقة لإجراء فحص الإثنين واستلام نشرة',
//       'time': '20 دقيقة',
//       'isRead': false,
//       'date': 'today',
//     },
//     {
//       'title': 'لديك طلب جديد',
//       'body': 'تم تسجيل طلبك للحصول على جلسة سِيام إرشادية بعد التقييم',
//       'time': '34 دقيقة',
//       'isRead': true,
//       'date': 'today',
//     },
//     {
//       'title': 'تمت الموافقة على تسجيلك',
//       'body':
//           'تمت الموافقة على تسجيلك في برنامج ريادة الأعمال - الثلاثاء الساعة 12:00',
//       'time': '50 دقيقة',
//       'isRead': false,
//       'date': 'yesterday',
//     },
//     {
//       'title': 'اشعار متابعة',
//       'body': 'يرجى التحقق من بياناتك الشخصية لتأكيد الحجز',
//       'time': 'قبل يوم',
//       'isRead': true,
//       'date': 'yesterday',
//     },
//   ].obs;
//
//   void markAsRead(int index) {
//     notifications[index]['isRead'] = true;
//     notifications.refresh();
//   }
//
//   void markAllAsRead() {
//     for (var n in notifications) {
//       n['isRead'] = true;
//     }
//     notifications.refresh();
//   }
//
//   List<Map<String, dynamic>> get newNotifications =>
//       notifications.where((n) => n['isRead'] == false).toList();
//
//   List<Map<String, dynamic>> get yesterdayNotifications =>
//       notifications.where((n) => n['date'] == 'yesterday').toList();
// }
