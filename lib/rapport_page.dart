import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int completedTasks = 0;
  int incompleteTasks = 0;

  @override
  void initState() {
    super.initState();
    fetchTaskStats();
  }

  void fetchTaskStats() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('taskPersonal').get();

      int completed = 0;
      int incomplete = 0;

      querySnapshot.docs.forEach((doc) {
        bool isCompleted = doc['completed'] ?? false;
        if (isCompleted) {
          completed++;
        } else {
          incomplete++;
        }
      });

      setState(() {
        completedTasks = completed;
        incompleteTasks = incomplete;
      });

      // Vérifie si le nombre de tâches non validées est supérieur au nombre de tâches validées
      checkTaskCompletionStatus();
    } catch (e) {
      print('Error fetching task statistics: $e');
    }
  }

  void checkTaskCompletionStatus() {
    if (incompleteTasks > completedTasks) {
      int difference = incompleteTasks - completedTasks;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alerte de notification'),
            content: Text('Le nombre de tâches non validées est supérieur au nombre de tâches validées de $difference.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Report'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.string(
              _generateSvgString(completedTasks, incompleteTasks),
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Completed Tasks: $completedTasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Incomplete Tasks: $incompleteTasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _generateSvgString(int completed, int incomplete) {
    final double radius = 50;
    final double strokeWidth = 10;
    final double centerX = 100;
    final double centerY = 100;

    final num totalTasks = completed + incomplete != 0 ? completed + incomplete : 1;
    final double completedAngle = (completed / totalTasks) * 360; // Convertir en degrés
    final double incompleteAngle = (incomplete / totalTasks) * 360; // Convertir en degrés

    final String svgString =
        '<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">'
        '<circle cx="$centerX" cy="$centerY" r="$radius" fill="none" stroke="#00C851" stroke-width="$strokeWidth" stroke-dasharray="$completedAngle, 360" transform="rotate(-90, $centerX, $centerY)" />'
        '<circle cx="$centerX" cy="$centerY" r="$radius" fill="none" stroke="#ff4444" stroke-width="$strokeWidth" stroke-dasharray="$incompleteAngle, 360" transform="rotate(-90, $centerX, $centerY)" />'
        '</svg>';

    return svgString;
  }
}

