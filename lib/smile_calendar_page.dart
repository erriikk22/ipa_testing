import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa SharedPreferences

class SmileCalendarPage extends StatefulWidget {
  @override
  _SmileCalendarPageState createState() => _SmileCalendarPageState();
}

class _SmileCalendarPageState extends State<SmileCalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final Map<DateTime, List<String>> _events = {};
  final TextEditingController _eventController = TextEditingController();
  bool _showSmileTaskEvents = false;

  // Función para manejar la selección de fecha
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  // Función para obtener los eventos de un día específico
  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  // Función para agregar un nuevo evento
  void _addEvent() {
    if (_eventController.text.isNotEmpty) {
      setState(() {
        if (_events[_selectedDay] == null) {
          _events[_selectedDay] = [];
        }
        _events[_selectedDay]!.add(_eventController.text);
      });
      _eventController.clear();
      _saveEvents(); // Guardar los eventos después de agregarlos
    }
  }

  // Cargar el estado del switch desde SharedPreferences
  _loadShowSmileTaskEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showSmileTaskEvents = prefs.getBool('showSmileTaskEvents') ?? false;
    });
  }

  // Guardar el estado del switch en SharedPreferences
  _saveShowSmileTaskEvents(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showSmileTaskEvents', value);
  }

  // Cargar los eventos desde SharedPreferences
  _loadEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> eventKeys = prefs.getKeys();
    eventKeys.forEach((key) {
      DateTime day = DateTime.parse(key);
      List<String> events = List<String>.from(prefs.getStringList(key)!);
      setState(() {
        _events[day] = events;
      });
    });
  }

  // Guardar los eventos en SharedPreferences
  _saveEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _events.forEach((date, events) {
      prefs.setStringList(date.toIso8601String(), events);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadShowSmileTaskEvents(); // Cargar la preferencia del switch
    _loadEvents(); // Cargar los eventos cuando se inicia la página
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F9FB),
      appBar: AppBar(
        title: Text(
          'Smile Calendar',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF6AC1A2),
        elevation: 4,
      ),
      body: Column(
        children: [
          // Calendario centrado con diseño refinado
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
              eventLoader: _getEventsForDay,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.pinkAccent.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
                markerDecoration: BoxDecoration(
                  color: Colors.purpleAccent.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
              ),
            ),
          ),

          // Mostrar eventos para el día seleccionado
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Eventos para ${DateFormat('MMMM dd, yyyy').format(_selectedDay)}',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    // Mostrar los eventos
                    _getEventsForDay(_selectedDay).isEmpty
                        ? Text('No hay eventos para este día', style: TextStyle(color: Colors.grey))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _getEventsForDay(_selectedDay).length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  title: Text(
                                    _getEventsForDay(_selectedDay)[index],
                                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                                  ),
                                ),
                              );
                            },
                          ),
                    SizedBox(height: 20),
                    // Agregar un nuevo evento
                    TextField(
                      controller: _eventController,
                      decoration: InputDecoration(
                        hintText: 'Agregar evento...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addEvent,
                      child: Text(
                        'Agregar Evento',
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6AC1A2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Switch para activar o desactivar los eventos de Smile Task
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mostrar eventos de Smile Task',
                          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                        ),
                        Switch(
                          value: _showSmileTaskEvents,
                          onChanged: (bool value) {
                            setState(() {
                              _showSmileTaskEvents = value;
                              _saveShowSmileTaskEvents(value); // Guardar la preferencia
                            });
                          },
                          activeColor: Color(0xFF6AC1A2),
                          activeTrackColor: Color(0xFFB0E2D4),
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey[300],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
