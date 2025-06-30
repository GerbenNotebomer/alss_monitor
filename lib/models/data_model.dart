import 'channel.dart';

class DataModel {
  final String datetime;
  final List<Channel> channels;

  DataModel({required this.datetime, required this.channels});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    final channelsJson = json['channels'] as List<dynamic>? ?? [];
    final channels = channelsJson
        .map((c) => Channel.fromJson(c as Map<String, dynamic>))
        .toList();

    return DataModel(datetime: json['datetime'] ?? '', channels: channels);
  }

  Map<String, dynamic> toJson() {
    return {
      'datetime': datetime,
      'channels': channels.map((c) => c.toJson()).toList(),
    };
  }
}
