import 'package:flutter/material.dart';
import 'package:flutter_localnotification/Constant.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {Key? key,
      required this.onTap,
      required this.label,
      this.circularInt,
      this.height,
      this.width,
      this.color,
      this.iconData,
      this.gapWidth})
      : super(key: key);

  final Function()? onTap;
  final String label;
  final double? circularInt;
  final double? height;
  final double? width;
  final Color? color;
  final IconData? iconData;
  final double? gapWidth;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: (circularInt == null)
              ? BorderRadius.circular(0)
              : BorderRadius.circular(circularInt!),
          color: (color == null) ? primaryColor : color,
        ),
        child: Row(
          children: [
            Icon(iconData),
            SizedBox(
              width: gapWidth,
            ),
            Text(
              label,
              style: const TextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({Key? key, this.widget, this.hint, this.label, this.onTap, this.controller, this.readOnly, this.hintstyle})
      : super(key: key);

  final Widget? widget;
  final Function()?onTap;
  final String? hint;
  final String? label;
  final TextEditingController? controller;
  final bool? readOnly;
  final TextStyle? hintstyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (label == null) ? const Text("") : Text(label!),
             SizedBox(
              height: (label==null)?0:5,
            ),
            SizedBox(
              height: 45,
              child: TextFormField(
                controller: controller,
                onTap: onTap,
                readOnly:readOnly ?? false,
                decoration: InputDecoration(
                    suffixIcon: widget,
                    contentPadding: const EdgeInsets.only(left: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: hint,
                hintStyle:hintstyle),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ));
  }
}
