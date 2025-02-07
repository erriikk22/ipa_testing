import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smile/home_screen.dart';
import 'package:smile/register_screen.dart';

void main() {
  runApp(const SmileApp());
}

class SmileApp extends StatefulWidget {
  const SmileApp({super.key});

  @override
  _SmileAppState createState() => _SmileAppState();
}

class _SmileAppState extends State<SmileApp> {
  bool isDarkMode = true;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: LoginScreen(isDarkMode: isDarkMode, toggleTheme: toggleTheme),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const LoginScreen({super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _checkLogin() {
    if (emailController.text == '1' && passwordController.text == '1') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HubScreen(isDarkMode: widget.isDarkMode)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid login credentials")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to Smile",
                style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: widget.isDarkMode ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 10),
              Text(
                "Sign in to continue",
                style: GoogleFonts.poppins(fontSize: 16, color: widget.isDarkMode ? Colors.white54 : Colors.black54),
              ),
              const SizedBox(height: 40),
              _buildTextField("Email", Icons.email_outlined, widget.isDarkMode, emailController),
              const SizedBox(height: 20),
              _buildTextField("Password", Icons.lock_outline, widget.isDarkMode, passwordController, isPassword: true),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _checkLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Center(
                  child: Text(
                    "Sign In",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.poppins(fontSize: 14, color: widget.isDarkMode ? Colors.white54 : Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(isDarkMode: widget.isDarkMode, toggleTheme: widget.toggleTheme),
                        ),
                      );
                    },
                    child: Text(
                      "Register",
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.blueAccent, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, IconData icon, bool isDarkMode, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: GoogleFonts.poppins(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: isDarkMode ? Colors.white54 : Colors.black54),
        prefixIcon: Icon(icon, color: isDarkMode ? Colors.white54 : Colors.black54),
        filled: true,
        fillColor: isDarkMode ? Colors.white10 : Colors.black12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
