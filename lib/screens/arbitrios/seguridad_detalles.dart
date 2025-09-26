import 'package:aplication_1/providers/ingresar_provider.dart';
import 'package:aplication_1/providers/seguridad_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SeguridadDetalles extends StatefulWidget {
  const SeguridadDetalles({super.key});

  @override
  State<SeguridadDetalles> createState() => _SeguridadDetallesState();
}

class _SeguridadDetallesState extends State<SeguridadDetalles> {
  @override
  Widget build(BuildContext context) {
    final seguridadProvider = Provider.of<SeguridadProvider>(context);
    final List<dynamic> listadeudas =
        seguridadProvider.listaDeudasDetallesSeguridad;
    final List<dynamic> listaTotales = seguridadProvider.totalesSeguridad;

    final contrib = Provider.of<IngresarProvider>(context);
    final String codigo = contrib.contribProvider;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Usuario: $codigo",
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey[800],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 28, color: Colors.white),
          onPressed: () {
            final deudasProvider =
                Provider.of<SeguridadProvider>(context, listen: false);
            deudasProvider.getArbitriosSeguridad(codigo);
            Navigator.pushReplacementNamed(context, 'arbitrios_seguridad');
          },
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: CustomScrollView(
          slivers: [
            // Totales
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: listaTotales.length,
                (context, index) {
                  return Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Monto total ${listaTotales[index]['aini']}",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "S/. ${listaTotales[index]['total']}",
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Subtítulo
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: listaTotales.length,
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        "Detalles del año ${listaTotales[index]['aini']}",
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Lista de deudas
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: listadeudas.length,
                (context, index) {
                  final detalles = listadeudas[index];

                  return Card(
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cabecera
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Periodo Tributario",
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${detalles['nuevo_id']}",
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[800]),
                                  ),
                                  Text(
                                    "Mes: ${detalles['peini']}-${detalles['aini']}",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey[900],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: 24, thickness: 1),

                          // Valores principales
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoColumn("Valor Insoluto", detalles['vdeuda']),
                              _buildInfoColumn("D. Emisión", detalles['vderemi']),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInfoColumn("Sobretasas", detalles['sobretasas']),

                          const Divider(height: 24, thickness: 1),

                          // Saldo
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Saldo Actual",
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[700],
                                ),
                              ),
                              Text(
                                detalles['total'],
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[900],
          ),
        ),
      ],
    );
  }
}
