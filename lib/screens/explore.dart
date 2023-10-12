import 'package:bookswipe/screens/newbook.dart';
import 'package:flutter/material.dart';

class Explore extends StatelessWidget {
  final List<String> selectedItems;
  final int currentIndex;

  const Explore(
      {Key? key, required this.selectedItems, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Explore page",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 79, 81, 140)),
            ),
          ),
          const SizedBox(height: 20.0),

          // the plus sign here
          Center(
            child: GestureDetector(
              onTap: () {
                // navigate to selectable closet screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewBook()));
              },
              child: Container(
                width: 40.0,
                height: 100.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 32.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
