// ignore_for_file: use_build_context_synchronously

import 'package:aplication_1/config.dart';
import 'package:aplication_1/helpers/alert.dart';
import 'package:aplication_1/providers/cambiar_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class ValidarDni extends StatefulWidget {
  const ValidarDni({super.key});

  @override
  State<ValidarDni> createState() => _ValidarDniState();
}

class _ValidarDniState extends State<ValidarDni> {
  var dniMask = MaskTextInputFormatter(
      mask: '###########', filter: {"#": RegExp(r'[0-9]')});

  final _formKey = GlobalKey<FormState>();

  final txtDni = TextEditingController();

  String dni = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.black,
          iconSize: 40,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => {Navigator.of(context).pop()},
        ),
      ),
      body: SingleChildScrollView(
        child: Align(
          child: Container(
            color: const Color.fromARGB(226, 248, 199, 53),
            height: 700,
            width: 400,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 400,
                    height: 170,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/intro.jpg'))),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Restablecer Contraseña',
                      style: GoogleFonts.aclonica(
                          textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Color.fromRGBO(0, 41, 107, 1),
                      ))),
                  Text(
                    'Se le enviará un código al correo',
                    style: GoogleFonts.akshar(
                        textStyle: const TextStyle(
                      fontSize: 20,
                    )),
                  ),
                  Align(
                    child: Container(
                      width: 100,
                      alignment: Alignment.centerLeft,
                      margin:
                          const EdgeInsets.only(left: 10, top: 20, bottom: 20),
                      child: Text(
                        'DNI / RUC :',
                        style: GoogleFonts.urbanist(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromRGBO(0, 41, 107, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 240,
                    child: TextFormField(
                      inputFormatters: [dniMask],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(232, 236, 244, 1),
                            ),
                            borderRadius: BorderRadius.circular(5.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(232, 236, 244, 1),
                            ),
                            borderRadius: BorderRadius.circular(5.5),
                          ), // Outline Input Border
                          hintText: '########',
                          hintStyle: GoogleFonts.urbanist(
                            textStyle: const TextStyle(
                              color: Color.fromRGBO(131, 145, 161, 1),
                            ),
                          ),
                          filled: true,
                          fillColor: Color.fromRGBO(247, 248, 249, 1)),
                      controller: txtDni,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese su DNI/RUC';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: 55,
                    margin: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          dni = txtDni.text;
                          /* Navigator.pushReplacementNamed(
                                context, 'validar_cambio_password'); */
                          final cambioPaswordProvider =
                              Provider.of<CambiarPasswordProvider>(context,
                                  listen: false);
                          final response =
                              await cambioPaswordProvider.enviarCodigo(dni);

                          if (response == 'exitoso') {
                            print(response);
                            Navigator.pushReplacementNamed(
                                context, 'validar_cambio_password');
                          } else if (response == 'no exitoso') {
                            print(response);

                            displayCustomAlert(
                                title: 'ALERTA',
                                context: context,
                                icon: cambioPaswordProvider.icon,
                                message: cambioPaswordProvider.message,
                                color: cambioPaswordProvider.color);

                            // Retraso de 6 segundos
                            Future.delayed(const Duration(seconds: 10), () {
                              Navigator.pop(context);
                            });
                          } else {

                            return displayCustomAlert(
                                context: context,
                                icon: cambioPaswordProvider.icon,
                                message: cambioPaswordProvider.message,
                                color: cambioPaswordProvider.color);
                          }
                        }
                      },
                      child: Text(
                        'Enviar Código',
                        style: GoogleFonts.urbanist(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                              letterSpacing: 4),
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            InterfaceColor.colorg,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
