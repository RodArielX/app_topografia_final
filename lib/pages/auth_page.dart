import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nombreController = TextEditingController();

  bool isLogin = true;
  String mensaje = "";

  Future<void> _handleAuth() async {
    try {
      if (isLogin) {
        await _authService.signIn(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        await _authService.signUp(
          _emailController.text,
          _passwordController.text,
          _nombreController.text,
        );
      }

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      setState(() {
        mensaje = "❌ Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Login" : "Registro")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (!isLogin)
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: "Nombre"),
              ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleAuth,
              child: Text(isLogin ? "Iniciar Sesión" : "Registrarse"),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin
                  ? "¿No tienes cuenta? Regístrate"
                  : "¿Ya tienes cuenta? Inicia sesión"),
            ),
            const SizedBox(height: 20),
            Text(mensaje),
          ],
        ),
      ),
    );
  }
}

