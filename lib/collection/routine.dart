import 'package:daily_routine_app_isar/collection/category.dart';
import 'package:isar/isar.dart';

part 'routine.g.dart';

@Collection()
class Routine {
  Id id = Isar.autoIncrement;

  late String title;

  @Index()
  late String startTime;

  @Index(caseSensitive: false)
  late String day;

  @Index(composite: [CompositeIndex('title')])
  final category = IsarLink<Category>();
}
