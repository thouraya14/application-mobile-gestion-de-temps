import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class Task {
  final String id;
  final String title;
  final String note;
  final DateTime date;
  final String lastTime;
  final bool completed;
  final String? invitedUser;

  Task({
    required this.id,
    required this.title,
    required this.note,
    required this.date,
    required this.lastTime,
    required this.completed,
    this.invitedUser,
  });
}

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String _endTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  List<int> remindList = [5, 10, 15, 20];
  int _selectedColor = 0;
  List<String> _userNames = []; // Liste des noms d'utilisateur

  // Controllers for text fields
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  String? _selectedUser;

  @override
  void initState() {
    super.initState();
     // Appeler la méthode pour récupérer les utilisateurs au début
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(226, 115, 138, 1),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Task",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromRGBO(226, 115, 138, 1)),
                  ),
                  SizedBox(height: 20),
                  _buildInputField(
                    controller: _titleController,
                    labelText: 'Title',
                  ),
                  SizedBox(height: 20),
                  _buildInputField(
                    controller: _noteController,
                    labelText: 'Note',
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                  _buildDateTimePicker(
                    title: 'Date',
                    valueText: DateFormat.yMd().format(_selectedDate),
                    onTap: () => _selectDate(context),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildDateTimePicker(
                          title: 'End Time',
                          valueText: _endTime,
                          onTap: () => _selectTime(context, false),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPriorityButton('Low', 0),
                      _buildPriorityButton('Medium', 1),
                      _buildPriorityButton('High', 2),
                    ],
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _saveTaskToFirestore();
                        _scheduleNotification();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text('Create Task', style: TextStyle(fontSize: 18)),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color.fromRGBO(226, 115, 138, 1)),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Color.fromRGBO(226, 115, 138, 0.1),
        border: InputBorder.none,
      ),
      maxLines: maxLines,
    );
  }

  Widget _buildDateTimePicker({
    required String title,
    required String valueText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: title,
          filled: true,
          fillColor: Color.fromRGBO(226, 115, 138, 0.1),
          border: InputBorder.none,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(valueText),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityButton(String text, int colorIndex) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedColor = colorIndex;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedColor == colorIndex ? Colors.grey : null,
      ),
      child: Text(text),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }

  _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _endTime = pickedTime.format(context);
        } else {
          _endTime = pickedTime.format(context);
        }
      });
    }
  }

 

  _saveTaskToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('taskPersonal').add({
        'title': _titleController.text,
        'note': _noteController.text,
        'date': _selectedDate,
        'last_time': _endTime,
        'priority': _selectedColor == 0 ? 'Low' : _selectedColor == 1 ? 'Medium' : 'High',
        'completed': false,
        'invitedUser': _selectedUser, // Ajout de l'utilisateur invité
      });
    } catch (e) {
      print('Error saving task: $e');
    }
  }

  _scheduleNotification() async {
    DateTime endTime = DateFormat("hh:mm a").parse(_endTime);
    final notificationTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      endTime.hour,
      endTime.minute,
    );

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: _titleController.text,
        body: _noteController.text,
        color: Color.fromRGBO(226, 115, 138, 1),
      ),
      schedule: NotificationCalendar.fromDate(date: notificationTime),
    );
  }
}
