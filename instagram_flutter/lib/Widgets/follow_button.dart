import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {

  final Function()? function;
  final Color backgroundColor;
  final Color bordercolor;
  final String text;
  final Color textColor;

  const FollowButton({Key? key, this.function, required this.backgroundColor, required this.bordercolor, required this.text, required this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: function,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: bordercolor),
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Text(text,style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        width: 250,
        height: 27,
      ),


    );
  }
}
