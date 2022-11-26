import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  TextEditingController? textEditingController;
  IconData? prefixiconData;
  String? hintText;
  bool? isDone = false;

  CustomTextField({
    super.key,
    this.textEditingController,
    this.prefixiconData,
    this.hintText,
    this.isDone,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? action;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: widget.textEditingController,
        obscureText: false,
        textInputAction: widget.isDone! == false
            ? TextInputAction.next
            : TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.prefixiconData,
            color: Colors.purpleAccent,
          ),
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
