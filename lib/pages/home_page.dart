import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin_page.dart';
import 'map_page.dart';
import '../services/auth_service.dart';
import '../main.dart';  // Para usar startLocationService

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = AuthService();
  String? rol;

  @override
  void initState() {
    super.initState();
    _loadUserRole();

    // Inicia servicio de localización en background cuando el usuario está logueado
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      startLocationService();
    }
  }

  Future<void> _loadUserRole() async {
    final user = _authService.currentUser;
    if (user == null) return;

    final response = await Supabase.instance.client
        .from('usuarios')
        .select('rol')
        .eq('id', user.id)
        .maybeSingle();

    setState(() {
      rol = response?['rol'] ?? 'topografo';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (rol == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (rol == 'admin') {
      return const AdminPage();
    } else {
      return const MapPage();
    }
  }
}