import 'package:flutter/material.dart';
import 'package:khadamat/widgets/custom_text_form_field.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({@required this.controller, @required this.label});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 15.0),
          padding: EdgeInsets.only(top: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            color: Colors.grey.withOpacity(0.5),
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(label),
                ],
              ),
              SizedBox(height: 5.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: Colors.white,
                ),
                child: CustomTextFormField(
                  controller: controller,
                  hint: null,
                  maxLines: 7,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
