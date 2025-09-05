import 'package:flutter/material.dart';

class Evaluation extends StatefulWidget {
  const Evaluation({Key? key}) : super(key: key);

  @override
  State<Evaluation> createState() => _EvaluationState();
}

class _EvaluationState extends State<Evaluation> {
  final Color primaryColor = Color(0xFF4B2E83);
  int selectedStars = 0;
  bool? receivedService;
  bool? wantToUseAgain;
  TextEditingController noteController = TextEditingController();

  void submitEvaluation() {
    print("نجوم: $selectedStars");
    print("الخدمة مرضية: $receivedService");
    print("الاستخدام لاحقاً: $wantToUseAgain");
    print("ملاحظات: ${noteController.text}");

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم إرسال التقييم ✅")));
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(width * 0.04),
          children: [
            Text(
              "قيّم تجربتك معنا:",
              style: TextStyle(
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                decoration: TextDecoration.underline,
                decorationColor: primaryColor,
                decorationThickness: 2,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: height * 0.012),
            Text(
              "نرجو منك تخصيص دقيقة من وقتك لتقييم تجربتك معنا. يساعدنا تقييمك في تحسين خدماتنا.",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: width * 0.042, color: Colors.black87),
            ),
            SizedBox(height: height * 0.024),
            Text(
              "• كيف تقيّم تجربتك بشكل عام؟",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: width * 0.042, color: Colors.black),
            ),
            SizedBox(height: height * 0.012),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    size: width * 0.08,
                    color: selectedStars > index ? primaryColor : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedStars = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: height * 0.018),
            Text(
              "• هل تلقيت خدمات الجمعية بشكل مرضي؟",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: width * 0.042, color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("نعم", style: TextStyle(fontSize: width * 0.042)),
                Checkbox(
                  value: receivedService == true,
                  onChanged: (val) {
                    setState(() {
                      receivedService = true;
                    });
                  },
                ),
                SizedBox(width: width * 0.03),
                Text("لا", style: TextStyle(fontSize: width * 0.042)),
                Checkbox(
                  value: receivedService == false,
                  onChanged: (val) {
                    setState(() {
                      receivedService = false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: height * 0.012),
            Text(
              "• هل تنوي الاستفادة من خدمات الجمعية مرة أخرى في المستقبل؟",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: width * 0.042, color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("نعم", style: TextStyle(fontSize: width * 0.042)),
                Checkbox(
                  value: wantToUseAgain == true,
                  onChanged: (val) {
                    setState(() {
                      wantToUseAgain = true;
                    });
                  },
                ),
                SizedBox(width: width * 0.03),
                Text("لا", style: TextStyle(fontSize: width * 0.042)),
                Checkbox(
                  value: wantToUseAgain == false,
                  onChanged: (val) {
                    setState(() {
                      wantToUseAgain = false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: height * 0.012),
            Text(
              "• هل لديك أي اقتراحات أو ملاحظات؟",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: width * 0.042, color: Colors.black),
            ),
            SizedBox(height: height * 0.008),
            SizedBox(
              height: height * 0.06,
              child: TextField(
                controller: noteController,
                maxLines: 1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'اكتب هنا...',
                ),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(height: height * 0.03),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: width * 0.5,
                height: height * 0.065,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: submitEvaluation,
                  child: Text(
                    'إرسال التقييم',
                    style: TextStyle(
                      fontSize: width * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
