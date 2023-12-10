import 'package:flutter/material.dart';

import 'src/screens/main_screen.dart';
import 'src/utils/dimens.dart';
import 'src/utils/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Routine app',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            inputDecorationTheme: InputDecorationTheme(
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppDimens.medium))),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppDimens.medium))),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.secondaryColor),
                borderRadius:
                    const BorderRadius.all(Radius.circular(AppDimens.medium)),
              ),
            ),
            elevatedButtonTheme: const ElevatedButtonThemeData(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(AppDimens.medium)))),
              ),
            ),
            dropdownMenuTheme: DropdownMenuThemeData(
                inputDecorationTheme: InputDecorationTheme(
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppDimens.medium))),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.secondaryColor),
                borderRadius:
                    const BorderRadius.all(Radius.circular(AppDimens.medium)),
              ),
            ))),
        home: const MainScreen());
  }
}
