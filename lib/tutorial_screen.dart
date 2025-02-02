import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart'; // Importa el archivo home_screen.dart

class TutorialScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const TutorialScreen({super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? const Color.fromARGB(255, 22, 22, 22) : Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                _buildTutorialPage(
                  title: "Welcome to Smile!",
                  description:
                      "Smile is a platform designed to help you connect with others, share moments, and enjoy a better social experience. Join us today!",
                  image: "assets/tutorial1.png",
                ),
                _buildTutorialPage(
                  title: "Smile Tasks",
                  description:
                      "With Smile Tasks, you can manage your daily activities, set reminders, and stay organized. It's the perfect way to keep track of everything you need to do efficiently.",
                  image: "assets/tutorial2.png",
                ),
                _buildTutorialPage(
                  title: "Smile Calendar",
                  description:
                      "Smile Calendar lets you schedule events, meetings, and social gatherings. It's your personal assistant, helping you manage your time effectively and stay on top of your schedule.",
                  image: "assets/tutorial3.png",
                ),
                _buildTutorialPage(
                  title: "Smile Marketplace",
                  description:
                      "Explore Smile Marketplace to buy and sell items, discover new products, and engage in community-based trade. It's a safe space to connect with others and find what you need.",
                  image: "assets/tutorial4.png",
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          _buildPageIndicators(),
          SizedBox(height: 20),
          if (currentPage == 3)
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HubScreen(isDarkMode: widget.isDarkMode)), // Reemplaza con tu pantalla de inicio
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: Text("Comenzar!"),
            ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTutorialPage({required String title, required String description, required String image}) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(image, height: 250, width: 250),
          const SizedBox(height: 40),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: widget.isDarkMode ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 8),
                height: 10,
                width: currentPage == index ? 20 : 10,
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? Colors.blueAccent
                      : widget.isDarkMode
                          ? Colors.white30
                          : Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 10),
        Text(
          "Presiona cada uno para pasar",
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white70 : Colors.black87,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
