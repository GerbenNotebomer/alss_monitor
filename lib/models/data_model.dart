import 'package:alls_monitor/models/models.dart';

/// Modelklasse die een dataset representeert met een tijdstempel en een lijst van kanalen.
///
/// [datetime] bevat de datum en tijd als string waarop de data is verzameld.
/// [channels] is een lijst van [Channel] objecten met sensorwaarden.
class DataModel {
  /// Datum en tijd van de data, in string formaat.
  final String datetime;

  /// Lijst van [Channel] objecten die de verschillende meetkanalen vertegenwoordigen.
  final List<Channel> channels;

  /// Constructor voor [DataModel].
  ///
  /// Beide parameters zijn verplicht.
  DataModel({required this.datetime, required this.channels});

  /// Maakt een [DataModel] instantie aan vanuit een JSON-map.
  ///
  /// Verwacht dat [json] een 'datetime' string en een lijst 'channels' bevat.
  /// Indien 'channels' ontbreekt, wordt een lege lijst gebruikt.
  factory DataModel.fromJson(Map<String, dynamic> json) {
    final channelsJson = json['channels'] as List<dynamic>? ?? [];
    final channels = channelsJson
        .map((c) => Channel.fromJson(c as Map<String, dynamic>))
        .toList();

    return DataModel(datetime: json['datetime'] ?? '', channels: channels);
  }

  /// Zet deze [DataModel] instantie om naar een JSON-map.
  ///
  /// De lijst van kanalen wordt ook omgezet naar JSON.
  Map<String, dynamic> toJson() {
    return {
      'datetime': datetime,
      'channels': channels.map((c) => c.toJson()).toList(),
    };
  }
}
