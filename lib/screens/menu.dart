import 'package:aplication_1/providers/ingresar_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyMenu extends StatelessWidget {
  const MyMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final ingresarProvider = Provider.of<IngresarProvider>(context);
    final datosLength = ingresarProvider.datos.length;

    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidth * 0.7, // Responsive: 70% del ancho
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Encabezado con logo
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade800,
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://munisayan.gob.pe/Rentas/Recursos/logo1.png',
                    fit: BoxFit.contain,
                    width: screenWidth * 0.4,
                  ),
                ),
              ),
            ),

            // Opciones dinámicas
            if (datosLength > 1)
              _MenuItem(
                label: "Viviendas",
                icon: Icons.home,
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'viviendas');
                },
              ),

            _MenuItem(
              label: "Cambiar Contraseña",
              icon: Icons.lock_reset,
              onTap: () {
                Navigator.pushReplacementNamed(context, 'validar_dni');
              },
            ),

            const Divider(height: 30),

            // Cerrar sesión al final
            _MenuItem(
              label: "Cerrar Sesión",
              icon: Icons.exit_to_app,
              color: Colors.red.shade700,
              onTap: () {
                Navigator.pushReplacementNamed(context, 'inicio');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 28, color: color ?? Colors.blueGrey.shade800),
      title: Text(
        label,
        style: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: color ?? Colors.blueGrey.shade900,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    );
  }
}
