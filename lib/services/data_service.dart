import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:alls_monitor/models/models.dart';
import 'package:alls_monitor/config/config.dart';

/// Service die data ophaalt van vooraf gedefinieerde URLs.
///
/// Probeert URLs in [trustedUrls] achter elkaar totdat
/// data succesvol is opgehaald of alle opties faalden.
class DataService {
  /// Lijst van vertrouwde URL's (uit config).
  final List<String> urls = trustedUrls;

  /// Timeout voor HTTP requests.
  static const Duration timeoutDuration = Duration(seconds: 5);

  /// Haalt de data op en decodeert deze naar een [DataModel].
  ///
  /// Probeert elke URL uit [urls] totdat een succesvolle response
  /// met status 200 wordt ontvangen.
  ///
  /// Gooit een [Exception] als geen van de URLs data kan leveren.
  Future<DataModel> fetchData() async {
    for (final url in urls) {
      try {
        final response = await http
            .get(Uri.parse(url))
            .timeout(timeoutDuration);

        if (response.statusCode == 200) {
          final jsonMap = json.decode(response.body) as Map<String, dynamic>;
          return DataModel.fromJson(jsonMap);
        }
      } catch (e) {
        // Timeout of andere error, probeer volgende url
      }
    }
    throw Exception("Fout bij ophalen data van beide routes");
  }

  /// Haalt de raw JSON string op van de eerste werkende URL.
  ///
  /// Probeert URLs in volgorde en retourneert de body als string
  /// bij een status 200.
  ///
  /// Gooit een [Exception] als geen enkele URL succesvol is.
  Future<String> fetchRaw() async {
    for (final url in urls) {
      try {
        final response = await http
            .get(Uri.parse(url))
            .timeout(timeoutDuration);

        if (response.statusCode == 200) {
          return response.body;
        }
      } catch (e) {
        // Timeout of andere error, probeer volgende url
      }
    }
    throw Exception("Fout bij ophalen raw JSON van beide routes");
  }
}
