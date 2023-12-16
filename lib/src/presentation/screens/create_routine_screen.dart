import 'package:daily_routine_app_isar/src/data/category.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_dropdown_button_widget.dart';
import '../widgets/custom_input_field_widget.dart';
import '../../services/isar_services.dart';
import '../../utils/dimens.dart';
import '../../utils/themes.dart';

class CreateRoutine extends StatefulWidget {
  final IsarServices isarServices;
  const CreateRoutine({super.key, required this.isarServices});

  @override
  State<CreateRoutine> createState() => _CreateRoutineState();
}

class _CreateRoutineState extends State<CreateRoutine> {
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
    _readCategory();
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
        title: const Text('Create routine'),
        centerTitle: true,
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
                    addRoutine();
                    Navigator.pop(context);
                  },
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppDimens.medium)))),
                      minimumSize:
                          MaterialStatePropertyAll(Size.fromHeight(50))),
                  child: const Text('Add'),
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
        _timeController.text =
            '${selectedTime.hour}:${selectedTime.minute} ${selectedTime.period.name}';
      });
    }
  }

  void _readCategory() async {
    categories = await widget.isarServices.getAllCategories();
    selectedCategory = null;
    setState(() {});
  }

  void addRoutine() async {
    widget.isarServices.addRoutine(
        routineTitle: _titleController.text,
        startTimeRoutine: _timeController.text,
        routineDay: selectedDayOfWeek,
        routineCategory: selectedCategory!);

    setState(() {
      _titleController.clear();
      _timeController.clear();
      selectedCategory = null;
      selectedDayOfWeek = 'Monday';
      resetDropdownValue();
    });
  }

  void resetDropdownValue() {
    _categoryKey.currentState!.didChange(selectedCategory);
    _dayKey.currentState!.didChange(selectedDayOfWeek);
  }
}
