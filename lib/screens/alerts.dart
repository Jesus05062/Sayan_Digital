import 'package:flutter/material.dart';

void mostrarAlertaTokenExpirado(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Sesión expirada'),
      content: const Text('Tu sesión ha expirado. Por favor vuelve a iniciar sesión.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el diálogo
            Navigator.of(context).pushNamedAndRemoveUntil('inicio', (route) => false); // Ir a login
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
