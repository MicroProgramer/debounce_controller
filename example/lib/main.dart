import 'package:debounce_controller/debounce_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'DebounceController Example',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Creating multiple DebounceController instances using tags.
    final searchController1 = Get.put(
      DebounceController<String>(
        futureOperation: _searchOperation,
      ),
      tag: 'searchController1',
    );

    final searchController2 = Get.put(
      DebounceController<String>(
        futureOperation: _searchOperation,
      ),
      tag: 'searchController2',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('DebounceController Example')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchController1.textEditingController,
              decoration: const InputDecoration(
                labelText: 'Search 1',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController2.textEditingController,
              decoration: const InputDecoration(
                labelText: 'Search 2',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Obx(() {
            if (searchController1.loading.value) {
              return const CircularProgressIndicator();
            }
            return Expanded(
              child: ListView.builder(
                itemCount: searchController1.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchController1.data[index].toString()),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  // Example async search operation, replace with actual implementation.
  Future<List<String>> _searchOperation(TextEditingController controller) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return List.generate(5, (index) => 'Result ${index + 1} for "${controller.text}"');
  }
}
