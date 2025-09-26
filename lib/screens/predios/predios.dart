import 'package:aplication_1/providers/ingresar_provider.dart';
import 'package:aplication_1/providers/predios_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Predios extends StatelessWidget {
  const Predios({super.key});

  @override
  Widget build(BuildContext context) {
    final contrib = Provider.of<IngresarProvider>(context);
    final predioProvider = Provider.of<PredioProvider>(context);

    final listaDeudasPorAnios = predioProvider.listaDeudasPorAnios;
    final listaTotal = predioProvider.total;
    final datos = predioProvider.datos;
    final global = predioProvider.predioGlobal;
    final codigo = contrib.contribProvider;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey.shade800,
        centerTitle: true,
        title: Text(
          "Impuestos Prediales",
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.blueGrey.shade800,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, 'principal'),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth > 600 ? 700 : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información del contribuyente
                  ...datos.map((data) => _buildContribCard(data)).toList(),
                  const SizedBox(height: 20),

                  // Resumen de deudas / fraccionados
                  ...listaTotal.map((item) => _buildResumenCard(item)).toList(),
                  const SizedBox(height: 16),

                  // Total
                  _buildTotalCard(global),
                  const SizedBox(height: 32),

                  // Título de resumen por año
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_downward, color: Colors.blueGrey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        "Resumen por Año",
                        style: GoogleFonts.urbanist(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_downward, color: Colors.blueGrey.shade600),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Leyenda
                  _buildLegend(),
                  const SizedBox(height: 20),

                  // Lista de deudas por año
                  ...listaDeudasPorAnios.map(
                    (anio) => _buildAnioCard(context, anio, codigo),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContribCard(Map<String, dynamic> data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItem("Código de Contribuyente", data['contrib']),
            const SizedBox(height: 12),
            _buildItem(
              "Apellidos y Nombres / Razón Social",
              "${data['ap_paterno'].trim()} ${data['ap_materno'].trim()} ${data['nombres'].trim()}",
            ),
            const SizedBox(height: 12),
            _buildItem("Domicilio Fiscal", data['direcc'].trim()),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade900,
          ),
        ),
      ],
    );
  }

  Widget _buildResumenCard(Map<String, dynamic> item) {
    final isFraccionado = item['id'] == 'F';
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(
          isFraccionado ? "Monto Fraccionados" : "Monto Deudas",
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade700,
          ),
        ),
        trailing: Text(
          "S/. ${item['total']}",
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blueGrey.shade900,
          ),
        ),
      ),
    );
  }

  Widget _buildTotalCard(String global) {
    return Card(
      color: Colors.blueGrey.shade800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          "TOTAL A PAGAR",
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        trailing: Text(
          "S/. $global",
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Leyenda",
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem("Deudas", Colors.blue.shade200),
                _buildLegendItem("Fraccionado", Colors.grey.shade400),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.urbanist(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildAnioCard(BuildContext context, Map<String, dynamic> anio, String codigo) {
    final isFraccionado = anio['id'] == 'F';
    final bgColor = isFraccionado ? Colors.grey.shade300 : Colors.blue.shade100;

    return Card(
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        title: Text(
          "Año ${anio['aini']}",
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade800,
          ),
        ),
        subtitle: Text(
          "Trimestres: ${anio['cantidad']}  •  Deuda: S/. ${anio['total']}",
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: Colors.blueGrey.shade600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 20),
        onTap: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );

          final deudasProvider = Provider.of<PredioProvider>(context, listen: false);
          await deudasProvider.prediosDetalles(codigo, anio['aini']);
          Navigator.of(context, rootNavigator: true).pop();

          Navigator.pushNamed(context, 'predios_detalles');
        },
      ),
    );
  }
}
