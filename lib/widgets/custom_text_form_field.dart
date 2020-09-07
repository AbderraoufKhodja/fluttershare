import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Widget trailing;
  final TextEditingController controller;
  final String hint;
  final Function onTap;
  final Function(String text) validator;
  final TextStyle style;
  final int maxLines;
  final keyboardType;

  final bool readOnly;

  final bool enableInteractiveSelection;

  CustomTextFormField({
    @required this.controller,
    @required this.hint,
    this.trailing = const Text(""),
    this.onTap,
    this.validator,
    this.readOnly = false,
    this.style,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.enableInteractiveSelection = true,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        ListTile(
          title: TextFormField(
            enableInteractiveSelection: enableInteractiveSelection,
            readOnly: readOnly,
            onTap: onTap,
            controller: controller,
            style: style,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
            onSaved: (newValue) => controller.text = newValue,
            validator: validator,
            maxLines: maxLines,
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
