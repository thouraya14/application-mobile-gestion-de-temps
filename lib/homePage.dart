import 'package:devapp/hometask/listTaskHome.dart';
import 'package:devapp/worktask/taskwork.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:devapp/screens/%20WelcomeScreen.dart';
import 'package:devapp/personaltask/home.dart';
import 'package:devapp/rapport_page.dart';
// Import the HomePage.dart file
 // Import the ListTasks.dart file

const PRIMARY = "primary";
const WHITE = "white";

const Map<String, Color> myColors = {
  PRIMARY: Color.fromRGBO(226, 115, 138, 1),
  WHITE: Colors.white,
};

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: myColors[PRIMARY],
          flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 80)), // Move the image down
          
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              left: 15,
            ),
            child: IconButton(
              icon: Icon(
                Icons.menu,
                color: myColors[WHITE],
                size: 30,
              ),
              onPressed: () => print("Menu pressed"),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 15),
              child: IconButton(
                onPressed: () => print("Search pressed"),
                icon: Icon(
                  Icons.search,
                  color: myColors[PRIMARY],
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: myColors[WHITE],
      body: Column(
        children: [
         Expanded(
  flex: 6,
  child: Container(
    decoration: BoxDecoration(
      color: myColors[PRIMARY],
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'images/img.jpg', // Replace 'images/img.jpg' with the actual path of your image
          width: 900, // Increase the width
          height: 900, // Increase the height
          fit: BoxFit.cover, // Adjust the fit based on your requirement
        ),
        // Add other widgets on top of the image if necessary
      
      ],
        
    ),
  ),
),
        
          Expanded(
            flex: 12,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  shrinkWrap: true,
                  children: [
                    _buildButton(context, 'Personal', Icons.person, Color(0xFFB1C9EF)),
                    _buildButton(context, 'Work', Icons.work, Color(0xFF8AAEE0)),
                    _buildButton(context, 'Leisure', Icons.sports_esports, Color(0xFF638ECB)),
                    _buildButton(context, 'Home', Icons.home, Color(0xFF395886)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Color.fromRGBO(241, 81, 113, 1),
        items: <Widget>[
          Icon(Icons.home, size: 30,),
          Icon(Icons.logout, size: 30),
          Icon(Icons.bar_chart, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            // Add navigation logic here
            switch (_selectedIndex) {
              case 0:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                break;
              case 1:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                break;
              case 2:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>ReportPage()));
                break;
              default:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                break;
            }
          });
        },
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        if (text == 'Personal') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ListPersonalPage()));
        } else {
           if (text == 'Work') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ListtaskPage()));
           
        }else{
           if (text == 'Home'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ListtaskHomePage()));
        
        }else{
             if (text == 'Leisure'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ListLeisuresPage()));
        }
        } 
      }
        } 
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
