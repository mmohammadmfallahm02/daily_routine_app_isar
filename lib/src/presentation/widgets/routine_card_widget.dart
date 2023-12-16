import 'package:daily_routine_app_isar/src/data/routine.dart';
import 'package:daily_routine_app_isar/src/services/isar_services.dart';
import 'package:flutter/material.dart';

import '../screens/update_routine_screen.dart';
import '../../utils/dimens.dart';

class RoutineCardWidget extends StatelessWidget {
  final IsarServices isarServices;
  final Routine routine;
  const RoutineCardWidget({
    super.key,
    required this.isarServices,
    required this.routine,
  });

  @override
  Widget build(BuildContext context) {
    final title = routine.title;
    final routineTime = routine.startTime;
    final routineDay = routine.day;
    return Card(
      margin: const EdgeInsets.symmetric(
          vertical: AppDimens.small * 1.5, horizontal: AppDimens.large),
      elevation: 4.0,
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => UpdateRoutineScreen(
                        isarServices: isarServices,
                        routine: routine,
                      )));
        },
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
