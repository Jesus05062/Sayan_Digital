import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aplication_1/config.dart';


class RegistroProvider extends ChangeNotifier{
  late String ruta;
  String message='';
  late IconData icon ;
  late Color color;

  registroProvider() {
    print('Registrando Usuario');
  }

  registrar(String correo, String password, String dni) async {
    final ruta = Uri.parse('${ConfigRuta.ApiUrl}');
    
    

print("aquiiiiiiiiiiiiiiiiii");
    final url = Uri.parse('${ruta}cliente/InsertarUsuario');

    // Encriptar el password en base 64
    final passwordEncriptado = base64Encode(utf8.encode(password));
    
    print(url);
    // Construir el cuerpo de la solicitud en formato JSON
    final body =jsonEncode({
      'correo': correo,
      'contraseña': passwordEncriptado,
      'dni': dni,
    });

    print(body);
    
    
    // Configurar las cabeceras de la solicitud
    final headers = {
      'Content-Type': 'application/json',
    };
    
    // Enviar la solicitud POST
    final response = await http.post(url,headers: headers, body: body);
    print('ddddddddddddd');
    print(response);
     if (response.statusCode == 200) {
      print("--------**************");
      color = Colors.greenAccent;
      icon = Icons.sentiment_satisfied_alt_rounded;
      message= 'Registro exitoso. Para activar su cuenta revise la Bandeja de Entrada de su correo.';
      return 'Registro exitoso';
    }else if (response.statusCode == 400) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      color = Colors.red;
      icon = Icons.sentiment_dissatisfied_rounded;
      message= jsonResponse['mensaje'];
      print(message);
      return 'no exitoso';
    } else {
      icon= Icons.error_outline_sharp;
      color= Colors.red;
      message='Error en el registro o ya estás registrado';
      print(message);
    } 
  }


}