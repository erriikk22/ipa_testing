import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SmileTaskPage extends StatefulWidget {
  @override
  _SmileTaskPageState createState() => _SmileTaskPageState();
}

class _SmileTaskPageState extends State<SmileTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _tasks = [];

  // Función para cargar las tareas desde SharedPreferences
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

  // Función para guardar las tareas en SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksJson = json.encode(_tasks);
    await prefs.setString('tasks', tasksJson);
  }

  // Función para agregar una nueva tarea
  void _addTask(String priority) {
    if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty && _tasks.length < 10) {
      setState(() {
        _tasks.add({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'dueDate': _selectedDate.toIso8601String(), // Guardamos la fecha como string ISO
          'completed': false,
          'priority': priority, // Añadimos la prioridad
        });
      });

      _titleController.clear();
      _descriptionController.clear();
      _selectedDate = DateTime.now();

      _saveTasks(); // Guardamos las tareas después de agregar una nueva
    }
  }

  // Función para mostrar el picker de fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    ) ?? _selectedDate;
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  // Función para abrir el diálogo de creación de tarea
  void _openAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Add New Task", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título de la tarea
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              SizedBox(height: 10),
              // Descripción de la tarea
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 10),
              // Selector de fecha
              Row(
                children: [
                  Text(
                    "Due: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}",
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Selector de prioridad
              DropdownButton<String>(
                hint: Text("Select Priority"),
                onChanged: (String? value) {
                  if (value != null) {
                    _addTask(value);
                    Navigator.of(context).pop(); // Cierra el diálogo después de agregar la tarea
                  }
                },
                items: <String>['High', 'Medium', 'Low'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            // Botones del diálogo
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Función para marcar tarea como completada
  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
    });

    _saveTasks(); // Guardamos las tareas después de marcar una tarea como completada
  }

  // Función para abrir la página de edición de tarea
  void _openEditTaskPage(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final task = _tasks[index];
        _titleController.text = task['title'];
        _descriptionController.text = task['description'];
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Edit Task", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título de la tarea
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              SizedBox(height: 10),
              // Descripción de la tarea
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 10),
              // Selector de fecha
              Row(
                children: [
                  Text(
                    "Due: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}",
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Selector de prioridad
              DropdownButton<String>(
                value: task['priority'],
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _tasks[index]['priority'] = value;
                    });
                    _saveTasks(); // Guardamos las tareas después de editar la prioridad
                  }
                },
                items: <String>['High', 'Medium', 'Low'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            // Botones del diálogo
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tasks[index]['title'] = _titleController.text;
                  _tasks[index]['description'] = _descriptionController.text;
                  _tasks[index]['dueDate'] = _selectedDate.toIso8601String();
                });
                Navigator.of(context).pop();
                _saveTasks(); // Guardamos las tareas después de editar una tarea
              },
              child: Text("Save"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        );
      },
    );
  }

  // Función para obtener el color según la prioridad
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Color(0xFFFFB6C1); // Rosa pastel
      case 'Medium':
        return Color(0xFFFFF8B0); // Amarillo pastel
      case 'Low':
        return Color(0xFFB0E57C); // Verde pastel
      default:
        return Colors.white; // Color por defecto si no hay prioridad
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Cargamos las tareas al iniciar la aplicación
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smile Task',
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lista de tareas
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return GestureDetector(
                    onTap: () => _openEditTaskPage(index), // Abre la página de edición cuando se toca la tarea
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      color: _getPriorityColor(task['priority']), // Cambia el color de la tarjeta según la prioridad
                      child: ListTile(
                        title: Text(
                          task['title'],
                          style: TextStyle(
                            decoration: task['completed'] ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text('Due: ${DateTime.parse(task['dueDate']).toLocal()}'),
                        trailing: IconButton(
                          icon: Icon(task['completed'] ? Icons.check_box : Icons.check_box_outline_blank),
                          onPressed: () => _toggleTaskCompletion(index),
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
      floatingActionButton: _tasks.length < 10 // Solo permitir crear tareas si hay menos de 10
          ? FloatingActionButton(
              onPressed: _openAddTaskDialog,
              child: Icon(Icons.add),
              backgroundColor: const Color.fromARGB(255, 43, 43, 43), // Color bonito para el botón
              hoverColor: const Color.fromARGB(118, 94, 92, 92),
            )
          : null,
    );
  }
}
