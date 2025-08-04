import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminLocations extends StatefulWidget {
  const AdminLocations({super.key});

  @override
  State<AdminLocations> createState() => _AdminLocationsState();
}

class _AdminLocationsState extends State<AdminLocations> {
  final supabase = Supabase.instance.client;

  /// Convierte `last_update` en formato legible (ej: "hace 15s")
  String _timeAgo(String? isoDate) {
    if (isoDate == null) return "sin actualizar";
    try {
      final date = DateTime.parse(isoDate).toLocal();
      final diff = DateTime.now().difference(date);

      if (diff.inSeconds < 60) return "hace ${diff.inSeconds}s";
      if (diff.inMinutes < 60) return "hace ${diff.inMinutes}m";
      if (diff.inHours < 24) return "hace ${diff.inHours}h";
      return "${date.day}/${date.month} ${date.hour}:${date.minute}";
    } catch (e) {
      return "fecha inválida";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: supabase
          .from('usuarios')
          .stream(primaryKey: ['id'])
          .eq('rol', 'topografo') // solo topógrafos
          .execute(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final usuarios = snapshot.data!;
        final topografosConUbicacion = usuarios
            .where((u) => u['lat'] != null && u['lng'] != null)
            .toList();

        if (topografosConUbicacion.isEmpty) {
          return const Center(child: Text("No hay ubicaciones activas 📍"));
        }

        // Crear marcadores para cada topógrafo
        final markers = topografosConUbicacion.map((u) {
          final nombre = u['nombre'] ?? 'Topógrafo';
          final lastUpdate = _timeAgo(u['last_update']);

          return Marker(
            point: LatLng(u['lat'], u['lng']),
            width: 120,
            height: 80,
            child: Column(
              children: [
                const Icon(Icons.person_pin_circle,
                    color: Colors.red, size: 40),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 3)
                    ],
                  ),
                  child: Text(
                    "$nombre\n$lastUpdate",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          );
        }).toList();

        // Centrar el mapa en el primer topógrafo con ubicación
        final firstLocation = topografosConUbicacion.first;
        final center = LatLng(firstLocation['lat'], firstLocation['lng']);

        return FlutterMap(
          options: MapOptions(
            center: center,
            zoom: 14,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.topografia_app',
            ),
            MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }
}


