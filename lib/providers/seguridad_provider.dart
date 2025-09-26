import 'package:aplication_1/config.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;


class SeguridadProvider extends ChangeNotifier {
  final String _baseUrl = ConfigRuta.url;

  final String message = 'No tiene deudas registradas';
  String arbitriosGlobalSeguridad='';

  List<dynamic> totalSeguridad=[];
  List<dynamic> totalesSeguridad=[];
  List<dynamic> listaDeudasPorContribSeguridad = [];
  List<dynamic> listaDeudasPorAniosSeguridad =[];
  List<dynamic> listaDeudasDetallesSeguridad= [];

  deudasProvider() {
    print('Ingresando a arbitriosProvider');
  }

  arbitriosSeguridadDetalles(String contrib, String anio) async{
    String tributo = '035';
    final url = Uri.parse('https://wxl1w6r0-7234.brs.devtunnels.ms/clienteJesus/DetallesPredioPorAño?Contribuyente=$contrib&Ano=$anio&Tributo=$tributo');
    final urls = Uri.parse('https://wxl1w6r0-7234.brs.devtunnels.ms/clienteJesus/TotalPredioPorAño?Contribuyente=$contrib&Ano=$anio&Tributo=$tributo');

    final response = await http.get(url);
    final responses = await http.get(urls);
    
    final jsonResponse= convert.jsonDecode(response.body) as List<dynamic>;
    final jsonResponses = convert.jsonDecode(responses.body) as List<dynamic>;

    listaDeudasDetallesSeguridad = jsonResponse;
    totalesSeguridad = jsonResponses;
    
    notifyListeners();
  }

  getArbitriosSeguridad(String contrib)async{
    String tributo = '035';

    final url = Uri.parse('https://wxl1w6r0-7234.brs.devtunnels.ms/clienteJesus/PrediosAgrupadosPorAño?Contribuyente=$contrib&Tributo=$tributo'); //Predios
    final urls =Uri.parse('https://wxl1w6r0-7234.brs.devtunnels.ms/clienteJesus/TotalesPrediosFraccionadosYDeuda?Contribuyente=$contrib&Tributo=$tributo');// totales
    final urlTree = Uri.parse('https://wxl1w6r0-7234.brs.devtunnels.ms/clienteJesus/SumaTotales?Contribuyente=$contrib&Tributo=$tributo');



    final response = await http.get(url);
    final responses = await http.get(urls);
    final responsesTree = await http.get(urlTree);

  
    final jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;

    final jsoResponses = convert.jsonDecode(responses.body) as List<dynamic>;
    
    listaDeudasPorAniosSeguridad = jsonResponse;
    totalSeguridad = jsoResponses;

    if (responsesTree.statusCode == 200) {
        final jsonResponsesTree = convert.jsonDecode(responsesTree.body) as List<dynamic>;
      
        final firstItem = jsonResponsesTree[0] as Map<String, dynamic>;
        arbitriosGlobalSeguridad = firstItem['general_predios'] ?? '';
        
        print(arbitriosGlobalSeguridad);
    } 

    notifyListeners();

    
  } 
}