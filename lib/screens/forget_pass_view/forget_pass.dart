import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../UI/shared/custom_widgets/custom_button.dart';
import '../../../UI/shared/custom_widgets/custom_text_form_fieled.dart';
import '../reset_pass_view/reset_pass.dart';
import '../sign_up_view/sign_up.dart';
import 'forgetpass_controller.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  ForgetPassController controler = ForgetPassController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: size.height * 0.03,
                right: size.width * 0.015,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.purple,
                  ),
                  onPressed: () => Get.back(),
                  iconSize: size.width * 0.1,
                ),
              ),

              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.17),

                      Text(
                        'هل نسيت كلمة السر \nالرجاء إدخال البريد الإلكتروني ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                          fontFamily: 'lemonada',
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 63, 23, 116),
                        ),
                      ),

                      SizedBox(height: size.height * 0.06),

                      CustomTextFormFieled(
                        hinText: "البريد الإلكتروني",
                        prefIcon: Icons.email_outlined,
                        controller: controler.emailController,
                        validater: (val) {
                          if (val!.isEmpty) return "please check your password";
                          if (val.length <= 3) return "password is too short";
                        },
                      ),

                      SizedBox(height: size.height * 0.015),
                      Obx(
                        () => Padding(
                          padding: EdgeInsets.only(top: size.height * 0.05),
                          child: controler.isLooading.value
                              ? SpinKitCircle(
                                  color: const Color.fromARGB(255, 63, 23, 116),
                                  size: size.width * 0.15,
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height: size.height * 0.065,
                                  child: CustomButton(
                                    text: "التالي",
                                    color: Colors.white,
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      63,
                                      23,
                                      116,
                                    ),
                                    borderColor: const Color.fromARGB(
                                      255,
                                      63,
                                      23,
                                      116,
                                    ),
                                    onPressed: () {
                                      controler.sendResetCode();
                                    },
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.015),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'هل تريد إنشاء حساب جديد؟',
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: const Color.fromARGB(255, 63, 23, 116),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.off(SignupPage());
                            },
                            child: Text(
                              ' انقر هنا',
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                color: const Color.fromARGB(255, 63, 23, 116),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: size.height * 0.03),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
