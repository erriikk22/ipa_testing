import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smile/upgradeplanpage.dart';
import 'package:smile/smile_task_page.dart';
import 'package:smile/smile_calendar_page.dart';
import 'package:smile/smile_market_page.dart';


class HubScreen extends StatelessWidget {
  final bool isDarkMode;

  const HubScreen({super.key, required this.isDarkMode});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Buenos días';
    } else if (hour < 18) {
      return 'Buenas tardes';
    } else {
      return 'Buenas noches';
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode ? const Color.fromARGB(255, 197, 197, 197) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2),
            Text(
              _getGreeting(),
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
            icon: Text(
              'Mejorar plan',
              style: GoogleFonts.poppins(color: Colors.black),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpgradePlanPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Acción de ajustes
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildHubCard(
                context,
                title: "Smile Task",
                icon: Icons.check_circle,
                onTap: () {
                  // Redirige a la página de Smile Task
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SmileTaskPage()),
                  );
                },
              ),
              SizedBox(height: 10),
              _buildHubCard(
                context,
                title: "Smile Calendar",
                icon: Icons.calendar_today,
                onTap: () {
                  // Redirige a la página de Smile Calendar
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SmileCalendarPage()),
                  );
                },
              ),
              SizedBox(height: 10),
              _buildHubCard(
                context,
                title: "Smile Market",
                icon: Icons.storefront,
                onTap: () {
                  // Redirige a la página de Smile Market
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SmileMarketPage()),
                  );
                },
              ),
              SizedBox(height: 20),
              _buildRecommendationsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHubCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Function() onTap,
  }) {
    final backgroundColor = isDarkMode ? const Color.fromARGB(255, 212, 207, 207) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              onTap: onTap,
              splashColor: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16.0),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(icon, size: 30, color: Colors.black),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recomendaciones recientes',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12),
        _buildRecommendationItem(
          "Tarea completada: 'Recoger suministros'",
          "Asegúrate de completar esta tarea para avanzar al siguiente nivel.",
        ),
        _buildRecommendationItem(
          "Nuevo evento en el calendario",
          "Revisa tu calendario para ver el próximo evento importante.",
        ),
        _buildRecommendationItem(
          "Nuevo producto en Smile Market",
          "¡No te pierdas los últimos artículos disponibles en el mercado!",
        ),
      ],
    );
  }

  Widget _buildRecommendationItem(String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 13),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[350] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 6),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

