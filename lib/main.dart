import 'package:aplication_1/providers/cambiar_password_provider.dart';
import 'package:aplication_1/providers/limpieza_provider.dart';
import 'package:aplication_1/providers/ingresar_provider.dart';
import 'package:aplication_1/providers/predios_provider.dart';
import 'package:aplication_1/providers/registro_provider.dart';
import 'package:aplication_1/providers/seguridad_provider.dart';
import 'package:aplication_1/screens/arbitrios/arbitrios_limpieza.dart';
import 'package:aplication_1/screens/arbitrios/arbitrios_seguridad.dart';
import 'package:aplication_1/screens/arbitrios/limpieza_detalles.dart';
import 'package:aplication_1/screens/arbitrios/seguridad_detalles.dart';
import 'package:aplication_1/screens/login/acceder.dart';
import 'package:aplication_1/screens/login/registro.dart';
import 'package:aplication_1/screens/login/validar_cambio.dart';
import 'package:aplication_1/screens/login/validar_dni.dart';
import 'package:aplication_1/screens/predios/predios_detalles.dart';
import 'package:aplication_1/screens/login/acceder_registrar.dart';
import 'package:aplication_1/screens/login/splash_art.dart';
import 'package:aplication_1/screens/arbitrios/select_arbitrios.dart';
import 'package:aplication_1/screens/principal.dart';
import 'package:aplication_1/screens/viviendas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/predios/predios.dart';

void main() async{
  /* WidgetsFlutterBinding.ensureInitialized();
  final ingresarProvider = IngresarPr
  ovider();
  await ingresarProvider.inicio(); */
  /* WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init(); */
  
  runApp( const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async {
        // Deshabilitar el botón de "regresar"
        return false;
      },
      child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PredioProvider(), lazy: false,),
        ChangeNotifierProvider(create: (_) => ArbitriosProvider(), lazy: false,),
        ChangeNotifierProvider(create: (_) => SeguridadProvider(), lazy: false,),
        ChangeNotifierProvider(create: (_) => RegistroProvider(), lazy: false,),
        ChangeNotifierProvider(create: (_) => IngresarProvider(), lazy: false,),
        ChangeNotifierProvider(create: (_) => CambiarPasswordProvider(), lazy: false),
      ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App de Consultas',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: 'splash',
      routes: {
        'splash' : (_) => const SplashScreen(),
        'inicio' : (_) => const AccReg(),
        'acceder' : (_) => const Acceder(),
        'principal' : (_) => const Principal(),
        'registro': (_) => const Registro(),
        'predios_detalles': (_) => const DetallesPredios(),
        'predios' : (_) => const Predios(),
        'select_arbitrios': (_) => const SelectArbitrios(),
        'arbitrios_limpieza' :(_) => const ArbitriosLimpieza(),
        'limpieza_detalles' :(_) => const LimpiezaDetalles(),
        'arbitrios_seguridad' :(_) => const ArbitriosSeguridad(),
        'seguridad_detalles' :(_) => const SeguridadDetalles(),
        'viviendas' : (_) => const Viviendas(),
        'validar_dni':(_) => const ValidarDni(),
        'validar_cambio_password':(_) => const ValidarCambio()
      },
    ),
    )
    );

  }
}



    