import 'package:daily_routine_app_isar/screens/create_routine_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Color secondaryColor = Colors.indigo.withOpacity(.5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text('Routine'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CreateRoutine()));
            },
            icon: const Icon(Icons.add),
          )
        ],
        centerTitle: true,
      ),
    );
  }
}
