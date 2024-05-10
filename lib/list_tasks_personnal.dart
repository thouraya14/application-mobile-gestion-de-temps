import 'package:flutter/material.dart';

class ListTasksPersonnel extends StatefulWidget {
  const ListTasksPersonnel({Key? key}) : super(key: key);

  @override
  State<ListTasksPersonnel> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ListTasksPersonnel> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            onTextChanged: (text) {
              setState(() {
                searchText = text;
              });
            },
            onNightIconPressed: () {
              // Action on night icon tap
            },
          ),
          Text(
            "List Tasks Personal",
            style: TextStyle(fontSize: 25,),
          ),
          // Here you can display your task list filtered by searchText
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final Function(String) onTextChanged;
  final Function() onNightIconPressed;

  const CustomAppBar({
    Key? key,
    required this.onTextChanged,
    required this.onNightIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: ClipPath(
        clipper: WaveClip(),
        child: Container(
          color: Color(0xFFC3EBEE),
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 120,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: onTextChanged,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search, color: Colors.white,size: 30,),
                    hintStyle: TextStyle(color: Colors.white70,fontSize: 25),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              IconButton(
                onPressed: onNightIconPressed,
                icon: Icon(Icons.nightlight_round, color: Colors.white,size: 30,),
                
              ),
            ],
          ),
        ),
      ),
      preferredSize: Size.fromHeight(kToolbarHeight + 100),
    );
  }
}

class WaveClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    final lowPoint = size.height - 20;
    final highPoint = size.height - 40;

    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, highPoint, size.width / 2, lowPoint);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, lowPoint);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
