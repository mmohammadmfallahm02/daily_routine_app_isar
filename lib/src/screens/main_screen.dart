import 'package:daily_routine_app_isar/src/data/routine.dart';
import 'package:daily_routine_app_isar/src/utils/dimens.dart';
import 'package:daily_routine_app_isar/src/utils/themes.dart';
import 'package:flutter/material.dart';

import '../services/isar_services.dart';
import 'create_routine_screen.dart';
import 'widgets/routine_card_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final IsarServices isarServices = IsarServices();
  List<Routine>? routines;
  bool isLoading = true;

  @override
  void initState() {
    setState(() {
      _readRoutine();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: const Text('Routine'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CreateRoutine(
                            isarServices: isarServices,
                          )));
            },
            icon: const Icon(Icons.add),
          )
        ],
        centerTitle: true,
      ),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.only(top: AppDimens.medium),
              shrinkWrap: true,
              itemCount: routines!.length,
              itemBuilder: (BuildContext context, int index) {
                final item = routines![index];
                return RoutineCardWidget(
                  title: item.title,
                  routineDay: item.day,
                  routineTime: item.startTime,
                );
              }),
    );
  }

  void _readRoutine() async {
    setState(() {
      isLoading = true;
    });

    routines = await isarServices.getAllRoutine();

    setState(() {
      isLoading = false;
    });
  }
}
