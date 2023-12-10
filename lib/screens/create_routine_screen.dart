import 'package:daily_routine_app_isar/collection/category.dart';
import 'package:daily_routine_app_isar/services/isar_services.dart';
import 'package:flutter/material.dart';

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
    const Color primaryColor = Colors.indigo;
    final Color secondaryColor = Colors.indigo.withOpacity(.5);
    final Size size = MediaQuery.sizeOf(context);
    TextStyle titleStyle = const TextStyle(
        fontWeight: FontWeight.bold, color: primaryColor, fontSize: 18);
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text('Create routine'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Category',
              style: titleStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * .7,
                  child: DropdownButtonFormField(
                    key: _categoryKey,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppDimens.medium))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: secondaryColor),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(AppDimens.medium)),
                        )),
                    focusColor: const Color(0xffffffff),
                    dropdownColor: const Color(0xffffffff),
                    isExpanded: true,
                    items: categories
                        ?.map<DropdownMenuItem>(
                            (e) => DropdownMenuItem<Category>(
                                  value: e,
                                  child: Text(e.name),
                                ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    value: selectedCategory,
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                surfaceTintColor: Color(0xffffffff),
                                title: const Text('New Category'),
                                content: TextFormField(
                                  controller: _newCatController,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(AppDimens.medium))),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: secondaryColor),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(AppDimens.medium)),
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                      style: const ButtonStyle(
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          AppDimens.medium)))),
                                          minimumSize: MaterialStatePropertyAll(
                                              Size.fromHeight(50))),
                                      onPressed: () {
                                        if (_newCatController.text.isNotEmpty) {
                                          widget.isarServices.addCategory(
                                              _newCatController.text);
                                        }
                                        _newCatController.clear();
                                        _readCategory();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Add'))
                                ],
                              ));
                    },
                    icon: const Icon(Icons.add_circle_outline))
              ],
            ),
            const SizedBox(
              height: AppDimens.large,
            ),
            Text('Title', style: titleStyle),
            TextFormField(
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius:
                        BorderRadius.all(Radius.circular(AppDimens.medium))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor),
                  borderRadius:
                      const BorderRadius.all(Radius.circular(AppDimens.medium)),
                ),
              ),
              controller: _titleController,
            ),
            const SizedBox(
              height: AppDimens.large,
            ),
            Text('Start Time', style: titleStyle),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * .7,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppDimens.medium))),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(AppDimens.medium)),
                      ),
                    ),
                    controller: _timeController,
                    enabled: false,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _selectedTime(context);
                    },
                    icon: const Icon(Icons.calendar_month))
              ],
            ),
            const SizedBox(
              height: AppDimens.large,
            ),
            Text('Day', style: titleStyle),
            SizedBox(
              width: size.width * .7,
              child: DropdownButtonFormField(
                  key: _dayKey,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppDimens.medium))),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(AppDimens.medium)),
                      )),
                  isExpanded: true,
                  focusColor: const Color(0xffffffff),
                  dropdownColor: const Color(0xffffffff),
                  value: selectedDayOfWeek,
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
                  }),
            ),
            const SizedBox(
              height: AppDimens.large * 1.5,
            ),
            Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    addRoutine();
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

class AppDimens {
  AppDimens._();
  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;
}
