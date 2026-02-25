
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:aplication_1/config.dart';

class CambiarPasswordProvider extends ChangeNotifier{
  late String ruta;
  String message='';
  late IconData icon;
  late Color color;

  cambiarPasswordProvider(){
    print('Cambio de contraseña');
  }

  enviarCodigo(String dni)async{
    final url = Uri.parse('${ConfigRuta.ApiUrl}cliente/RestablecerContrasena?Documento=$dni');
    print(url);
    final response = await http.post(url);//2027

    if (response.statusCode == 200) {
      message= 'Se envió un código al correo';
      print(message);
      return 'exitoso';
    }else if (response.statusCode == 400) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      icon= Icons.crisis_alert_rounded;
      color= Colors.red;
      message= jsonResponse['mensaje'];
      print(message);
      return 'no exitoso';
    } else {
      icon=Icons.crisis_alert_rounded;
      color=Colors.red;
      message='error del sistema, intentelo más tarde';
      print(message);
      return 'error del sistema';
    } 

  }

  CambiarPassword(String dni, String password,String codigo)async{
    final url = Uri.parse('${ConfigRuta.ApiUrl}cliente/CambioContrasena');

    final passwordEncriptado = base64Encode(utf8.encode(password));

    print(url);
    // Configurar las cabeceras de la solicitud
    final headers = {
      'Content-Type': 'application/json',
    };

    // Construir el cuerpo de la solicitud en formato JSON
    final body =jsonEncode({
      'contraseña': passwordEncriptado,
      'dni': dni,
      'codigo': codigo,
    });

    // Enviar la solicitud POST
    final response = await http.post(url,headers: headers, body: body);

    if (response.statusCode == 200) {
      color= Colors.greenAccent;
      icon= Icons.check_circle_outline_rounded;
      message= 'Se actualizó la contraseña';
      print(message);
      return 'exitoso';
    }else if (response.statusCode == 400) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      icon= Icons.crisis_alert_rounded;
      color= Colors.red;
      message= jsonResponse['mensaje'];
      print(message);
      return 'no exitoso';
    } else {
      icon=Icons.crisis_alert_rounded;
      color=Colors.red;
      message='error del sistema, intentelo más tarde';
      print(message);
    } 
  }


}