import 'package:daily_routine_app_isar/src/data/routine.dart';
import 'package:daily_routine_app_isar/src/utils/dimens.dart';
import 'package:daily_routine_app_isar/src/utils/themes.dart';
import 'package:flutter/material.dart';

import '../widgets/routine_card_widget.dart';
import '../../services/isar_services.dart';
import 'create_routine_screen.dart';

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
    isarServices.listenToRoutine();
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
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildListCards(snapshot.data!
                .map((e) => Routine()
                  ..id = e.id
                  ..title = e.title
                  ..startTime = e.startTime
                  ..day = e.day
                  ..category.value = e.category.value)
                .toList());
          } else {
            return const CircularProgressIndicator();
          }
        },
        stream: isarServices.listenToRoutine(),
      ),
    );
  }

  _buildListCards(List<Routine> routines) {
    return ListView.builder(
        padding: const EdgeInsets.only(top: AppDimens.medium),
        shrinkWrap: true,
        itemCount: routines.length,
        itemBuilder: (BuildContext context, int index) {
          final item = routines[index];
          return RoutineCardWidget(
            isarServices: isarServices,
            routine: item,
          );
        });
  }
}
