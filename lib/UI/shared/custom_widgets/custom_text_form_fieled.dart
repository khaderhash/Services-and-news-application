import 'package:flutter/material.dart';

class CustomTextFormFieled extends StatelessWidget {
  const CustomTextFormFieled({
    super.key,
    required this.hinText,
    required this.prefIcon,
    this.suffIcon,
    this.suffIconColor,
    this.isSecure,
    required this.controller,
    this.validater,
    this.height,
    this.rounded,
    this.prefIconColor,
    this.errorText,
    this.borderColor,
    this.textColor,
    this.onSuffixTap,
    this.isDate = false, // ✅ جديد
  });

  final String hinText;
  final IconData prefIcon;
  final IconData? suffIcon;
  final Color? suffIconColor;
  final Color? prefIconColor;
  final bool? isSecure;
  final TextEditingController? controller;
  final String? Function(String?)? validater;
  final double? height;
  final double? rounded;
  final String? errorText;
  final Color? borderColor;
  final Color? textColor;
  final VoidCallback? onSuffixTap;
  final bool isDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TextFormField(
        obscureText: isSecure ?? false,
        controller: controller,
        validator: validater,
        readOnly: isDate, // ✅ ممنوع يكتب يدوي إذا كان تاريخ
        onTap: isDate
            ? () async {
                FocusScope.of(
                  context,
                ).requestFocus(FocusNode()); // يمنع الكيبورد
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000), // بداية من سنة 2000
                  firstDate: DateTime(1900), // أقدم تاريخ
                  lastDate: DateTime.now(), // ما يتجاوز اليوم
                );

                if (pickedDate != null && controller != null) {
                  controller!.text =
                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                }
              }
            : null,
        style: TextStyle(
          color: textColor ?? const Color.fromARGB(255, 63, 23, 116),
        ),
        decoration: InputDecoration(
          hintText: hinText,
          filled: true,
          fillColor: const Color.fromARGB(255, 206, 169, 255),
          prefixIcon: Icon(prefIcon),
          suffixIcon: suffIcon != null
              ? IconButton(icon: Icon(suffIcon), onPressed: onSuffixTap)
              : null,
          suffixIconColor:
              suffIconColor ?? const Color.fromARGB(255, 63, 23, 116),
          prefixIconColor:
              prefIconColor ?? const Color.fromARGB(255, 63, 23, 116),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(rounded ?? 10.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 206, 169, 255),
            ),
          ),
        ),
      ),
    );
  }
}
