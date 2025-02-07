import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smile/smile_market_page.dart';
import 'package:smile/upgradeplanpage.dart';
import 'package:smile/smile_calendar_page.dart' as calenadrPage;
import 'package:smile/smile_task_page.dart' as taskPage;
import 'package:smile/smile_calendar_page.dart' as calendarPage;


class HubScreen extends StatefulWidget {
  final bool isDarkMode;

  const HubScreen({super.key, required this.isDarkMode});

  @override
  _HubScreenState createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  List<String> recentActions = [];

  @override
  void initState() {
    super.initState();
    _loadRecentActions();
  }

  Future<void> _loadRecentActions() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentActions = prefs.getStringList('recent_actions') ?? [];
    });
  }

  Future<void> addRecentAction(String action) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> updatedActions = [action, ...recentActions];
    if (updatedActions.length > 5) updatedActions.removeLast(); // Máximo 5 acciones recientes
    await prefs.setStringList('recent_actions', updatedActions);
    setState(() {
      recentActions = updatedActions;
    });
  }

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
    final backgroundColor = widget.isDarkMode ? const Color.fromARGB(255, 197, 197, 197) : Colors.white;

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
                  addRecentAction("Abriste Smile Task");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => taskPage.SmileTaskPage()),
                  );
                },
              ),
              SizedBox(height: 10),
              _buildHubCard(
                context,
                title: "Smile Calendar",
                icon: Icons.calendar_today,
                onTap: () {
                  addRecentAction("Revisaste Smile Calendar");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => calendarPage.SmileCalendarPage()),
                  );
                },
              ),
              SizedBox(height: 10),
              _buildHubCard(
                context,
                title: "Smile Market",
                icon: Icons.storefront,
                onTap: () {
                  addRecentAction("Exploraste Smile Market");
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
    final backgroundColor = widget.isDarkMode ? const Color.fromARGB(255, 212, 207, 207) : Colors.white;

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
          'Cosas recientes:',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12),
        if (recentActions.isEmpty)
          Text(
            "No hay acciones recientes.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ...recentActions.map((action) => _buildRecommendationItem(action)).toList(),
      ],
    );
  }

  Widget _buildRecommendationItem(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 13),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.grey[350] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}
