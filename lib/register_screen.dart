import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tutorial_screen.dart';  // Asegúrate de importar tu pantalla de tutorial

class RegisterScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  // Constructor para recibir los parámetros
  const RegisterScreen({super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  // Para mostrar mensajes de error si los campos están vacíos
  String _emailError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Register to Smile",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                    onPressed: widget.toggleTheme, // Cambia el tema en tiempo real
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Create an account to get started",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: widget.isDarkMode ? Colors.white54 : Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField("Email", Icons.email_outlined, widget.isDarkMode, controller: _emailController, errorText: _emailError),
              const SizedBox(height: 20),
              _buildTextField("Password", Icons.lock_outline, widget.isDarkMode, controller: _passwordController, isPassword: true, errorText: _passwordError),
              const SizedBox(height: 20),
              _buildTextField("Confirm Password", Icons.lock_outline, widget.isDarkMode, controller: _confirmPasswordController, isPassword: true, errorText: _confirmPasswordError),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Validar los campos
                  setState(() {
                    _emailError = _emailController.text.isEmpty ? 'Email cannot be empty' : '';
                    _passwordError = _passwordController.text.isEmpty ? 'Password cannot be empty' : '';
                    _confirmPasswordError = _confirmPasswordController.text.isEmpty
                        ? 'Please confirm your password'
                        : (_passwordController.text != _confirmPasswordController.text ? 'Passwords do not match' : '');
                  });

                  // Si no hay errores, navega al TutorialScreen
                  if (_emailError.isEmpty && _passwordError.isEmpty && _confirmPasswordError.isEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
    builder: (context) => TutorialScreen(
      isDarkMode: widget.isDarkMode,
      toggleTheme: widget.toggleTheme, 
      ),// Pass the toggleTheme function here
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Center(
                  child: Text(
                    "Register",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: widget.isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildTextField(String hintText, IconData icon, bool isDarkMode, {required TextEditingController controller, bool isPassword = false, String errorText = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
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
            errorText: errorText.isEmpty ? null : errorText,
          ),
        ),
      ],
    );
  }
}
