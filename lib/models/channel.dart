/// Modelklasse die een meetkanaal representeert met diverse sensorwaarden.
///
/// Bevat optionele waarden voor spanning, stroom, vermogen en sensorgegevens
/// zoals temperatuur, luchtvochtigheid en druk.
class Channel {
  /// Naam van het kanaal, bijvoorbeeld 'MPPT 1' of 'Accu 1'.
  final String name;

  /// Spanning in Volt (V), indien beschikbaar.
  final double? voltage;

  /// Stroom in Ampère (A), indien beschikbaar.
  final double? current;

  /// Vermogen in Watt (W), indien beschikbaar.
  final double? power;

  /// Temperatuur van de AHT-sensor in graden Celsius, indien beschikbaar.
  final double? temperatureAHT;

  /// Luchtvochtigheid van de AHT-sensor in procenten (%), indien beschikbaar.
  final double? humidityAHT;

  /// Temperatuur van de BMP-sensor in graden Celsius, indien beschikbaar.
  final double? temperatureBMP;

  /// Druk gemeten door de BMP-sensor in hPa, indien beschikbaar.
  final double? pressure;

  /// Constructor voor [Channel].
  ///
  /// [name] is verplicht. Alle andere parameters zijn optioneel en kunnen null zijn.
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

  /// Maakt een [Channel] instantie aan vanuit een JSON-map.
  ///
  /// Verwacht dat [json] keys bevat als 'name', 'voltage', 'current', etc.
  /// Ontbrekende velden krijgen een standaardwaarde of null.
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

  /// Zet deze [Channel] instantie om naar een JSON-map.
  ///
  /// Alleen niet-null velden worden opgenomen in het resultaat.
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
