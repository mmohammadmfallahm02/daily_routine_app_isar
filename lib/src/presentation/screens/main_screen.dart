import 'package:daily_routine_app_isar/src/data/product.dart';
import 'package:daily_routine_app_isar/src/data/routine.dart';
import 'package:daily_routine_app_isar/src/services/http_service.dart';
import 'package:daily_routine_app_isar/src/utils/config.dart';
import 'package:daily_routine_app_isar/src/utils/dimens.dart';
import 'package:daily_routine_app_isar/src/utils/themes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../widgets/routine_card_widget.dart';
import '../../services/isar_services.dart';
import 'create_routine_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final IsarServices isarServices = IsarServices();
  final HttpServices httpServices = HttpServices();
  final TextEditingController _searchController = TextEditingController();
  List<Routine>? routines;
  bool isLoading = true;
  String feedback = '';
  Color? feedbackColor;

  @override
  void initState() {
    isarServices.listenToRoutine();
    createFeedback();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            isarServices.clearAll();
          },
          label: const Text(
            'Delete All',
            style: TextStyle(color: Colors.red),
          )),
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
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
          ),
          IconButton(
              onPressed: () {
                _apiToisar();
              },
              icon: const Icon(Icons.download))
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.medium, horizontal: AppDimens.large),
                child: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                      hintText: 'Search routine',
                      hintStyle: TextStyle(fontStyle: FontStyle.italic)),
                  onChanged: _searchRoutineByName,
                )),
            _buildRoutineList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineList() {
    return (_searchController.text.isNotEmpty)
        ? _buildSearchResults()
        : _buildAllRoutines();
  }

  Widget _buildSearchResults() {
    return (routines != null)
        ? _buildListCards(routines!)
        : _buildNoResultsMessage();
  }

  Widget _buildAllRoutines() {
    return Column(
      children: [
        Text(
          feedback,
          style: TextStyle(color: feedbackColor),
        ),
        StreamBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Routine> routines = snapshot.data!;
              return _buildListCards(routines);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
          stream: isarServices.listenToRoutine(),
        ),
        FutureBuilder<List<Product>>(
            future: generateProducts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppDimens.small,
                    mainAxisSpacing: AppDimens.small,
                    padding: const EdgeInsets.only(
                        top: AppDimens.large, bottom: AppDimens.large * 5),
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: List.generate(snapshot.data!.length, (index) {
                      final item = snapshot.data![index];
                      return Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(AppDimens.small),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .4,
                                  height: 90,
                                  child: Image.network(
                                    item.image!,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    item.title!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {}, child: const Text('View'))
                              ]),
                        ),
                      );
                    }),
                  );
                } else {
                  return const SizedBox();
                }
              } else {
                return const SizedBox();
              }
            })
      ],
    );
  }

  Widget _buildNoResultsMessage() {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.sizeOf(context).height / 3,
      ),
      child: const Center(
        child: Text(
          'No routine found!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _buildListCards(List<Routine> routines) {
    return ListView.builder(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.only(top: AppDimens.medium),
        shrinkWrap: true,
        itemCount: routines.length,
        itemBuilder: (BuildContext context, int index) {
          final item = routines[index];
          return RoutineCardWidget(
            isarServices: isarServices,
            routine: item,
          );
        });
  }

  Future<void> _searchRoutineByName(String searchName) async {
    final searchRoutines = await isarServices.getRoutineByName(searchName);
    setState(() {
      if (searchRoutines.isNotEmpty) {
        routines = searchRoutines;
      } else {
        routines = null;
      }
    });
  }

  createFeedback() {
    isarServices.listenToRoutine().listen((event) {
      setState(() {
        if (event.length > 3) {
          feedback = 'You have more than 3 tasks to do';
          feedbackColor = Colors.red;
        } else {
          feedback = 'You are right in track';
          feedbackColor = Colors.green;
        }
      });
    });
  }

  _apiToisar() async {
    httpServices.init(BaseOptions(
      baseUrl: baseUrl,
      contentType: 'application/json',
    ));
    final response = await httpServices.request(
        endpoint: 'products?limit=6', method: Method.GET);

    List<Map<String, dynamic>>? products = (response.data as List)
        .map((item) => item as Map<String, dynamic>)
        .toList();

    await isarServices.writeProducts(products);
    setState(() {});
  }

  Future<List<Product>> generateProducts() async {
    return await isarServices.getProducts();
  }
}
