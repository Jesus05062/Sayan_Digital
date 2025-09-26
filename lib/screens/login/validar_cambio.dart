// ignore_for_file: use_build_context_synchronously

import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:aplication_1/config.dart';
import 'package:aplication_1/helpers/alert.dart';
import 'package:aplication_1/providers/cambiar_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class ValidarCambio extends StatefulWidget {
  const ValidarCambio({super.key});

  @override
  State<ValidarCambio> createState() => _ValidarCambioState();
}

class _ValidarCambioState extends State<ValidarCambio> {
  var dniMask = MaskTextInputFormatter(
      mask: '###########', filter: {"#": RegExp(r'[0-9]')});

  var codigoMask = MaskTextInputFormatter(
      mask: '######', filter: {"#": RegExp(r'[A-Za-z0-9]')});

  final _formKey = GlobalKey<FormState>();

  final txtContra = TextEditingController();
  final txtDni = TextEditingController();
  final txtCodigo = TextEditingController();

  bool _isVisible = true;
  String dni = '';
  String password = '';
  String codigo = '';

  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;

  void limpiarCampos() {
    txtDni.clear();
    txtContra.clear();
    txtCodigo.clear();
  }

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8) _isPasswordEightCharacters = true;

      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) _hasPasswordOneNumber = true;
    });
  }

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
          onPressed: () => {Navigator.pushNamed(context, 'validar_dni')},
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Align(
          child: Container(
            color: const Color.fromARGB(226, 248, 199, 53),
            width: 420,
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
                    'Revise su bandeja de "Recibidos" o "Spam"',
                    style: GoogleFonts.akshar(
                        textStyle: TextStyle(
                      fontSize: 20,
                    )),
                  ),
                  Align(
                    child: Container(
                      width: 100,
                      alignment: Alignment.centerLeft,
                      margin:
                          const EdgeInsets.only(left: 10, top: 20, bottom: 5),
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
                  const SizedBox(),
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
                  Align(
                    child: Container(
                      width: 200,
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 10, top: 20),
                      child: Text(
                        'Nueva contraseña :',
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
                    height: 20,
                  ),
                  SizedBox(
                    width: 280,
                    child: TextFormField(
                      obscureText: _isVisible,
                      onChanged: (password) => onPasswordChanged(password),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(232, 236, 244, 1),
                            ),
                            borderRadius: BorderRadius.circular(5.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(232, 236, 244, 1),
                            ),
                            borderRadius: BorderRadius.circular(5.5),
                          ), // Outline Input Border
                          labelText: "Contraseña",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isVisible = !_isVisible;
                              });
                            },
                            icon: _isVisible
                                ? Icon(
                                    Icons.visibility_off,
                                    color: Color.fromARGB(255, 117, 117, 117),
                                  )
                                : Icon(
                                    Icons.visibility,
                                    color: Colors.grey,
                                  ),
                          ),
                          labelStyle: GoogleFonts.urbanist(
                            textStyle: TextStyle(
                              color: Color.fromRGBO(131, 145, 161, 1),
                            ),
                          ),
                          filled: true,
                          fillColor: Color.fromRGBO(247, 248, 249, 1)),
                      controller: txtContra,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor Ingrese su contraseña';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: 300,
                    margin: const EdgeInsets.only(left: 60, right: 20),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: _isPasswordEightCharacters
                                  ? Colors.green
                                  : Colors.transparent,
                              border: _isPasswordEightCharacters
                                  ? Border.all(color: Colors.transparent)
                                  : Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(50)),
                          child: const Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Contiene al menos 8 caracteres")
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 70, right: 20),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: _hasPasswordOneNumber
                                  ? Colors.green
                                  : Colors.transparent,
                              border: _hasPasswordOneNumber
                                  ? Border.all(color: Colors.transparent)
                                  : Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(50)),
                          child: const Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Contiene al menos 1 número")
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          child: Text('Validar Código :',
                              style: GoogleFonts.urbanist(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color.fromRGBO(0, 41, 107, 1),
                                ),
                              ))),
                      CountdownTimer(
                        endTime: DateTime.now().millisecondsSinceEpoch +
                            180000, // 3 minutos (3 * 60 * 1000)
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        onEnd: () {
                          // Manejar la lógica cuando se complete el tiempo
                          displayTimeOut(
                              context: context,
                              icon: Icons.timer_off_outlined,
                              message: 'El tiempo se agotó, intentelo de nuevo',
                              color: Colors.red);
                        },
                      ),
                      SizedBox(
                        width: 110,
                        child: TextFormField(
                          inputFormatters: [codigoMask],
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
                              hintText: '_ _ _ _ _ _',
                              hintStyle: GoogleFonts.urbanist(
                                textStyle: const TextStyle(
                                  color: Color.fromRGBO(131, 145, 161, 1),
                                ),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(247, 248, 249, 1)),
                          controller: txtCodigo,
                          onChanged: (value) {
                            final upperCaseValue = value.toUpperCase();
                            txtCodigo.value = txtCodigo.value.copyWith(
                              text: upperCaseValue,
                              selection: TextSelection(
                                baseOffset: upperCaseValue.length,
                                extentOffset: upperCaseValue.length,
                              ),
                              composing: TextRange.empty,
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese el codigo verificador';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 55,
                    margin: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          dni = txtDni.text;
                          password = txtContra.text;
                          codigo = txtCodigo.text;

                          final cambioPaswordProvider =
                              Provider.of<CambiarPasswordProvider>(context,
                                  listen: false);

                          final response =
                              await cambioPaswordProvider.CambiarPassword(
                                  dni, password, codigo);

                          if (response == 'exitoso') {
                            limpiarCampos();
                            displayCustomAlert(
                                context: context,
                                icon: cambioPaswordProvider.icon,
                                message: cambioPaswordProvider.message,
                                color: cambioPaswordProvider.color);



                            
                          } else if (response == 'no exitoso') {
                            return displayCustomAlert(
                                context: context,
                                icon: cambioPaswordProvider.icon,
                                message: cambioPaswordProvider.message,
                                color: cambioPaswordProvider.color);
                          } else {
                            return displaySuccess(
                                context: context,
                                icon: cambioPaswordProvider.icon,
                                message: cambioPaswordProvider.message,
                                color: cambioPaswordProvider.color);
                          }
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            InterfaceColor.colorg,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ))),
                      child: Text(
                        'Validar',
                        style: GoogleFonts.urbanist(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                              letterSpacing: 4),
                        ),
                      ),
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
