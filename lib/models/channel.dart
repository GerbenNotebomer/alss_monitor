class Channel {
  final String name;
  final double? voltage;
  final double? current;
  final double? power;
  final double? temperatureAHT;
  final double? humidityAHT;
  final double? temperatureBMP;
  final double? pressure;

  Channel({
    required this.name,
    this.voltage,
    this.current,
    this.power,
    this.temperatureAHT,
    this.humidityAHT,
    this.temperatureBMP,
    this.pressure,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      name: json['name'] ?? 'Onbekend kanaal',
      voltage: (json['voltage'] as num?)?.toDouble(),
      current: (json['current'] as num?)?.toDouble(),
      power: (json['power'] as num?)?.toDouble(),
      temperatureAHT: (json['temperatureAHT'] as num?)?.toDouble(),
      humidityAHT: (json['humidityAHT'] as num?)?.toDouble(),
      temperatureBMP: (json['temperatureBMP'] as num?)?.toDouble(),
      pressure: (json['pressure'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (voltage != null) 'voltage': voltage,
      if (current != null) 'current': current,
      if (power != null) 'power': power,
      if (temperatureAHT != null) 'temperatureAHT': temperatureAHT,
      if (humidityAHT != null) 'humidityAHT': humidityAHT,
      if (temperatureBMP != null) 'temperatureBMP': temperatureBMP,
      if (pressure != null) 'pressure': pressure,
    };
  }
}
