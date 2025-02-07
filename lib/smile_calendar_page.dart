import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'smile_task_page.dart' as taksPage;




class SmileCalendarPage extends StatefulWidget {
  @override
  _SmileCalendarPageState createState() => _SmileCalendarPageState();
}

class _SmileCalendarPageState extends State<SmileCalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Map<String, dynamic>>> _events = {};
  List<Map<String, dynamic>> _tasks = [];
  bool _showSmileTaskEvents = false;

  @override
  void initState() {
    super.initState();
    _loadShowSmileTaskEvents();
    _loadEvents();
    _loadTasks();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  List<Map<String, dynamic>> _getTasksForDay(DateTime day) {
    return _tasks.where((task) => isSameDay(DateTime.parse(task['dueDate']), day)).toList();
  }

  void _addEvent(String title, {String description = ''}) {
    if (title.isNotEmpty) {
      setState(() {
        _events[_selectedDay] ??= [];
        _events[_selectedDay]!.add({
          'title': title,
          'description': description,
          'isSmileTask': false
        });
      });
      _saveEvents();
    }
  }

  Future<void> _loadShowSmileTaskEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showSmileTaskEvents = prefs.getBool('showSmileTaskEvents') ?? false;
    });
  }

  Future<void> _saveShowSmileTaskEvents(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showSmileTaskEvents', value);
  }

 Future<void> _loadEvents() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Set<String> keys = prefs.getKeys();
  keys.forEach((key) {
    if (_isDateKey(key)) {
      try {
        DateTime day = DateTime.parse(key);
        List<String> eventList = prefs.getStringList(key) ?? [];
        List<Map<String, dynamic>> events = eventList.map((e) {
          return {
            'title': e,
            'description': '',
            'isSmileTask': false,
          };
        }).toList();
        setState(() {
          _events[day] = events;
        });
      } catch (e) {
        print('Error al cargar eventos: $key. Error: $e');
      }
    }
  });
}


  bool _isDateKey(String key) {
    try {
      DateTime.parse(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _events.forEach((date, events) {
      List<String> eventTitles = events.map((e) => e['title'] as String).toList();
      prefs.setStringList(date.toIso8601String(), eventTitles);
    });
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      List<dynamic> decodedTasks = json.decode(tasksJson);
      setState(() {
        _tasks = decodedTasks.map((task) => Map<String, dynamic>.from(task)).toList();
      });
    }
  }

  Future<void> _deleteTask(DateTime day, String taskTitle) async {
    setState(() {
      _tasks.removeWhere((task) => task['title'] == taskTitle && isSameDay(DateTime.parse(task['dueDate']), day));
    });
    _saveTasks();
  }

  Future<void> _deleteEvent(DateTime day, String eventTitle) async {
    setState(() {
      _events[day]?.removeWhere((event) => event['title'] == eventTitle);
    });
    _saveEvents();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', json.encode(_tasks));
  }

  void _showAddEventDialog() {
  TextEditingController _eventController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            'Añadir Evento',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E3A59),
            ),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título del evento
              TextField(
                controller: _eventController,
                decoration: InputDecoration(
                  hintText: 'Escribe el título del evento',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                ),
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              SizedBox(height: 20),
              // Descripción del evento
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Descripción (opcional)',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                ),
                style: GoogleFonts.poppins(color: Colors.black),
              ),
            ],
          ),
        ),
        actions: [
          // Botón de cancelar
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Botón de guardar
          TextButton(
            onPressed: () {
              if (_eventController.text.isNotEmpty) {
                _addEvent(_eventController.text, description: _descriptionController.text);
                Navigator.of(context).pop();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFF6AC1A2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Guardar',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}


  Widget _buildMarker(Color color) {
    return Positioned(
      bottom: 5,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }

  Widget _buildSection(String title, Color color, List<Map<String, dynamic>> items, DateTime day, bool isTask) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ),
        ...items.map((item) {
          return ListTile(
            title: Text(item['title'], style: GoogleFonts.poppins(fontSize: 16)),
            subtitle: item['description'] != '' ? Text(item['description'], style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)) : null,
            onTap: isTask ? () {
              // Redirigir a la página de Smile Task
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => taksPage.SmileTaskPage()),
              );
            } : null,
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                if (isTask) {
                  _deleteTask(day, item['title']);
                } else {
                  _deleteEvent(day, item['title']);
                }
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smile Calendar', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _showSmileTaskEvents ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showSmileTaskEvents = !_showSmileTaskEvents;
                _saveShowSmileTaskEvents(_showSmileTaskEvents);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                bool hasEvents = _events[date]?.isNotEmpty ?? false;
                bool hasTasks = _getTasksForDay(date).isNotEmpty;

                if (hasEvents && hasTasks) {
                  return _buildMarker(Colors.purple);
                } else if (hasEvents) {
                  return _buildMarker(Colors.blue);
                } else if (hasTasks) {
                  return _buildMarker(Colors.green);
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (_showSmileTaskEvents && _getTasksForDay(_selectedDay).isNotEmpty)
                  _buildSection('Smile Tasks', Colors.green, _getTasksForDay(_selectedDay), _selectedDay, true),
                if (_getEventsForDay(_selectedDay).isNotEmpty)
                  _buildSection('Smile calendar', Colors.blue, _getEventsForDay(_selectedDay), _selectedDay, false),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF6AC1A2),
      ),
    );
  }
}

class SmileTaskPage extends StatelessWidget {
  final Map<String, dynamic> task;

  SmileTaskPage({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smile Task', style: GoogleFonts.poppins(fontSize: 24)),
        backgroundColor: Color(0xFF6AC1A2),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Task Title: ${task['title']}', style: GoogleFonts.poppins(fontSize: 20)),
            SizedBox(height: 10),
            Text('Description: ${task['description']}', style: GoogleFonts.poppins(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
