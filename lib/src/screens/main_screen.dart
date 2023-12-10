

import 'package:flutter/material.dart';

import '../services/isar_services.dart';
import 'create_routine_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Color secondaryColor = Colors.indigo.withOpacity(.5);
  final IsarServices isarServices = IsarServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
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
    );
  }
}
