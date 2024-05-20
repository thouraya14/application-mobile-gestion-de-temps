import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homePage.dart';
import 'regScreen.dart'; // Importer la page HomeScreen pour la navigation

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Future<void> signIn(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Vérification dans Firestore si l'utilisateur existe
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
      if (userSnapshot.exists) {
        // Si l'utilisateur existe dans Firestore, naviguer vers la page HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else {
        // Si l'utilisateur n'existe pas dans Firestore, afficher un message d'erreur
        print('User does not exist');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 15),
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
           Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 25),
                  child: Image.asset(
                    'images/login.jpg',
                    
                    height: 400,
                  ),
                ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                       prefixIcon: Icon(Icons.email, color:Color.fromRGBO(226, 115, 138, 1)),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Color(0xFF7BC7FF)),
                        hintText: 'Enter your email',
                      hintStyle: TextStyle(
                        color: Color(0xFF7BC7FF), // Couleur du hint en 7BC7FF
                      ),
                      filled: true,
                      fillColor:  Color(0xFFEFF5FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Color.fromRGBO(226, 115, 138, 1)),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Color(0xFF7BC7FF)),
                        hintText: 'Enter your password',
                      hintStyle: TextStyle(
                        color: Color(0xFF7BC7FF), // Couleur du hint en 7BC7FF
                      ),
                      filled: true,
                      fillColor:Color(0xFFEFF5FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      signIn(context, emailController.text, passwordController.text);
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,color: Colors.white
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(226, 115, 138, 1), // Couleur FEAAE1
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 150),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegScreen()),
                      );
                    },
                    child: Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegScreen()),
                      );
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color:Color(0xFF3190E9),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Action à effectuer pour Facebook
                        },
                        icon: Icon(
                          Icons.facebook,
                          color:Color(0xFF3190E9), // Couleur de l'icône Facebook
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          // Action à effectuer pour Google
                        },
                        icon: Icon(
                          Icons.android,
                          color:Color(0xFF7BC7FF), // Couleur de l'icône Google
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          // Action à effectuer pour Google
                        },
                        icon: Image.asset(
                          'images/google.jpg', // Remplacez cet emplacement par le chemin de votre propre image Google
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
