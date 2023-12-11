import 'package:flutter/material.dart';

import '../../utils/dimens.dart';

class RoutineCardWidget extends StatelessWidget {
  final String title;
  final String routineTime;
  final String routineDay;
  const RoutineCardWidget(
      {super.key,
      required this.routineTime,
      required this.routineDay,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
          vertical: AppDimens.small * 1.5, horizontal: AppDimens.large),
      elevation: 4.0,
      child: ListTile(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(
                  top: AppDimens.medium, bottom: AppDimens.small),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.only(
                left: AppDimens.small, bottom: AppDimens.medium),
            child: Column(
              children: [
                _routineCardRichTxt(
                    text: routineTime, iconData: Icons.schedule),
                const SizedBox(
                  height: AppDimens.small,
                ),
                _routineCardRichTxt(
                    text: routineDay, iconData: Icons.calendar_month),
              ],
            ),
          )
        ]),
        trailing: const Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  Widget _routineCardRichTxt(
      {required String text, required IconData iconData}) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              iconData,
              size: AppDimens.medium,
            ),
          ),
          TextSpan(text: '\t$text', style: const TextStyle(color: Colors.black))
        ],
      ),
    );
  }
}
