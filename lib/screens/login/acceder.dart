import 'package:aplication_1/helpers/alert.dart';
import 'package:aplication_1/providers/ingresar_provider.dart';
import 'package:aplication_1/widgets/custom_background.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';


class Acceder extends StatefulWidget {
  const Acceder({super.key});

  @override
  State<Acceder> createState() => _AccederState();
}

class _AccederState extends State<Acceder> {
  var dniMask =
      MaskTextInputFormatter(mask: '###########', filter: {"#": RegExp(r'[0-9]')});

  final _formKey = GlobalKey<FormState>();
  final txtDni = TextEditingController();
  final txtClaveWeb = TextEditingController();

  //para la animación del botón
  bool _isVisible = true;
  bool _isPressed = false;

  String dni = '';
  String claveWeb = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pushNamed(context, 'inicio'),
        ),
      ),
      body: CustomBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.08,
              vertical: size.height * 0.02,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'SAYAN DIGITAL',
                      style: GoogleFonts.urbanist(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Color(0xFF00296B), // azul corporativo
                          
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Logo Muni
                    Image.asset(
                      "images/SayanDigital.png",
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 150),

                    // Campo DNI
                    TextFormField(
                      controller: txtDni,
                      inputFormatters: [dniMask],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Número de DNI/RUC',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su documento';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Campo Clave Web
                    TextFormField(
                      controller: txtClaveWeb,
                      obscureText: _isVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: "Clave Web",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isVisible ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su Clave Web';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Botón acceder con animación
                    GestureDetector(
                      onTapDown: (_) => setState(() => _isPressed = true),
                      onTapUp: (_) => setState(() => _isPressed = false),
                      onTapCancel: () => setState(() => _isPressed = false),
                      child: AnimatedScale(
                        scale: _isPressed ? 0.95 : 1.0,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                        child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E3A5F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 4,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                dni = txtDni.text;
                                claveWeb = txtClaveWeb.text;

                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                                 
                                final ingresarProvider =
                                    Provider.of<IngresarProvider>(context,
                                        listen: false);

                                await ingresarProvider.ingresar(dni, claveWeb);

                                if (!mounted) return;
                                Navigator.of(context, rootNavigator: true).pop();
                               
                                if (ingresarProvider.contribProvider.isNotEmpty) {
                                  if (ingresarProvider.datos.length > 1) {
                                    Navigator.pushReplacementNamed(
                                        context, 'viviendas');
                                  } else {
                                    Navigator.pushReplacementNamed(
                                        context, 'principal');
                                  }
                                } else {
                                  displayCustomAlert(
                                    title: 'ALERTA',
                                    context: context,
                                   icon: Icons.crisis_alert,
                                    message: ingresarProvider.message,
                                    color: Colors.red,
                                 );
                                }
                              }
                            },
                            child: const Text(
                              'Acceder',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Link Registrarse
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿No tienes tu Clave Web? ',
                          style: GoogleFonts.urbanist(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6A707C),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, 'registro'),
                          child: Text(
                            'Registrarse',
                            style: GoogleFonts.urbanist(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00296B),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Link Olvidé contraseña
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, 'validar_dni'),
                      child: Text(
                        'Olvidé mi contraseña',
                        style: GoogleFonts.urbanist(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00296B),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
