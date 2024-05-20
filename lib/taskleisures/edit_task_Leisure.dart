import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTask {
  final String id;
  final String title;
  final String note;
  final DateTime date;
  final String lastTime;
  final String priority;
  final bool completed;

  EditTask({
    required this.id,
    required this.title,
    required this.note,
    required this.date,
    required this.lastTime,
    required this.priority,
    required this.completed,
  });
}

class EditTaskPage extends StatefulWidget {
  final EditTask editTask;

  const EditTaskPage({Key? key, required this.editTask}) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  int _selectedColor = 0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.editTask.title);
    _noteController = TextEditingController(text: widget.editTask.note);
   _selectedDate = widget.editTask.date ?? DateTime.now(); 

    _selectedTime = TimeOfDay.fromDateTime(widget.editTask.date);
    _selectedColor = _getPriorityIndex(widget.editTask.priority);
  }

  int _getPriorityIndex(String priority) {
    switch (priority) {
      case 'Low':
        return 0;
      case 'Medium':
        return 1;
      case 'High':
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title'),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter title',
              ),
            ),
            SizedBox(height: 20),
            Text('Note'),
            TextFormField(
              controller: _noteController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Enter note',
              ),
            ),
            SizedBox(height: 20),
            Text('Date'),
            Text(DateFormat.yMd().format(_selectedDate)),
            SizedBox(height: 20),
            Text('End Time'),
            InkWell(
              onTap: () => _selectTime(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: _selectedTime.format(context),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedTime.format(context)),
                    Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Priority'),
            Row(
              children: [
                _buildPriorityButton('Low', 0),
                SizedBox(width: 10),
                _buildPriorityButton('Medium', 1),
                SizedBox(width: 10),
                _buildPriorityButton('High', 2),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTask,
                child: Text('Save Task'),
              ),
            ),
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  _saveTask() async {
    try {
      final DateTime updatedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      await FirebaseFirestore.instance.collection('taskLeisures').doc(widget.editTask.id).update({
        'title': _titleController.text,
        'note': _noteController.text,
        'date': updatedDateTime,
        'lastTime': _selectedTime.format(context),
        'priority': _selectedColor == 0 ? 'Low' : _selectedColor == 1 ? 'Medium' : 'High',
      });
      Navigator.pop(context);
    } catch (e) {
      print('Error saving task: $e');
    }
  }
}
