import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:alls_monitor/models/models.dart';
import 'package:alls_monitor/services/services.dart';

/// Repository dat periodiek data ophaalt via [DataService]
/// en deze beschikbaar stelt via een [ValueNotifier].
///
/// Hiermee kan een widget of service zich abonneren op updates van data.
class DataRepository {
  final DataService _dataService;

  /// Interval tussen data-refreshes.
  final Duration refreshInterval;

  Timer? _timer;

  /// Notifier die de meest recente data bevat.
  ///
  /// Bevat `null` zolang er nog geen data is opgehaald.
  final ValueNotifier<DataModel?> dataNotifier = ValueNotifier(null);

  /// Maak een [DataRepository] aan met een [DataService] en optionele refresh-interval.
  ///
  /// Standaard wordt elke 5 seconden vernieuwd.
  DataRepository(
    this._dataService, {
    this.refreshInterval = const Duration(seconds: 5),
  });

  /// Start met periodiek data ophalen.
  ///
  /// Roept direct een eerste fetch aan en daarna elke [refreshInterval].
  void startFetching() {
    _fetchAndUpdateData();
    _timer = Timer.periodic(refreshInterval, (_) => _fetchAndUpdateData());
  }

  /// Stop met het periodiek ophalen van data.
  ///
  /// Moet bijvoorbeeld worden aangeroepen bij `dispose`.
  void stopFetching() {
    _timer?.cancel();
  }

  /// Haalt data op via [_dataService] en update [dataNotifier].
  ///
  /// Fouten worden opgevangen en genegeerd (optioneel te loggen).
  Future<void> _fetchAndUpdateData() async {
    try {
      final data = await _dataService.fetchData();
      dataNotifier.value = data;
    } catch (e) {
      // Optioneel: foutafhandeling of logging
      // print("Data ophalen mislukt: $e");
    }
  }
}
