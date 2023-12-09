import 'package:flutter/material.dart';

class CreateRoutine extends StatefulWidget {
  const CreateRoutine({super.key});

  @override
  State<CreateRoutine> createState() => _CreateRoutineState();
}

class _CreateRoutineState extends State<CreateRoutine> {
  List<String> categories = ['work', 'school', 'home'];
  String dropdownButtonValue = 'work';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _newCatController = TextEditingController();
  List<String> days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  String selectedDayOfWeek = 'Mon';
  TimeOfDay selectedTime = TimeOfDay.now();
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
                  child: DropdownButton(
                    focusColor: const Color(0xffffffff),
                    dropdownColor: const Color(0xffffffff),
                    isExpanded: true,
                    items: categories
                        .map<DropdownMenuItem>((e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownButtonValue = value;
                      });
                    },
                    value: dropdownButtonValue,
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
                                      onPressed: () {},
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
              child: DropdownButton(
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
                  onPressed: () {},
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
}

class AppDimens {
  AppDimens._();
  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;
}
