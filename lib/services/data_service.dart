import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/data_model.dart';
import '../config/config.dart'; // Import config

class DataService {
  final List<String> urls = trustedUrls; // gebruik de urls uit config.dart

  static const Duration timeoutDuration = Duration(seconds: 5);

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
