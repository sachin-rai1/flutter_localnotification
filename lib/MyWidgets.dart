import 'package:flutter/material.dart';
import 'package:flutter_localnotification/Constant.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.onTap, required this.label, this.circularInt, this.height,  this.width, this.color,  this.iconData, this.gapWidth})
      : super(key: key);

  final Function()? onTap;
  final String label;
  final double ? circularInt;
  final double ? height;
  final double ? width;
  final Color ? color;
  final IconData ? iconData;
  final double ? gapWidth;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius:(circularInt == null)?BorderRadius.circular(0):BorderRadius.circular(circularInt!),
          color:(color == null)?primaryColor:color,
        ),
        child:Row(

          children: [
            Icon(iconData),
            SizedBox(width: gapWidth,),
            Text(label , style: const TextStyle(),),
          ],
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField();
  }
}
