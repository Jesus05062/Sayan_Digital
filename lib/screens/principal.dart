import 'package:aplication_1/config.dart';
import 'package:aplication_1/helpers/alert.dart';
import 'package:aplication_1/providers/ingresar_provider.dart';
import 'package:aplication_1/providers/predios_provider.dart';
import 'package:aplication_1/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> with TickerProviderStateMixin {
  bool _isExpanded = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // <-- IMPORTANTE para evitar memory leaks
    super.dispose();
  }

  void _toggleProfile() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }
  @override
  Widget build(BuildContext context) {
    final contrib = Provider.of<IngresarProvider>(context);
    final predioProvider = Provider.of<PredioProvider>(context);
    final String codigo = contrib.contribProvider;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyMenu(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menú hamburguesa
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black87, size: 30),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
            const TitleSection(),
            const SizedBox(height: 20),
            // Opciones
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  _OptionCard(
                    title: "Predios",
                    imagePath: "images/predios.jpg",
                    onTap: () async {
                      _showLoading(context, "Consultando...");
                      await predioProvider.getPredios(codigo);
                      Navigator.of(context, rootNavigator: true).pop();

                      if (predioProvider.predioGlobal.isEmpty) {
                        displayCustomAlert(
                          context: context,
                          icon: Icons.info_outline,
                          message: predioProvider.message,
                          color: Colors.blueGrey,
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, 'predios');
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  _OptionCard(
                    title: "Arbitrios",
                    imagePath: "images/arbitrios.jpg",
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'select_arbitrios');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showLoading(context, "Cargando perfil...");
          await predioProvider.getDatos(codigo);
          Navigator.of(context, rootNavigator: true).pop();
          _toggleProfile();
        },
        backgroundColor: Colors.blueGrey.shade800,
        child: const Icon(Icons.person, size: 28),
      ),
      bottomSheet: SizeTransition(
        sizeFactor: _animation,
        axisAlignment: -1.0,
        child: _isExpanded ? _buildBottomSheet(predioProvider.datos) : const SizedBox(),
      ),
    );
  }

  Widget _buildBottomSheet(List<dynamic> datos) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ListView.builder(
        itemCount: datos.length,
        itemBuilder: (context, index) {
          final data = datos[index];
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Perfil",
                    style: GoogleFonts.urbanist(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                    ),
                  ),
                ),
                const Divider(height: 30, thickness: 1),
                _ProfileItem(
                  label: "Código de Contribuyente",
                  value: data['contrib'],
                ),
                _ProfileItem(
                  label: "Apellidos y Nombres / Razón Social",
                  value:
                      "${data['ap_paterno'].trim()} ${data['ap_materno'].trim()} ${data['nombres'].trim()}",
                ),
                _ProfileItem(
                  label: "Domicilio Fiscal",
                  value: data['direcc'].trim(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLoading(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "¡Bienvenido!",
            style: GoogleFonts.urbanist(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "¿Qué consulta deseas realizar?",
            style: GoogleFonts.urbanist(fontSize: 18, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.asset(
                imagePath,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: GoogleFonts.urbanist(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
