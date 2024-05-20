import 'package:devapp/%20WelcomeScreen.dart';
import 'package:devapp/homePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int completedTasks = 0;
  int incompleteTasks = 0;
  String selectedImage = '';
    int _selectedIndex = 0;
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
            content: Text(
                'Le nombre de tâches non validées est supérieur au nombre de tâches validées de $difference.'),
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
        title: Text('Tasks Report'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
            child: Image.asset(
              'images/report.jpg',
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20.0, // Ajout de l'espacement entre les boutons
              children: [
                _buildImageButton('Personal Task', 'taskPersonal', 'personnal.jpg'),
                _buildImageButton('Work Task', 'taskWork', 'work.jpg'),
                _buildImageButton('Leisure Task', 'taskLeisures', 'loisires.jpg'),
                _buildImageButton('Home Task', 'taskHome', 'home.jpg'),
              ],
            ),
          ),
          SizedBox(height: 5.0), // Espacement entre les boutons et la barre de navigation
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Color.fromRGBO(241, 81, 113, 1),
        items: <Widget>[
          Icon(Icons.bar_chart, size: 30),
          Icon(Icons.home, size: 30,),
          Icon(Icons.logout, size: 30),
          
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            // Add navigation logic here
            switch (_selectedIndex) {
              case 0:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>ReportPage()));
                break;
              case 1:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                break;
              case 2:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const WelcomeScreen()));
                break;
              default:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReportPage()));
                break;
            }
          });
        },
      ),
    );
  }

  Widget _buildImageButton(String label, String collectionName, String imageName) {
    return InkWell(
      onTap: () {
        _showTaskReportDialog(context, label, collectionName);
        setState(() {
          selectedImage = imageName;
        });
      },
      child: Card(
        margin: EdgeInsets.all(16.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/$imageName',
              width: 160, // Agrandir la largeur de l'image
              height: 120, // Agrandir la hauteur de l'image
            ),
            SizedBox(height: 12.0),
            Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showTaskReportDialog(BuildContext context, String label, String collectionName) async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();

    // Extracting completed and incomplete tasks
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

    // Displaying the dialog with text and chart
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rapport des Tâches - $label'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200, // Hauteur du graphique
                width: 200, // Largeur du graphique
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 150,
                        width: 150,
                        child: CircularProgressIndicator(
                          value: completed / (completed + incomplete), // Valeur du graphique
                          strokeWidth: 12, // Épaisseur de la ligne
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green), // Couleur de la partie complétée
                          backgroundColor: Colors.pink.withOpacity(0.3), // Couleur de la partie non complétée
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Détails:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: Colors.green, // Couleur du carré pour les tâches complétées
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Tâches Complétées: $completed',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: Colors.pink.withOpacity(0.3), // Couleur du carré pour les tâches non complétées
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Tâches Non Complétées: $incomplete',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    print('Error fetching task report data: $e');
  }
}
}