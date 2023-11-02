// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:bookswipe/screens/newbook.dart';

class MyBooksPage extends StatefulWidget {
  final String id;

  MyBooksPage({required this.id});

  @override
  _MyBooksPageState createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyBooksPage> {
  List<Map<String, dynamic>> filteredBooks = [];

  Future<void> _getBooks() async {
    try {
      // Perform your asynchronous operations here
      final books = await getBooksbyUserID(widget.id);
      setState(() {
        filteredBooks = books;
      });
    } catch (e) {
      print('Error fetching book data: $e');
    }
  }

  Future<String> _fetchGenreNameByID(String genreID) async {
    try {
      // Perform your asynchronous operations here
      final String genreName = await fetchGenreNameByID(genreID) as String;

      if (genreName != null) {
        return genreName;
      } else {
        return 'Genre name not found'; // You can return a default value or handle this case as needed.
      }
    } catch (e) {
      print('Error fetching book data: $e');
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          color: Color.fromARGB(255, 79, 81, 140),
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Implement the functionality to navigate back
            Navigator.pop(context);
          },
        ),
        title: Text(
          "My Books",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 79, 81, 140),
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // the plus button
          // Center(
          //   child: GestureDetector(
          //     onTap: () {
          //       // navigate to selectable closet screen
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => NewBook(),
          //         ),
          //       );
          //     },
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment
          //           .center, // Center both icon and text vertically
          //       children: <Widget>[
          //         Container(
          //           width: 40.0,
          //           height: 50.0,
          //           decoration: BoxDecoration(
          //             border: Border.all(
          //               color: Color.fromARGB(255, 79, 81, 140),
          //               width: 2.0,
          //             ),
          //             shape: BoxShape.circle,
          //           ),
          //           child: Icon(
          //             Icons.add,
          //             color: Color.fromARGB(255, 79, 81, 140),
          //             size: 32.0,
          //           ),
          //         ),
          //         Text(
          //           'Add a New Book',
          //           style: TextStyle(
          //             color: Color.fromARGB(255, 79, 81, 140),
          //             fontWeight: FontWeight.bold,
          //             fontSize: 17,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          //const SizedBox(height: 15),

          Expanded(
              child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: filteredBooks.length,
            itemBuilder: (BuildContext context, int index) {
              final item = filteredBooks[index];

              Color tagColor = Colors.grey;
              if (item['genre'].id == "1") {
                tagColor = Colors.pink;
              } else if (item['genre'].id == "2") {
                tagColor = Colors.orange;
              } else if (item['genre'].id == "3") {
                tagColor = Colors.green;
              } else if (item['genre'].id == "4") {
                tagColor = Colors.blue;
              } else if (item['genre'].id == "5") {
                tagColor = Colors.brown;
              } else if (item['genre'].id == "6") {
                tagColor = Colors.red;
              } else if (item['genre'].id == "7") {
                tagColor = Colors.yellow;
              } else if (item['genre'].id == "8") {
                tagColor = Colors.purple;
              }

              return GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => Item(itemId: clothingItem.id),
                  //   ),
                  // );
                },
                child: GridTile(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // book name
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0),
                            child: Text(
                              '${item['title']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2.0, bottom: 3.0, left: 8.0, right: 8.0),
                            child: Text(
                              '${item['author']}',
                              style: const TextStyle(
                                //fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: tagColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text.rich(TextSpan(
                                  text: '', // Leave this empty initially
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: FutureBuilder<String>(
                                        future: _fetchGenreNameByID(
                                            '${item['genre'].id}'),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator(); // Display a loading indicator.
                                          } else if (snapshot.hasError) {
                                            return Text(
                                              "Error: ${snapshot.error}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      13), // Change the text style for error message.
                                            );
                                          } else {
                                            return Text(
                                              snapshot.data ??
                                                  'Genre not found',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      13), // Change the text style for the book name.
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Image.asset(
                                  'lib/assets/images/${item['picture']}',
                                  width: double
                                      .infinity, // set the width to the maximum available width
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}
