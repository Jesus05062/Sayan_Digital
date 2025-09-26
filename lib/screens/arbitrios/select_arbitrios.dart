import 'package:aplication_1/config.dart';
import 'package:aplication_1/helpers/alert.dart';
import 'package:aplication_1/providers/limpieza_provider.dart';
import 'package:aplication_1/providers/ingresar_provider.dart';
import 'package:aplication_1/providers/predios_provider.dart';
import 'package:aplication_1/providers/seguridad_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectArbitrios extends StatefulWidget {
  const SelectArbitrios({super.key});

  @override
  State<SelectArbitrios> createState() => _SelectArbitriosState();
}

class _SelectArbitriosState extends State<SelectArbitrios> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final contrib = Provider.of<IngresarProvider>(context);

    final String codigo= contrib.contribProvider;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          iconSize: 40,
          color: Colors.black,
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              {Navigator.pushReplacementNamed(context, 'principal')},
        ),
      ),
        body: Center(
          child: Container(
              height: 600,
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Title(),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text('Consultando...'),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                      final limpiezaProvider =
                          Provider.of<ArbitriosProvider>(context, listen: false);

                          await limpiezaProvider.getArbitriosLimpieza(codigo);
                      
                      Navigator.of(context, rootNavigator: true).pop();

                      if (limpiezaProvider.arbitriosGlobalLimpieza.isEmpty) {
                              // ignore: use_build_context_synchronously
                              displayCustomAlert(
                                  context: context,
                                  icon: Icons.check_circle_outline,
                                  message: limpiezaProvider.message,
                                  color: Colors.green);
                          
                        } else {
                          Navigator.pushReplacementNamed(context, 'arbitrios_limpieza');
                        }
                       
                    },
                  
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: InterfaceColor.colorg,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 74,
                            width: 74,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/limpieza.jpg'),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'LIMPIEZA PÚBLICA',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text('Consultando...'),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                      final seguridadProvider =
                          Provider.of<SeguridadProvider>(context, listen: false);
                      
                      await seguridadProvider.getArbitriosSeguridad(codigo);

                      Navigator.of(context, rootNavigator: true).pop();
                      
                      if (seguridadProvider.arbitriosGlobalSeguridad.isEmpty) {
                              // ignore: use_build_context_synchronously
                              displayCustomAlert(
                                  context: context,
                                  icon: Icons.check_circle_outline,
                                  message: seguridadProvider.message,
                                  color: Colors.green);
                          
                        } else {
                            Navigator.pushReplacementNamed(context, 'arbitrios_seguridad');
                        }
                    },
                  
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 63, 53, 25),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 74,
                            width: 74,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/serenazgo.jpg'),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'SEGURIDAD CIUDADANA',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
        )
        );
  }
}

class Title extends StatelessWidget {
  //final UserProfileResponse userProfile;
  const Title({
    Key? key, //required this.userProfile
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ARBITRIOS MUNICIPALES',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: InterfaceColor.colorb),
              ),
              Container(
                height: 20,
              ),
              const Text(
                'Escoja el tipo de arbitrio',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

