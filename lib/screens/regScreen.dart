import 'package:devapp/%20WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loginScreen.dart';
// Importer la page WelcomeScreen pour pouvoir naviguer vers cette page

class RegScreen extends StatelessWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    Future<void> signUpWithEmailAndPassword(BuildContext context) async {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'username': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60.0, left: 22),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 24,
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 50),
                  child: Image.asset(
                    'images/signup.jpg',
                    width: 300,
                    height: 300,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
              icon: Icon(Icons.arrow_back,color:Color.fromRGBO(226, 115, 138, 1),),
              label: Text(
                'Skip',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color:Color.fromRGBO(226, 115, 138, 1)
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEFF5FD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 250.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color:Color.fromRGBO(226, 115, 138, 1)),
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: Color(0xFF7BC7FF)),
                        hintText: 'Enter your full name',
                         filled: true,
                          fillColor:  Color(0xFFEFF5FD),
                        hintStyle: TextStyle(color: Color(0xFF7BC7FF)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                           borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color:Color.fromRGBO(226, 115, 138, 1)),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Color(0xFF7BC7FF)),
                        hintText: 'Enter your email',
                         filled: true,
                          fillColor:  Color(0xFFEFF5FD),
                        hintStyle: TextStyle(color: Color(0xFF7BC7FF)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color:Color.fromRGBO(226, 115, 138, 1)),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Color(0xFF7BC7FF)),
                        hintText: 'Enter your password',
                         filled: true,
                          fillColor:  Color(0xFFEFF5FD),
                        hintStyle: TextStyle(color: Color(0xFF7BC7FF)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                           borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          signUpWithEmailAndPassword(context);
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Color.fromRGBO(226, 115, 138, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          

                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                        SizedBox(width: 20),
                        IconButton(
                          onPressed: () {
                            // Action à effectuer pour Facebook
                          },
                          icon: Icon(
                            Icons.facebook,
                            color: Color(0xFF3190E9), // Couleur de l'icône Facebook
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
                            color: Color(0xFF3190E9), // Couleur de l'icône Google
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            "Log in",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF3190E9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
