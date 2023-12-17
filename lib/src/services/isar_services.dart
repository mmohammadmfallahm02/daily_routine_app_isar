import 'package:daily_routine_app_isar/src/data/category.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../data/routine.dart';

class IsarServices {
  late Future<Isar> db;

  IsarServices() {
    db = openDb();
  }

  Future<void> addCategory(String categoryTitle) async {
    final isar = await db;
    final newCategory = Category()..name = categoryTitle;
    isar.writeTxnSync(() => isar.categorys.putSync(newCategory));
  }

  Future<void> addRoutine({required Routine newRoutine}) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.routines.putSync(newRoutine));
  }

  Future<void> updateRoutine({required Routine updatedRoutine}) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.routines.putSync(updatedRoutine));
  }

  Stream<List<Routine>> listenToRoutine() async* {
    final isar = await db;
    yield* isar.routines.where().watch(fireImmediately: true);
  }

  Future<Routine?> getRoutineById({required int id}) async {
    final isar = await db;
    final routine = isar.routines.getSync(id);
    return routine;
  }

  Future<void> deleteRoutineById({required int id}) async {
    final isar = await db;
    isar.writeTxn(() => isar.routines.delete(id));
  }

  Future<List<Category>> getAllCategories() async {
    final isar = await db;
    final categories = await isar.categorys.where().findAll();
    return categories;
  }

  Future<List<Routine>> getAllRoutine() async {
    final isar = await db;
    final routine = await isar.routines.where().findAll();
    return routine;
  }

  Future<Isar> openDb() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([RoutineSchema, CategorySchema],
          directory: dir.path, inspector: true);
    }
    return Future.value(Isar.getInstance());
  }
}



  // Future<void> saveCourse(Course newCourse) async {
  //   final isar = await db;
  //   isar.writeTxnSync(<int>() => isar.courses.putSync(newCourse));
  // }

  // Future<void> saveStudent(Student newStudent) async {
  //   final isar = await db;
  //   isar.writeTxnSync(<int>() => isar.students.putSync(newStudent));
  // }

  // Future<void> saveTeacher(Teacher newTeacher) async {
  //   final isar = await db;
  //   isar.writeTxnSync(<int>() => isar.teachers.putSync(newTeacher));
  // }

  // Future<List<Course>> getAllCourses() async {
  //   final isar = await db;
  //   return await isar.courses.where().findAll();
  // }

  // Stream<List<Course>> listenToCourses() async* {
  //   final isar = await db;
  //   yield* isar.courses.where().watch(fireImmediately: true);
  // }

  // Future<void> cleanDb() async {
  //   final isar = await db;
  //   await isar.writeTxn(() => isar.clear());
  // }

  // Future<List<Student>> getStudentsFor(Course course) async {
  //   final isar = await db;
  //   return await isar.students
  //       .filter()
  //       .courses((q) => q.idEqualTo(course.id))
  //       .findAll();
  // }

  // Future<Teacher?> getTeacherFor(Course course) async {
  //   final isar = await db;
  //   final teacher = await isar.teachers
  //       .filter()
  //       .course((q) => q.idEqualTo(course.id))
  //       .findFirst();
  //   return teacher;
  // }