import 'package:aplication_1/providers/ingresar_provider.dart';
import 'package:aplication_1/providers/predios_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DetallesPredios extends StatefulWidget {
  const DetallesPredios({Key? key}) : super(key: key);

  @override
  State<DetallesPredios> createState() => _DetallesPrediosState();
}

class _DetallesPrediosState extends State<DetallesPredios> {
  @override
  Widget build(BuildContext context) {
    final contrib = Provider.of<IngresarProvider>(context);
    final deudasProvider = Provider.of<PredioProvider>(context);

    final List<dynamic> listaDeudas = deudasProvider.listaDeudasDetalles;
    final List<dynamic> listaTotales = deudasProvider.totales;
    final String codigo = contrib.contribProvider;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          "Contribuyente: $codigo",
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
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
                  final total = listaTotales[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Monto total ${total['aini']}",
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "S/. ${total['total']}",
                              style: GoogleFonts.aclonica(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Título secciones
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: listaTotales.length,
                (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12.0),
                    child: Center(
                      child: Text(
                        "Detalles del Año ${listaTotales[index]['aini']}",
                        style: GoogleFonts.urbanist(
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

            // Detalles por trimestre
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: listaDeudas.length,
                (context, index) {
                  final detalle = listaDeudas[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Encabezado
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Periodo: ${detalle['peini']}-${detalle['aini']}",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueGrey[700],
                                  ),
                                ),
                                Text(
                                  "Trimestre ${detalle['nuevo_id']}",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueGrey[500],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Valores principales
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoColumn("Valor Insoluto",
                                    detalle['vdeuda']),
                                _buildInfoColumn(
                                    "D. Emisión", detalle['vderemi']),
                                _buildInfoColumn(
                                    "Sobretasas", detalle['sobretasas']),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Saldo actual destacado
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Saldo Actual",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey[800],
                                    ),
                                  ),
                                  Text(
                                    "S/. ${detalle['total']}",
                                    style: GoogleFonts.aclonica(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.aclonica(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
