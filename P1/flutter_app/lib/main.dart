import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'To-Do List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> todoList = [];
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  bool showDoneTasks = false; // Track whether to show completed tasks

  Future<void> fetchToDoList() async {
    final response = await http.get(Uri.parse('http://localhost:8000/read'));
    if (response.statusCode == 200) {
      setState(() {
        todoList = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load todo list');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchToDoList();
  }

  Future<void> addTask(String task, DateTime date) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'activity': task,
        'date': date.toIso8601String(),
      }),
    );
    if (response.statusCode == 200) {
      fetchToDoList();
      _controller.clear();
      setState(() {
        _selectedDate = null;
      });
    } else {
      throw Exception('Failed to add task');
    }
  }

  Future<void> markTaskAsDone(int id) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/done'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
      }),
    );
    if (response.statusCode == 200) {
      fetchToDoList();
    } else {
      throw Exception('Failed to mark task as done');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
    // Reload the dialog box to reflect the selected date
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Task'),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      _selectedDate == null
                          ? 'Choose Date'
                          : 'Picked Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_controller.text.isNotEmpty && _selectedDate != null) {
                  addTask(_controller.text, _selectedDate!);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredList = showDoneTasks
        ? todoList
        : todoList.where((task) => task['status']).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Checkbox(
            value: showDoneTasks,
            onChanged: (value) {
              setState(() {
                showDoneTasks = value!;
              });
            },
          ),
          const Text('Show Completed Tasks'),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (BuildContext context, int index) {
          final task = filteredList[index];
          return ListTile(
            title: Text(task['activity']),
            subtitle: Text('Due date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(task['todo_date']))}'),
            trailing: task['status']
                ? IconButton(
                    icon: const Icon(Icons.done),
                    onPressed: () {
                      markTaskAsDone(task['id']);
                    },
                  )
                : const Icon(Icons.check, color: Colors.green),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add New Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(labelText: 'Task'),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text(
                            _selectedDate == null
                                ? 'Choose Date'
                                : 'Picked Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty && _selectedDate != null) {
                        addTask(_controller.text, _selectedDate!);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
