import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  TextEditingController? textEditingController;
  String? hintText;
  bool? isDone = false;

  PasswordTextField({
    super.key,
    this.textEditingController,
    this.hintText,
    this.isDone,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isVisable = false;

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
        obscureText: isVisable ? false : true,
        textInputAction: widget.isDone! == false
            ? TextInputAction.next
            : TextInputAction.done,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.lock,
              color: Colors.purpleAccent,
            ),
            hintText: widget.hintText,
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isVisable = !isVisable;
                  });
                },
                icon: isVisable
                    ? const Icon(
                        Icons.visibility_off,
                        color: Colors.purpleAccent,
                      )
                    : const Icon(
                        Icons.visibility,
                        color: Colors.purpleAccent,
                      ))),
      ),
    );
  }
}
