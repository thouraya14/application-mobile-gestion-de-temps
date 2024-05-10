import 'package:devapp/add_task_bar.dart';
import 'package:devapp/homePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Task {
  final String id;
  final String title;
  final String note;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.note,
    this.completed = false,
  });
}

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ListPage> {
  bool isDarkMode = false;
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('taskPersonal').get();
      setState(() {
        tasks = querySnapshot.docs.map((doc) {
          return Task(
            id: doc.id,
            title: doc['title'],
            note: doc['note'],
            completed: doc['completed'] ?? false,
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  void updateTaskCompletion(Task task) async {
    try {
      await FirebaseFirestore.instance
          .collection('taskPersonal')
          .doc(task.id)
          .update({'completed': task.completed});
    } catch (e) {
      print('Error updating task completion: $e');
    }
  }

  void _showTaskDetails(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(task.title),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Note: ${task.note}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'ID: ${task.id}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Completed: ${task.completed ? 'Yes' : 'No'}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _launchFacebookMessenger() async {
    // URL de l'application Facebook Messenger pour les invitations
    const url = 'fb-messenger://user-thread/'; // Lien pour ouvrir directement une nouvelle conversation
    try {
      bool launched = await launch(url); // Tentative d'ouverture de l'application
      if (!launched) { // Si l'application n'est pas installée ou ne peut pas être ouverte, ouvrir la version web de Facebook Messenger
        const webUrl = 'https://www.messenger.com/t/'; // Lien pour ouvrir Facebook Messenger dans un navigateur
        await launch(webUrl);
      }
    } catch (e) {
      print('Error launching Facebook Messenger: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        backgroundColor:
            isDarkMode ? Colors.black : Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
            leading: IconButton( // Ajout de l'IconButton avec l'icône de flèche de retour
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen()), // Navigation vers le tableau de bord
    );
  },
  icon: Icon(
    Icons.arrow_back_ios, // Utilisation de l'icône de flèche de retour d'iOS
    color: Color.fromARGB(255, 255, 255, 255), // Couleur de l'icône
  ),
),
          

          backgroundColor: Color(0xFFB1C9EF),
          elevation: 0,
          title: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Color(0xFFB1C9EF),
              ),
              
            ),
            title: Text(
              'Welcome',
              style: TextStyle(
                fontSize: 20,
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'List Tasks Personal',
              style: TextStyle(
                fontSize: 15,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
              icon: Icon(
                Icons.nightlight_round,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return _buildTaskItem(tasks[index]);
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _launchFacebookMessenger,
          child: Icon(Icons.group_add), // Icône pour inviter des membres
        ),
      ),
    );
  }

  Widget _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                "Today",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => AddTaskPage()))
                .then((_) => fetchTasks()),
            child: Text('+ Add Task'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFB1C9EF),
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: Color(0xFFB1C9EF),
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          // Handle date change if needed
        },
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return GestureDetector(
      onTap: () {
        _showTaskDetails(task);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Background color of the box
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: task.completed,
                  onChanged: (value) {
                    setState(() {
                      task.completed = value!;
                    });
                    updateTaskCompletion(task);
                  },
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      task.note,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                // Delete task from Firestore
                FirebaseFirestore.instance
                    .collection('taskPersonal')
                    .doc(task.id)
                    .delete()
                    .then((value) => fetchTasks());
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
