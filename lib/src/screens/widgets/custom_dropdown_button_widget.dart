import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String label;
  final TextStyle labelStyle;
  final Key globalKey;
  final bool hasButton;
  final void Function()? onPressed;
  final void Function(dynamic)? onChanged;
  final dynamic initialValue;
  final List<DropdownMenuItem<dynamic>>? items;

  const CustomDropdownButton({
    super.key,
    required this.label,
    required this.labelStyle,
    this.hasButton = false,
    this.onPressed,
    required this.globalKey,
    this.items,
    this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: size.width * .7,
              child: DropdownButtonFormField(
                key: globalKey,
                focusColor: const Color(0xffffffff),
                dropdownColor: const Color(0xffffffff),
                isExpanded: true,
                items: items,
                onChanged: onChanged,
                value: initialValue,
                icon: const Icon(Icons.keyboard_arrow_down),
              ),
            ),
            Visibility(
                visible: hasButton,
                child: IconButton(
                    onPressed: onPressed,
                    icon: const Icon(Icons.add_circle_outline)))
          ],
        ),
      ],
    );
  }
}
