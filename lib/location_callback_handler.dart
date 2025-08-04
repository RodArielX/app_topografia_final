import 'package:background_locator_2/location_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void callback(LocationDto locationDto) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;

  if (user != null) {
    await supabase.from('usuarios').update({
      'lat': locationDto.latitude,
      'lng': locationDto.longitude,
      'last_update': DateTime.now().toIso8601String(),
    }).eq('id', user.id);
  }

  print("Ubicación enviada: ${locationDto.latitude}, ${locationDto.longitude}");
}

void initCallback(Map<dynamic, dynamic> params) {
  print("BackgroundLocator inicializado");
}

void disposeCallback() {
  print("BackgroundLocator finalizado");
}