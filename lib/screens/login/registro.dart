// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:aplication_1/providers/registro_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../helpers/alert.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  var dniMask = MaskTextInputFormatter(
      mask: '###########', filter: {"#": RegExp(r'[0-9]')});

  final _formKey = GlobalKey<FormState>();
  bool obscuretext = true;
  bool _isVisible = true;
  final txtDni = TextEditingController();
  final txtCorreo = TextEditingController();
  final txtContra = TextEditingController();
  final txtConfirContra = TextEditingController();

  String dni = '';
  String email = '';
  String password = '';

  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;

  void limpiarCampos() {
    txtDni.clear();
    txtContra.clear();
    txtConfirContra.clear();
    txtCorreo.clear();
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
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => {Navigator.of(context).pop()},
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(20.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '¡Hola! Registrese para comenzar',
                      style: GoogleFonts.urbanist(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color.fromRGBO(0, 41, 107, 1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Align(
                    child: Container(
                      width: 180,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                      child: Text(
                        'Correo Electrónico :',
                        style: GoogleFonts.urbanist(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromRGBO(0, 41, 107, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 240,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
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
                          hintText: 'ejemplo@gmail.com',
                          hintStyle: GoogleFonts.urbanist(
                            textStyle: TextStyle(
                              color: Color.fromRGBO(131, 145, 161, 1),
                            ),
                          ),
                          filled: true,
                          fillColor: Color.fromRGBO(247, 248, 249, 1)),
                      controller: txtCorreo,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese su correo';
                        }
                      },
                    ),
                  ),
                  Align(
                    child: Container(
                      width: 100,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                      child: Text(
                        'DNI / RUC :',
                        style: GoogleFonts.urbanist(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromRGBO(0, 41, 107, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 240,
                    child: TextFormField(
                      inputFormatters: [dniMask],
                      keyboardType: TextInputType.number,
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
                          hintText: '########',
                          hintStyle: GoogleFonts.urbanist(
                            textStyle: TextStyle(
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
                  Center(
                    child: Container(
                      width: 250,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        left: 10,
                        top: 30,
                      ),
                      child: Text(
                        'Genere su Clave Web :',
                        style: GoogleFonts.urbanist(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromRGBO(0, 41, 107, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
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
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
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
                        child: Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Contiene al menos 8 caracteres")
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
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
                        child: Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Contiene al menos 1 número")
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    decoration: _inputDecoration("Verificar contraseña"),
                    controller: txtConfirContra,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor confirme su contraseña';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                        child: Text(
                          'Registrar',
                          style: GoogleFonts.urbanist(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white,
                                letterSpacing: 1),
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF00296B),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ))),
                        onPressed: () async {
                          final bool isValid =
                              EmailValidator.validate(txtCorreo.text.trim());

                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Validando...')));
                            if (txtContra.text != txtConfirContra.text ||
                                txtContra.text.length < 8) {
                              return displayCustomAlert(
                                  context: context,
                                  icon: Icons.sentiment_dissatisfied,
                                  message: 'Verifique la contraseña',
                                  color: Colors.yellow[700]!);
                            }
                            if (isValid == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Validando correo')));
                              dni = txtDni.text;
                              email = txtCorreo.text;
                              password = txtContra.text;
                              final registroProvider =
                                  Provider.of<RegistroProvider>(context,
                                      listen: false);
                              final response = await registroProvider.registrar(
                                  email, password, dni);
                              if (response == 'Registro exitoso') {
                                limpiarCampos(); // Ejecutar el método limpiarCampos() aquí
                                return displayCustomAlert(
                                    context: context,
                                    icon: registroProvider.icon,
                                    message: registroProvider.message,
                                    color: registroProvider.color);
                              }else if(response=='no exitoso'){
                                return displayCustomAlert(
                                    context: context,
                                    icon: registroProvider.icon,
                                    message: registroProvider.message,
                                    color: registroProvider.color);
                              }else{
                                return displayCustomAlert(
                                    context: context,
                                    icon: registroProvider.icon,
                                    message: registroProvider.message,
                                    color: registroProvider.color);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Ingrese un correo valido')));
                            }
                          }
                        }),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
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
        labelText: labelText,
        labelStyle: GoogleFonts.urbanist(
          textStyle: TextStyle(
            color: Color.fromRGBO(131, 145, 161, 1),
          ),
        ),
        filled: true,
        fillColor: Color.fromRGBO(247, 248, 249, 1));
  }
}



/*ALERTA */


