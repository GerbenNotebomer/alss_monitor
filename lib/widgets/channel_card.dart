import 'package:flutter/material.dart';
import 'package:alls_monitor/models/models.dart';

/// Kaart-widget die de gegevens van een [Channel] overzichtelijk weergeeft.
///
/// Toont naam, voltage, stroom, vermogen, temperatuur, vochtigheid en luchtdruk
/// als deze waarden aanwezig zijn.
///
class ChannelCard extends StatelessWidget {
  /// Het channel-model waarvan de gegevens getoond worden.
  final Channel channel;

  /// Constructor voor [ChannelCard].
  ///
  /// Vereist een niet-null [channel].
  const ChannelCard({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Naam van het channel
            Text(
              channel.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            // Optionele waarden, alleen tonen als niet null
            if (channel.voltage != null)
              Text("🔋 Voltage: ${channel.voltage!.toStringAsFixed(2)} V"),
            if (channel.current != null)
              Text("⚡ Stroom: ${channel.current!.toStringAsFixed(2)} A"),
            if (channel.power != null)
              Text("⚙️ Vermogen: ${channel.power!.toStringAsFixed(2)} W"),
            if (channel.temperatureAHT != null)
              Text(
                "🌡️ Temp AHT: ${channel.temperatureAHT!.toStringAsFixed(2)} °C",
              ),
            if (channel.humidityAHT != null)
              Text(
                "💧 Vochtigheid: ${channel.humidityAHT!.toStringAsFixed(2)} %",
              ),
            if (channel.temperatureBMP != null)
              Text(
                "🌡️ Temp BMP: ${channel.temperatureBMP!.toStringAsFixed(2)} °C",
              ),
            if (channel.pressure != null)
              Text("🧭 Luchtdruk: ${channel.pressure!.toStringAsFixed(2)} hPa"),
          ],
        ),
      ),
    );
  }
}
