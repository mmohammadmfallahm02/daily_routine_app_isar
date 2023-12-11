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
    Key? key,
    required this.label,
    required this.controller,
    this.labelStyle = const TextStyle(),
    this.widgetWidth,
    this.hasButton = false,
    this.enabled,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widgetWidth == null
                ? Expanded(
                    child: TextFormField(
                      enabled: enabled,
                      controller: controller,
                    ),
                  )
                : SizedBox(
                    width: widgetWidth,
                    child: TextFormField(
                      enabled: enabled,
                      controller: controller,
                    ),
                  ),
            Visibility(
                visible: hasButton,
                child: IconButton(
                  onPressed: onPressed,
                  icon: const Icon(Icons.calendar_month),
                ))
          ],
        ),
      ],
    );
  }
}
