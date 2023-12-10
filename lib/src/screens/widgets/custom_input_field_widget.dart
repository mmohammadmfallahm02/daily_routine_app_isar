import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final TextStyle labelStyle;
  final TextEditingController controller;
  final double? widgetWidth;
  final bool hasButton;
  final bool? enabled;
  final void Function()? onPressed;

  const CustomInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.labelStyle,
    this.widgetWidth,
    this.hasButton = false,
    this.enabled,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: widgetWidth ?? MediaQuery.sizeOf(context).width * .88,
              child: TextFormField(
                enabled: enabled,
                controller: controller,
              ),
            ),
            if (hasButton)
              IconButton(
                  onPressed: onPressed, icon: const Icon(Icons.calendar_month))
          ],
        ),
      ],
    );
  }
}
