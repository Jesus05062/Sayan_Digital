import 'package:aplication_1/config.dart';
import 'package:aplication_1/providers/ingresar_provider.dart';
import 'package:aplication_1/providers/predios_provider.dart';
import 'package:aplication_1/providers/seguridad_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ArbitriosSeguridad extends StatefulWidget {
  const ArbitriosSeguridad({super.key});

  @override
  State<ArbitriosSeguridad> createState() => _ArbitriosSeguridadState();
}

class _ArbitriosSeguridadState extends State<ArbitriosSeguridad> {
  @override
  Widget build(BuildContext context) {
    final contrib = Provider.of<IngresarProvider>(context);
    final predioProvider = Provider.of<PredioProvider>(context);
    final arbitriosProvider = Provider.of<SeguridadProvider>(context);

    final listaDeudas = arbitriosProvider.listaDeudasPorAniosSeguridad;
    final listaTotal = arbitriosProvider.totalSeguridad;
    final datos = predioProvider.datos;

    final global = arbitriosProvider.arbitriosGlobalSeguridad;
    final codigo = contrib.contribProvider;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, 'principal'),
        ),
        title: Text(
          'Arbitrios: Seguridad Ciudadana',
          style: GoogleFonts.urbanist(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 📌 Datos del contribuyente
                ...datos.map((item) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Código de Contribuyente"),
                            _buildValue(item['contrib']),
                            const SizedBox(height: 12),
                            _buildLabel("Apellidos y Nombres / Razón Social"),
                            _buildValue(
                              "${item['ap_paterno'].trim()} ${item['ap_materno'].trim()} ${item['nombres'].trim()}",
                            ),
                            const SizedBox(height: 12),
                            _buildLabel("Domicilio Fiscal"),
                            _buildValue(item['direcc'].trim()),
                          ],
                        ),
                      ),
                    )),

                // 📌 Totales
                ...listaTotal.map((t) {
                  final estado = t['id'];
                  final esFraccionado = (estado == 'F');
                  return Card(
                    color: esFraccionado ? Colors.grey[200] : Colors.blue[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            esFraccionado
                                ? "Monto Fraccionados:"
                                : "Monto Deudas:",
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            "S/. ${t['total']}",
                            style: GoogleFonts.urbanist(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                // 📌 Total General
                Card(
                  color: Colors.blueGrey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "TOTAL A PAGAR:",
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "S/. $global",
                          style: GoogleFonts.urbanist(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 📌 Resumen por año (título)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_downward_sharp,
                          color: Colors.blueGrey, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        "Resumen por Año",
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[900],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_downward_sharp,
                          color: Colors.blueGrey, size: 24),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 📌 Leyenda
                Card(
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      children: [
                        Text(
                          "Leyenda",
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildLegendItem(
                                "Deudas", const Color.fromARGB(255, 95, 183, 255)),
                            _buildLegendItem("Fraccionado", Colors.grey),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 📌 Lista de deudas por año
                ...listaDeudas.map((deuda) {
                  final estado = deuda['id'];
                  final cantidad = deuda['cantidad'];
                  final esFraccionado = (estado == 'F');

                  return GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                      final deudasProvider =
                          Provider.of<SeguridadProvider>(context, listen: false);
                      await deudasProvider.arbitriosSeguridadDetalles(
                          codigo, deuda['aini']);
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.pushNamed(context, 'seguridad_detalles');
                    },
                    child: Card(
                      color: esFraccionado ? Colors.grey[100] : Colors.blue[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildResumenItem("Año", deuda['aini']),
                            _buildResumenItem(
                                cantidad != '4' ? "Meses" : "Trimestres",
                                cantidad),
                            _buildResumenItem("Deuda", "S/. ${deuda['total']}"),
                            const Icon(Icons.arrow_forward_ios,
                                color: Colors.blueGrey, size: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.blueGrey[700],
      ),
    );
  }

  Widget _buildValue(String text) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey[900],
      ),
    );
  }

  Widget _buildResumenItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[900],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 12,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey[800],
          ),
        ),
      ],
    );
  }
}
