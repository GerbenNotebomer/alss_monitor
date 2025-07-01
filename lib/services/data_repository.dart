import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/data_model.dart';
import 'data_service.dart';

class DataRepository {
  final DataService _dataService;
  final Duration refreshInterval;
  Timer? _timer;

  // Deze notifier bevat de meest recente data, null als nog niks is opgehaald
  final ValueNotifier<DataModel?> dataNotifier = ValueNotifier(null);

  DataRepository(
    this._dataService, {
    this.refreshInterval = const Duration(seconds: 5),
  });

  // Start het periodiek ophalen van data
  void startFetching() {
    // Direct eerste fetch
    _fetchAndUpdateData();

    // Daarna elke refreshInterval seconden
    _timer = Timer.periodic(refreshInterval, (_) => _fetchAndUpdateData());
  }

  // Stop het periodiek ophalen (bv bij dispose)
  void stopFetching() {
    _timer?.cancel();
  }

  Future<void> _fetchAndUpdateData() async {
    try {
      final data = await _dataService.fetchData();
      dataNotifier.value = data; // update de notifier met nieuwe data
    } catch (e) {
      // Optioneel: log of handel errors af
      // Bijvoorbeeld: print("Data ophalen mislukt: $e");
    }
  }
}
