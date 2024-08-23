# DebounceController

`DebounceController` is a Flutter package that provides a simple yet powerful way to handle
debounced text input operations with support for asynchronous functions. It leverages the `GetX`
package for reactive state management and allows for easy integration of debounce functionality in
your Flutter applications.

## Features

- **Debounced Text Input**: Prevents frequent calls to a function while typing.
- **Asynchronous Operation Support**: Handle complex operations like API requests seamlessly.
- **Multiple Controller Support**: Create and manage multiple `DebounceController` instances using
  unique tags.
- **Error Handling**: Custom error handling with callback support.
- **Reactive State Management**: Built on top of `GetX`, providing a reactive experience.

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  debounce_controller: <latest_version>
  get: <latest_version>
```

Then run `flutter pub get` to install the package.

## Usage

### 1. Import the package

```dart
import 'package:debounce_controller/debounce_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
```

### 2. Create a DebounceController

You can create a `DebounceController` instance using `Get.put` with an optional tag if you need
multiple controllers:

```dart

final searchController1 = Get.put(
      () =>
      DebounceController<String>(
        futureOperation: _searchOperation,
      ),
  tag: 'searchController1',
);
```

### 3. Implement the Future Operation

The `DebounceController` requires a `Future<List<T>> Function(TextEditingController)` to process the
text input:

```dart
Future<List<String>> _searchOperation(TextEditingController controller) async {
  await Future.delayed(Duration(seconds: 1)); // Simulate network delay
  return List.generate(5, (index) => 'Result ${index + 1} for "${controller.text}"');
}
```

### 4. Build the UI

Use the `DebounceController` in your UI, reacting to data and loading states:

```dart
Obx
(
() {
if (searchController1.loading.value) {
return CircularProgressIndicator();
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
})
,
```

### 5. Full Example

Here’s a complete example in `main.dart`:

```dart
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

```

### 6. Error Handling

You can handle errors using the `onError` parameter:

```dart

final searchController = Get.put(
      () =>
      DebounceController<String>(
        futureOperation: _searchOperation,
        onError: (error, stackTrace) {
          print('Error: $error');
        },
      ),
);
```
