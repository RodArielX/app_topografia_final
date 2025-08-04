import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_page.dart';
import 'admin_locations.dart';
import 'lista_terrenos_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final supabase = Supabase.instance.client;

  Future<void> _logout(BuildContext context) async {
    await supabase.auth.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthPage()),
      );
    }
  }

  // 🔹 Eliminar usuario
  Future<void> _deleteUser(String id) async {
    await supabase.from('usuarios').delete().eq('id', id);
  }

  // 🔹 Cambiar estado activo/inactivo
  Future<void> _toggleActivo(String id, bool activo) async {
    await supabase.from('usuarios').update({'activo': !activo}).eq('id', id);
  }

  // 🔹 Diálogo para agregar usuario manual
  void _showAddUserDialog(BuildContext context) {
    final nombreController = TextEditingController();
    final emailController = TextEditingController();
    final rolController = TextEditingController(text: "topografo");

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Agregar Usuario"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: "Nombre")),
              TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email")),
              DropdownButtonFormField(
                value: "topografo",
                items: const [
                  DropdownMenuItem(value: "topografo", child: Text("Topógrafo")),
                  DropdownMenuItem(value: "admin", child: Text("Administrador")),
                ],
                onChanged: (value) {
                  rolController.text = value.toString();
                },
                decoration: const InputDecoration(labelText: "Rol"),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancelar")),
            ElevatedButton(
              onPressed: () async {
                await supabase.from('usuarios').insert({
                  'nombre': nombreController.text,
                  'email': emailController.text,
                  'rol': rolController.text,
                  'activo': true,
                });
                if (context.mounted) Navigator.pop(ctx);
              },
              child: const Text("Agregar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // 🔹 ahora tenemos 3 pestañas
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Panel de Administración"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people), text: "Usuarios"),
              Tab(icon: Icon(Icons.map), text: "Ubicaciones"),
              Tab(icon: Icon(Icons.landscape), text: "Terrenos"), // 🔹 nuevo tab
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _logout(context),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // 🔹 Lista de usuarios
            StreamBuilder<List<Map<String, dynamic>>>(
              stream:
                  supabase.from('usuarios').stream(primaryKey: ['id']).execute(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final usuarios = snapshot.data!;

                return ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    final user = usuarios[index];
                    return ListTile(
                      leading: Icon(
                        user['rol'] == 'admin'
                            ? Icons.verified_user
                            : Icons.person,
                        color: user['activo'] ? Colors.green : Colors.red,
                      ),
                      title: Text("${user['nombre']} (${user['rol']})"),
                      subtitle: Text(user['email']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              user['activo']
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.orange,
                            ),
                            onPressed: () =>
                                _toggleActivo(user['id'], user['activo']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(user['id']),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            // 🔹 Vista de ubicaciones (fase 4)
            const AdminLocations(),

            // 🔹 Vista de terrenos (fase 5)
            const ListaTerrenosPage(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddUserDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
