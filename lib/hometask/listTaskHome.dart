
import 'package:devapp/add_task_work.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';

// Importez la page AddTaskPage

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

class ListtaskHomePage extends StatefulWidget {
  const ListtaskHomePage({Key? key}) : super(key: key);

  @override
  _ListTaskHomePageState createState() => _ListTaskHomePageState();
}

class _ListTaskHomePageState extends State<ListtaskHomePage> {
  bool isDarkMode = false;
  List<Task> tasks = [];
  String? _selectedUser; // Utilisateur sélectionné dans le menu déroulant
  List<String> _userNames = []; // Liste des noms d'utilisateur

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    fetchTasks(); // Appeler la méthode pour récupérer les utilisateurs au début
  }

  void fetchTasks() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('taskHome').get();
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

  _fetchUsers() async {
    // Récupérer les utilisateurs depuis Firestore
    try {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
      List<String> usersList = [];
      usersSnapshot.docs.forEach((doc) {
        // Ajouter le nom de chaque utilisateur à la liste
        usersList.add(doc['username']);
      });
      // Mettre à jour l'état de l'utilisateur avec la liste des utilisateurs récupérés
      setState(() {
        _userNames = usersList;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void updateTaskCompletion(Task task) async {
    try {
      await FirebaseFirestore.instance
          .collection('taskHome')
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
          backgroundColor: Colors.pink[50],
          title: Text(task.title),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Title: ${task.title}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
               Text(
                'Note: ${task.note}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
               
              Text(
                'Completed: ${task.completed ? 'Yes' : 'No'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _createChatWithSelectedUser(String? selectedUser) {
    if (selectedUser != null) {
      // Créer un nouveau document dans la collection 'chat'
      FirebaseFirestore.instance.collection('chat').add({
        'participants': [_selectedUser, selectedUser],
        // Vous pouvez ajouter d'autres champs comme 'messages', 'lastUpdated', etc.
      }).then((value) {
        print('Chat created with $selectedUser');
        // Naviguer vers la page de chat avec les participants sélectionnés
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(participants: [_selectedUser!, selectedUser]),
          ),
        );
      }).catchError((error) {
        print('Failed to create chat: $error');
      });
    } else {
      // Afficher un message d'erreur ou une alerte si aucun utilisateur n'est sélectionné
      print('No user selected');
    }
  }

  void _launchEmailInvitation() async {
    final String email = 'adresse@email.com';
    final String subject = 'Invitation à rejoindre notre application';
    final String body =
        'Bonjour,\n\nJe t\'invite à rejoindre notre application.\n\nClique sur ce lien pour rejoindre: [lien]\n\nCordialement,';
    final String mailtoLink =
        'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    if (await canLaunch(mailtoLink)) {
      await launch(mailtoLink);
    } else {
      print('Could not launch $mailtoLink');
    }
  }

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
    home: Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF395886),
        title: const Text('List Tasks Home'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
            icon: const Icon(
              Icons.nightlight_round,
              size: 30,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _launchEmailInvitation();
        },
        child: const Icon(Icons.group_add),
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const Text(
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTaskWorkPage()),
              ).then((_) => fetchTasks());
            },
            style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color.fromRGBO(226, 115, 138, 1)),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      ),
            child: const Text('+ Add Task'),
            
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
        selectionColor: Color(0xFF395886),
        selectedTextColor: Colors.white,
        dateTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        dayTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        monthTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
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
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFF395886),
          borderRadius: BorderRadius.circular(10),
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
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      task.note,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('taskHome')
                        .doc(task.id)
                        .delete()
                        .then((value) => fetchTasks());
                  },
                  icon: const Icon(Icons.delete,color:Color.fromRGBO(241, 81, 113, 1)),
                ),
                // Ajoutez l'icône de chat avec le menu déroulant
                IconButton(
                  onPressed: () {
                    // Afficher la boîte de dialogue pour sélectionner un utilisateur
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Select User'),
                          content: DropdownButton<String>(
                            value: _selectedUser,
                            items: _userNames.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedUser = newValue;
                              });
                            },
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
                                // Créer un chat avec l'utilisateur sélectionné
                                _createChatWithSelectedUser(_selectedUser);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Create Chat'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.chat,color: Colors.pink),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



class ChatPage extends StatefulWidget {
  final List<String> participants;

  const ChatPage({Key? key, required this.participants}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _messageCollection;

  @override
  void initState() {
    super.initState();
    _messageCollection = _firestore.collection('chat_messages');
  }

  void _sendMessage() {
  final String messageText = _messageController.text.trim();
  if (messageText.isNotEmpty) {
    _messageCollection.add({
      'sender': widget.participants[0], // Utilisez le nom d'utilisateur de l'utilisateur actuel
      'text': messageText,
      'timestamp': DateTime.now(),
    }).then((_) {
      _messageController.clear();
    }).catchError((error) {
      print('Failed to send message: $error');
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.participants[1]}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messageCollection
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
  final messageText = message['text'];
  final sender = message['sender'];
  final isMe = sender == widget.participants[0]; // Vérifie si c'est l'utilisateur actuel
  final messageWidget = Text(
    messageText,
    style: TextStyle(
      color: isMe ? Colors.blue : Colors.pink, // Couleur différente pour l'utilisateur actuel
    ),
  );
  messageWidgets.add(messageWidget);
}

                return ListView(
                  reverse: true,
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
