import 'package:daily_routine_app_isar/src/data/category.dart';
import 'package:daily_routine_app_isar/src/data/routine.dart';
import 'package:daily_routine_app_isar/src/services/isar_services.dart';
import 'package:daily_routine_app_isar/src/utils/extension.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_dropdown_button_widget.dart';
import '../widgets/custom_input_field_widget.dart';
import '../../utils/dimens.dart';
import '../../utils/themes.dart';

class UpdateRoutineScreen extends StatefulWidget {
  final IsarServices isarServices;
  final Routine routine;
  const UpdateRoutineScreen(
      {super.key, required this.isarServices, required this.routine});

  @override
  State<UpdateRoutineScreen> createState() => _UpdateRoutineScreenState();
}

class _UpdateRoutineScreenState extends State<UpdateRoutineScreen> {
  List<Category>? categories;
  Category? selectedCategory;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _newCatController = TextEditingController();
  final GlobalKey<FormFieldState> _dayKey = GlobalKey();
  final GlobalKey<FormFieldState> _categoryKey = GlobalKey();

  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  String selectedDayOfWeek = 'Monday';
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    _setRoutineInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    TextStyle titleStyle = const TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
        fontSize: 18);
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: const Text('Update routine'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Delete Routine'),
                          content: const Text(
                              'Are you sure you want to delete this routine?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                widget.isarServices
                                    .deleteRoutineById(id: widget.routine.id);
                                Navigator.of(context)
                                  ..pop()
                                  ..pop();
                              },
                              child: const Text(
                                'Yes',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'No',
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          ],
                        ));
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomDropdownButton(
              label: 'Category',
              labelStyle: titleStyle,
              globalKey: _categoryKey,
              items: categories
                  ?.map<DropdownMenuItem>((e) => DropdownMenuItem<Category>(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              initialValue: selectedCategory,
              hasButton: true,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          surfaceTintColor: const Color(0xffffffff),
                          title: const Text('New Category'),
                          content: TextFormField(
                            controller: _newCatController,
                          ),
                          actions: [
                            ElevatedButton(
                                style: const ButtonStyle(
                                    minimumSize: MaterialStatePropertyAll(
                                        Size.fromHeight(50))),
                                onPressed: () {
                                  if (_newCatController.text.isNotEmpty) {
                                    widget.isarServices
                                        .addCategory(_newCatController.text);
                                  }
                                  _newCatController.clear();
                                  _readCategory();
                                  Navigator.pop(context);
                                },
                                child: const Text('Add'))
                          ],
                        ));
              },
            ),
            const SizedBox(
              height: AppDimens.large,
            ),
            CustomInputField(
              controller: _titleController,
              label: 'Title',
              labelStyle: titleStyle,
            ),
            const SizedBox(
              height: AppDimens.large,
            ),
            CustomInputField(
              label: 'Start Time',
              controller: _timeController,
              labelStyle: titleStyle,
              enabled: false,
              widgetWidth: size.width * .7,
              hasButton: true,
              onPressed: () {
                _selectedTime(context);
              },
            ),
            const SizedBox(
              height: AppDimens.large,
            ),
            CustomDropdownButton(
              label: 'Day',
              labelStyle: titleStyle,
              globalKey: _dayKey,
              initialValue: selectedDayOfWeek,
              items: days
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDayOfWeek = value!;
                });
              },
            ),
            const SizedBox(
              height: AppDimens.large * 1.5,
            ),
            Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    _updateRoutine();
                    Navigator.pop(context);
                  },
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppDimens.medium)))),
                      minimumSize:
                          MaterialStatePropertyAll(Size.fromHeight(50))),
                  child: const Text('Update'),
                ))
          ]),
        ),
      ),
    );
  }

  void _selectedTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial);

    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        _timeController.text = selectedTime.timeToString();
      });
    }
  }

  Future<void> _readCategory() async {
    categories = await widget.isarServices.getAllCategories();
    selectedCategory = null;
  }

  void _setRoutineInfo() async {
    await _readCategory();
    await _setCategoryValue();
    setState(() {
      final routine = widget.routine;
      _titleController.text = routine.title;
      _timeController.text = routine.startTime;
      selectedDayOfWeek = routine.day;
      selectedTime = routine.startTime.stringToTime();
    });
  }

  Future<void> _setCategoryValue() async {
    String? categoryTitle = widget.routine.category.value?.name;
    selectedCategory = categories!
        .firstWhere((Category element) => element.name == categoryTitle!);
  }

  Future<void> _updateRoutine() async {
    final currentRoutine =
        await widget.isarServices.getRoutineById(id: widget.routine.id);
    if (currentRoutine != null) {
      widget.isarServices.updateRoutine(
          updatedRoutine: currentRoutine
            ..title = _titleController.text
            ..startTime = _timeController.text
            ..day = selectedDayOfWeek
            ..category.value = selectedCategory!);
    }
  }
}
