import 'package:flutter/material.dart';

import '../utils/colors.dart';

enum InputType { text, password, repassword, email, free,message }
typedef TextChangedCallBack = Function(String);

class CustomTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final InputType type;
  final String comparePassword;
  final TextChangedCallBack? onChanged;

  const CustomTextField(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      this.type = InputType.text,
      this.comparePassword = "", 
      this.onChanged});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      obscureText: (widget.type == InputType.password ||
              widget.type == InputType.repassword)
          ? !_isVisible
          : false,
      onChanged: widget.onChanged != null ? (text) {
        widget.onChanged!(text);
      } : null,
      maxLines: widget.type == InputType.message ? null : 1,
      decoration: InputDecoration(
          fillColor: const Color.fromARGB(255, 233, 233, 233),
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 233, 233, 233)),
              borderRadius: BorderRadius.circular(25.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: primaryColor, width: 2),
              borderRadius: BorderRadius.circular(25.0)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(25.0)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(25.0)),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: primaryColor),
          suffixIcon: (widget.type == InputType.password ||
                  widget.type == InputType.repassword)
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  icon: Icon(
                      _isVisible ? Icons.visibility_off : Icons.visibility))
              : null),
      validator: (value) {
        if (widget.type == InputType.free) return null;

        if (value == null || value.isEmpty) {
          return "Please enter this field";
        }

        if (widget.type == InputType.email) {
          return RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)
              ? null
              : "Please enter a valid email";
        } else if (widget.type == InputType.repassword &&
            widget.comparePassword.isNotEmpty) {
          return value == widget.comparePassword
              ? null
              : "Your re-enter password is not correct";
        }

        return null;
      },
    );
  }
}
