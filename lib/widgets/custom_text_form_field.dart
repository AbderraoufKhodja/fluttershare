import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Widget trailing;
  final TextEditingController controller;
  final String hint;
  final Function onTap;
  final Function(String text) validator;

  final bool readOnly;

  CustomTextFormField({
    @required this.controller,
    @required this.hint,
    this.trailing = const Text(""),
    this.onTap,
    this.validator,
    this.readOnly = false,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        ListTile(
          title: TextFormField(
            readOnly: readOnly,
            onTap: onTap,
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
            onSaved: (newValue) => controller.text = newValue,
            validator: validator,
          ),
          trailing: trailing,
        ),
        Divider(
          height: 0,
        ),
      ],
    );
  }
}
