import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpgradePlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Mejorar Plan',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPlanCard(
              'Plan Básico',
              '2.99',
              'Acceso limitado a funciones básicas',
              ['Acceso a funciones A', 'Acceso limitado a contenidos', 'Soporte básico'],
              context,
            ),
            SizedBox(height: 16),
            _buildPlanCard(
              'Plan Avanzado',
              '5.99',
              'Acceso completo',
              ['Acceso a todas las funciones', 'Contenido exclusivo', 'Soporte prioritario'],
              context,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(String title, String price, String description, List<String> advantages, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Acción de compra (aquí puedes integrar la lógica de compra)
      },
      child: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,  // Usar el ancho máximo disponible
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\$$price',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 12),
            Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 16),
            // Column para las ventajas, envuelta en un SingleChildScrollView para evitar overflow
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: advantages.map((advantage) {
                  return Row(
                    children: [
                      Icon(Icons.check, size: 18, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        advantage,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Lógica para proceder con la compra
              },
              child: Text('Comprar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
