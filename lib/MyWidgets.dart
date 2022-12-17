import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localnotification/Constant.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Models/TaskModels.dart';

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
      this.gapWidth, this.textAlign})
      : super(key: key);

  final Function()? onTap;
  final String label;
  final double? circularInt;
  final double? height;
  final double? width;
  final Color? color;
  final IconData? iconData;
  final double? gapWidth;
  final TextAlign? textAlign;

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: textAlign,
              style: const TextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField(
      {Key? key,
      this.widget,
      this.hint,
      this.label,
      this.onTap,
      this.controller,
      this.readOnly,
      this.hintstyle,
      this.keyBoardType,
      this.focusNode})
      : super(key: key);

  final Widget? widget;
  final Function()? onTap;
  final String? hint;
  final String? label;
  final TextEditingController? controller;
  final bool? readOnly;
  final TextStyle? hintstyle;
  final TextInputType? keyBoardType;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (label == null) ? const Text("") : Text(label!),
            SizedBox(
              height: (label == null) ? 0 : 5,
            ),
            SizedBox(
              height: 45,
              child: TextFormField(
                focusNode: focusNode,
                keyboardType: keyBoardType,
                controller: controller,
                onTap: onTap,
                readOnly: readOnly ?? false,
                decoration: InputDecoration(
                    focusColor: Colors.redAccent,
                    suffixIcon: widget,
                    contentPadding: const EdgeInsets.only(left: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: hint,
                    hintStyle: hintstyle),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ));
  }
}

class TaskTile extends StatelessWidget {
  final TaskData? task;

  TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task?.title ?? "",
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: Colors.grey[200],
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  "${task!.startTime} - ${task!.endTime}",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              task?.note.toString() ?? "Null",
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 15, color: Colors.grey[100]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
