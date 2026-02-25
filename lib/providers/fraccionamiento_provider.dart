import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'package:aplication_1/config.dart';
import 'package:flutter/material.dart';

class FraccionamientoProvider extends ChangeNotifier {
  final String _baseUrl = ConfigRuta.url;
  final String message = 'No tiene deudas registradas';

  String predioGlobal = '';
  List<dynamic> datos = [];
  List<dynamic> total = [];
  List<dynamic> totales = [];
  List<dynamic> listaDeudasPorAnios = [];
  List<dynamic> listaDeudasDetalles = [];

  deudasProvider() {
    print('Ingresando a adeudasProvider');
  }

  Future<bool> getDatos(String contrib, String token) async {
    final url = Uri.parse(
        '${ConfigRuta.ApiUrl}clienteJesus/DatosContribuyente?Contribuyente=$contrib');

    final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
    final response = await http.get(url, headers: headers);
    if  (response.statusCode ==401 || response.statusCode ==403)
    {
      return false;
    }
    final jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;

    datos = jsonResponse;
    print(datos);
    notifyListeners();

    return true;
  }

  Future<bool> prediosDetalles(String contrib, String anio, String token) async {
    String tributo = '050';
    final url = Uri.parse(
        '${ConfigRuta.ApiUrl}clienteJesus/DetallesPredioPorAño?Contribuyente=$contrib&Ano=$anio&Tributo=$tributo');
    final urls = Uri.parse(
        '${ConfigRuta.ApiUrl}clienteJesus/TotalPredioPorAño?Contribuyente=$contrib&Ano=$anio&Tributo=$tributo');

    final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
    final response = await http.get(url, headers: headers);
    final responses = await http.get(urls, headers: headers);
    if  (response.statusCode ==401 || response.statusCode ==403)
    {
      return false;
    }
    final jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    final jsonResponses = convert.jsonDecode(responses.body) as List<dynamic>;

    listaDeudasDetalles = jsonResponse;
    totales = jsonResponses;

    notifyListeners();
    
    return true;
  }

  Future<bool> getPredios(String contrib, String token) async {
    String tributo = '050';

    final url = Uri.parse(
        '${ConfigRuta.ApiUrl}clienteJesus/PrediosAgrupadosPorAño?Contribuyente=$contrib&Tributo=$tributo'); //Predios
    final urls = Uri.parse(
        '${ConfigRuta.ApiUrl}clienteJesus/TotalesPrediosFraccionadosYDeuda?Contribuyente=$contrib&Tributo=$tributo'); // totales
    final urlTree = Uri.parse(
        '${ConfigRuta.ApiUrl}clienteJesus/SumaTotales?Contribuyente=$contrib&Tributo=$tributo');

    final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

    final response = await http.get(url, headers: headers);
 
    if  (response.statusCode ==401 || response.statusCode ==403)
    {
      return false;
    }

    final responses = await http.get(urls, headers: headers);

    final responsesTree = await http.get(urlTree, headers: headers);

    final jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    final jsoResponses = convert.jsonDecode(responses.body) as List<dynamic>;

    listaDeudasPorAnios = jsonResponse;
    total = jsoResponses;

    if (responsesTree.statusCode == 200) {
      final jsonResponsesTree =convert.jsonDecode(responsesTree.body) as List<dynamic>;

      final firstItem = jsonResponsesTree[0] as Map<String, dynamic>;
      predioGlobal = firstItem['general_predios'] ?? '';

    }

    notifyListeners();
    return true;
  }

}
