import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListaTerrenosPage extends StatefulWidget {
  const ListaTerrenosPage({super.key});

  @override
  State<ListaTerrenosPage> createState() => _ListaTerrenosPageState();
}

class _ListaTerrenosPageState extends State<ListaTerrenosPage> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terrenos Guardados")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: supabase.from('terrenos').select(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final terrenos = snapshot.data!;
          if (terrenos.isEmpty) {
            return const Center(child: Text("No hay terrenos registrados"));
          }

          return ListView.builder(
            itemCount: terrenos.length,
            itemBuilder: (context, index) {
              final terreno = terrenos[index];
              final coords = (jsonDecode(terreno['coordenadas']) as List)
                  .map((p) => LatLng(p['lat'], p['lng']))
                  .toList();

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.landscape, color: Colors.green),
                  title: Text(terreno['nombre']),
                  subtitle: Text(
                      "Área: ${terreno['area'].toStringAsFixed(2)} m²\n"
                      "Toca para ver detalles"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TerrenoDetallePage(
                          nombre: terreno['nombre'],
                          puntos: coords,
                          area: terreno['area'],
                          explicacion: terreno['explicacion'], // explicación
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class TerrenoDetallePage extends StatelessWidget {
  final String nombre;
  final List<LatLng> puntos;
  final double area;
  final String? explicacion;

  const TerrenoDetallePage({
    super.key,
    required this.nombre,
    required this.puntos,
    required this.area,
    this.explicacion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nombre)),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: puntos.first,
          initialZoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.topografia_app',
          ),
          PolygonLayer(
            polygons: [
              Polygon(
                points: puntos,
                color: Colors.green.withOpacity(0.3),
                borderColor: Colors.green,
                borderStrokeWidth: 3,
              ),
            ],
          ),
          MarkerLayer(
            markers: puntos
                .map(
                  (p) => Marker(
                    point: p,
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.location_on,
                        color: Colors.blue, size: 30),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Área total: ${area.toStringAsFixed(2)} m²",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            if (explicacion != null && explicacion!.isNotEmpty)
              ExpansionTile(
                title: const Text("📘 Ver cómo se calculó el área"),
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      explicacion!,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

