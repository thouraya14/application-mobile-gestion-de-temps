import 'package:devapp/homePage.dart';
import 'package:devapp/rapport_page.dart';
import 'package:flutter/material.dart';
import 'loginScreen.dart';
import 'theme.dart';
import 'homePage.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Couleur de fond en gris
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20), // Espace entre le haut de l'écran et l'image
          Center(
            child: Image.asset(
              'images/get.jpg',
              height: 400, // Taille réduite de l'image
            ),
          ),
          SizedBox(height: 20), // Espace entre l'image et le bouton
          Text(
            'Manage Your Time', // Titre au-dessus du bouton
            style: subHeadingStyle, // Gras
          ),
            SizedBox(height: 8), // Espace entre le deuxième et le troisième nouveau texte
          Text(
            'Take control of your schedule on the go', // Texte supplémentaire 3
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 150), // Espace entre le titre et le bouton
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportPage()),
              );
            },
            icon: Icon(
              Icons.arrow_forward_ios, // Petite flèche
              color: Colors.white, // Couleur de la flèche
              size: 20, // Taille de la flèche
            ),
            label: Text(
              'Next', // Nom du bouton
              style: TextStyle(
                fontSize: 20, // Taille de la police
                color: Colors.white, // Couleur du texte
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:Color.fromRGBO(226, 115, 138, 1), // Couleur du bouton
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rayon de 10
              ),
               padding: EdgeInsets.symmetric(vertical: 15,horizontal: 150),

            ),
          ),
          SizedBox(height: 10), // Espace supplémentaire pour déplacer le bouton vers le haut
        ],
      ),
    );
  }
}
