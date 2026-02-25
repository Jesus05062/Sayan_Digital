import 'package:aplication_1/screens/principal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplication_1/config.dart';
import 'dart:convert';
import 'dart:convert' as convert;

class IngresarProvider extends ChangeNotifier{
  List<dynamic> datos =[];
  String contribProvider='';
  String message='';
   String token='';
  late String ruta;
  List<dynamic> listaPrincipal = [];

  ringresarProvider() {
    print('Ingresando');
  }

  obtenerContribuyente(String contrib)async{
    contribProvider = contrib;
    print('-----------------------');
    print(contribProvider);
    print('-----------------------');

  }



  Future <void> ingresar(String dni, String password)async{

    final ruta = Uri.parse('${ConfigRuta.ApiUrl}cliente/');
    
    final passwordEncriptado = base64Encode(utf8.encode(password));
    final url = Uri.parse('${ruta}Logeo?Documento=$dni&Password=$passwordEncriptado');
    
    print(url);
    
    final response = await http.get(url);
    print(response);
    print("------------------------");

    
    if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as List<dynamic>;
        datos =jsonResponse;
        print(datos);

        final firstItem = jsonResponse[0] as Map<String, dynamic>;
        contribProvider = firstItem['contrib'] ?? '';
        message= firstItem['mensaje'] ?? '' ;
        
        print(contribProvider);
        print(message);

        token= firstItem['token'] ?? '' ;
        print(token);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        notifyListeners();
      
    }else{
      message='Lo sentimos, el aplicativo está en mantenimiento, Se pasiente';
    }
  

  }


  Future<bool> PrincipalMenu(String contrib, String token) async {

    final url = Uri.parse(
        '${ConfigRuta.ApiUrl}clienteJesus/PrincipalMenu?Contribuyente=$contrib');
       print('******');
   print(url);
    final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
    final response = await http.get(url, headers: headers);
    print('/////////////////////');
    print(response);
    if  (response.statusCode ==401 || response.statusCode ==403)
    {
      return false;
    }
    final jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;

    listaPrincipal = jsonResponse;
   print(jsonResponse);   
   print(response.body);

    notifyListeners();
    
    return true;
  }
}