import 'package:daily_routine_app_isar/src/data/category.dart';
import 'package:daily_routine_app_isar/src/data/product.dart';
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

  Future<List<Routine>> getRoutineByName(String searchName) async {
    final isar = await db;
    final routines =
        await isar.routines.filter().titleContains(searchName).findAll();
    return routines;
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

  Future<void> clearAll() async {
    final isar = await db;
    isar.writeTxn(() => isar.routines.clear());
  }

  Future<void> writeProducts(List<Map<String, dynamic>>? products) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.products.clear();
      await isar.products.importJson(products!);
    });
  }

  Future<List<Product>> getProducts() async {
    final isar = await db;
    final products = await isar.products.where().findAll();
    return products;
  }

  Future<Isar> openDb() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([RoutineSchema, CategorySchema,ProductSchema],
          directory: dir.path, inspector: true);
    }
    return Future.value(Isar.getInstance());
  }
}
