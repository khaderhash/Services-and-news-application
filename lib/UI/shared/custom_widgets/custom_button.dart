import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.icon,
    required this.color,
    this.backgroundColor,
    this.borderColor,
    required this.onPressed,
    this.rounded,
    this.width,
  });

  final String text;
  final String? icon;

  final Color color;
  final Color? backgroundColor;
  final Color? borderColor;
  final Function onPressed;
  final double? rounded;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            SvgPicture.asset("images/$icon.svg", width: 30, height: 30),
            SizedBox(width: 20),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 25,
              color: color,
              fontFamily: 'lemonada',
            ),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(rounded ?? 10)),
        ),
        side: borderColor != null
            ? BorderSide(color: Color.fromARGB(255, 63, 23, 116))
            : null,
        //if(borderColor!=null)
        backgroundColor: backgroundColor ?? Color.fromARGB(255, 63, 23, 116),
        fixedSize: Size(width ?? 450, 50),
      ),
    );
  }
}
