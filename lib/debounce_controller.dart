import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A controller that handles debounced input and processes the input
/// asynchronously, updating a list of data based on the result.
///
/// Use tag in `Get.put()` to make controller work with multiple instances.
class DebounceController<T> extends GetxController {
  /// The [TextEditingController] tied to the input field.
  final textEditingController = TextEditingController();

  /// A timer used to implement the debounce behavior.
  Timer? _debounce;

  /// Holds the last search text processed by the debounced function.
  String _searchText = "";

  /// A reactive list that holds the data fetched from [futureOperation].
  RxList<T> data = RxList([]);

  /// Optional error handler function that is triggered when an error occurs
  /// during the [futureOperation].
  Function(dynamic error, StackTrace stackTrace)? onError;

  /// Observable that indicates whether the controller is currently loading data.
  var loading = false.obs;

  /// The asynchronous operation that is triggered after the debounce period.
  /// It returns a list of data based on the current input in [textEditingController].
  final Future<List<T>> Function(TextEditingController) futureOperation;

  /// Duration for the debounce timer. Defaults to 500 milliseconds.
  Duration debounceDuration;

  /// Creates a [DebounceController] with the provided [futureOperation] and optional
  /// [debounceDuration] and [onError] handler.
  DebounceController({
    required this.futureOperation,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.onError,
  });

  @override
  void onInit() {
    super.onInit();
    // Start listening to changes in the text input.
    textEditingController.addListener(_onSearchChanged);
  }

  /// Internal method that handles text changes with debounce logic.
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(debounceDuration, () {
      // Perform the search if the text has changed.
      if (this._searchText != textEditingController.text) {
        loading.value = true;
        futureOperation(textEditingController).then((value) {
          loading.value = false;
          data.value = value;
        }).onError((error, stackTrace) async {
          if (onError != null) {
            loading.value = false;
            onError!(error, stackTrace);
          }
        });
      }
      this._searchText = textEditingController.text;
    });
  }

  @override
  void onClose() {
    // Remove the text change listener when the controller is closed.
    textEditingController.removeListener(_onSearchChanged);
    super.onClose();
  }
}
