import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/data_model.dart';

class DataService {
  final String url = "http://192.168.4.1/data.json";

  /// Haalt de data op en parsed naar DataModel (gebruik voor main en meters)
  Future<DataModel> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body) as Map<String, dynamic>;
      return DataModel.fromJson(jsonMap);
    } else {
      throw Exception("Fout bij ophalen data");
    }
  }

  /// Haalt de raw JSON-string op (voor bijvoorbeeld RawJsonScreen)
  Future<String> fetchRaw() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Fout bij ophalen raw JSON");
    }
  }
}
