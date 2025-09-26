import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'package:aplication_1/config.dart';
import 'package:flutter/material.dart';

class PredioProvider extends ChangeNotifier {
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

  getDatos(String contrib) async {
    final url = Uri.parse(
        'https://wxl1w6r0-7234.brs.devtunnels.ms/clienteJesus/DatosContribuyente?Contribuyente=$contrib');

    final response = await http.get(url);

    final jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;

    datos = jsonResponse;
    print(datos);
    notifyListeners();

    return 'pasa';
  }

  prediosDetalles(String contrib, String anio) async {
    String tributo = '001';
    final url = Uri.parse(
        'https://wxl1w6r0-7234.brs.devtunnels.ms/clienteJesus/DetallesPredioPorAño?Contribuyente=$contrib&Ano=$anio&Tributo=$tributo');
    final urls = Uri.parse(
        'https://wxl1w6r0-7234.brs.devtunnels.ms/clienteJesus/TotalPredioPorAño?Contribuyente=$contrib&Ano=$anio&Tributo=$tributo');

    final response = await http.get(url);
    final responses = await http.get(urls);

    final jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    final jsonResponses = convert.jsonDecode(responses.body) as List<dynamic>;

    listaDeudasDetalles = jsonResponse;
    totales = jsonResponses;

    notifyListeners();
  }

  getPredios(String contrib) async {
    String tributo = '001';

    final url = Uri.parse(
        'https://wxl1w6r0-7234.brs.devtunnels.ms/clienteJesus/PrediosAgrupadosPorAño?Contribuyente=$contrib&Tributo=$tributo'); //Predios
    final urls = Uri.parse(
        'https://wxl1w6r0-7234.brs.devtunnels.ms/clienteJesus/TotalesPrediosFraccionadosYDeuda?Contribuyente=$contrib&Tributo=$tributo'); // totales
    final urlTree = Uri.parse(
        'https://wxl1w6r0-7234.brs.devtunnels.ms/clienteJesus/SumaTotales?Contribuyente=$contrib&Tributo=$tributo');
    print('**************************************');
    print(url);
    print(urls);
    print(urlTree);

    final response = await http.get(url);
    final responses = await http.get(urls);
    final responsesTree = await http.get(urlTree);

    print('**************************************');
    print(response);
    print(responses);
    print(responsesTree);

    final jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    final jsoResponses = convert.jsonDecode(responses.body) as List<dynamic>;

    listaDeudasPorAnios = jsonResponse;
    total = jsoResponses;

    if (responsesTree.statusCode == 200) {
      final jsonResponsesTree =convert.jsonDecode(responsesTree.body) as List<dynamic>;

      final firstItem = jsonResponsesTree[0] as Map<String, dynamic>;
      predioGlobal = firstItem['general_predios'] ?? '';

      print(predioGlobal);
    }

    

    notifyListeners();
  }
}
