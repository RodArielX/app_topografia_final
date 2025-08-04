import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_page.dart';
import 'terreno_page.dart';
import 'lista_terrenos_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final supabase = Supabase.instance.client;
  LatLng? myPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /// Obtiene la ubicación actual del dispositivo (solo para mostrar en el mapa)
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      myPosition = LatLng(pos.latitude, pos.longitude);
    });
  }

  Future<void> _logout(BuildContext context) async {
    await supabase.auth.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa de Topografía"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Menú Topógrafo",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            ListTile(
              leading: const Icon(Icons.add_location_alt),
              title: const Text("Registrar Terreno"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TerrenoPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text("Ver Terrenos"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ListaTerrenosPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: myPosition == null
          ? const Center(child: Text("📍 Obteniendo ubicación..."))
          : FlutterMap(
              options: MapOptions(
                initialCenter: myPosition!,
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.topografia_app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: myPosition!,
                      width: 80,
                      height: 80,
                      child: const Icon(Icons.location_on,
                          color: Colors.blue, size: 40),
                    ),
                  ],
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

