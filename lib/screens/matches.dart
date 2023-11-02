// ignore_for_file: prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:bookswipe/models/models.dart';
import 'package:flutter/material.dart';

class Matches extends StatefulWidget {
  @override
  _MatchesState createState() => _MatchesState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Matches(),
    );
  }
}

class _MatchesState extends State<Matches> {
  late List<Map<String, dynamic>> allMatches = [];

  Future<void> _getMatches() async {
    try {
      // Perform your asynchronous operations here
      final matches = await getMatches();
      setState(() {
        allMatches = matches;
      });
    } catch (e) {
      print('Error fetching book data: $e');
    }
  }

  Future<String> _getBookName(String bookId) async {
    try {
      // Perform your asynchronous operations here
      final String bookName = await fetchBookNameByID(bookId) as String;

      if (bookName != null) {
        return bookName;
      } else {
        return 'Book name not found'; // You can return a default value or handle this case as needed.
      }
    } catch (e) {
      print('Error fetching book data: $e');
      return '';
    }
  }

  Future<String> _fetchUserNameByBookID(String bookId) async {
    try {
      // Perform your asynchronous operations here
      final String userName = await fetchUserNameByBookID(bookId) as String;

      if (userName != null) {
        return userName;
      } else {
        return 'User name not found'; // You can return a default value or handle this case as needed.
      }
    } catch (e) {
      print('Error fetching book data: $e');
      return '';
    }
  }

  Future<String> _fetchBookPictureByID(String bookId) async {
    try {
      // Perform your asynchronous operations here
      final String pictureName = await fetchBookPictureByID(bookId) as String;

      if (pictureName != null) {
        return pictureName;
      } else {
        return 'Book Picture not found'; // You can return a default value or handle this case as needed.
      }
    } catch (e) {
      print('Error fetching book data: $e');
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _getMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "My book matches",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 79, 81, 140),
            ),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Divider(),
          Expanded(
              child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: allMatches.length,
            itemBuilder: (context, index) {
              final item = allMatches[index];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 9.0),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.green, // Border color
                                  width: 4.0, // Border width
                                ),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: FutureBuilder<String>(
                                    future: _fetchBookPictureByID(
                                        '${item['book1'].id}'),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator(); // Display a loading indicator.
                                      } else if (snapshot.hasError) {
                                        return Text("Error: ${snapshot.error}");
                                      } else {
                                        String imagePath =
                                            'lib/assets/images/${snapshot.data}'; // Use a default image path if snapshot.data is null
                                        return CircleAvatar(
                                          backgroundImage:
                                              AssetImage(imagePath),
                                        );
                                      }
                                    },
                                  )),
                            ),
                            SizedBox(width: 3), // Spacing between images
                            Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.red, // Border color
                                    width: 4.0, // Border width
                                  ),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: FutureBuilder<String>(
                                      future: _fetchBookPictureByID(
                                          '${item['book2'].id}'),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator(); // Display a loading indicator.
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              "Error: ${snapshot.error}");
                                        } else {
                                          String imagePath =
                                              'lib/assets/images/${snapshot.data}'; // Use a default image path if snapshot.data is null
                                          return CircleAvatar(
                                            backgroundImage:
                                                AssetImage(imagePath),
                                          );
                                        }
                                      },
                                    ))),
                          ],
                        ),
                        // Right side with title and subtitle
                        SizedBox(width: 20), // Spacing between images
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(TextSpan(
                              text: '', // Leave this empty initially
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: FutureBuilder<String>(
                                    future: _fetchUserNameByBookID(
                                        '${item['book2'].id}'),
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
                                                  20), // Change the text style for error message.
                                        );
                                      } else {
                                        return Text(
                                          snapshot.data ??
                                              'Book name not found',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  20), // Change the text style for the book name.
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width) - 195,
                              child: RichText(
                                maxLines:
                                    10, // Set the maximum number of lines before text wraps
                                overflow: TextOverflow.visible,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Get their ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    TextSpan(
                                      text: '', // Leave this empty initially
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 18),
                                      children: [
                                        WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: FutureBuilder<String>(
                                            future: _getBookName(
                                                '${item['book1'].id}'),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator(); // Display a loading indicator.
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                  "Error: ${snapshot.error}",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize:
                                                          18), // Change the text style for error message.
                                                );
                                              } else {
                                                return Text(
                                                  snapshot.data ??
                                                      'Book name not found',
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize:
                                                          18), // Change the text style for the book name.
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextSpan(
                                      text: ' for your ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    TextSpan(
                                      text: '', // Leave this empty initially
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18),
                                      children: [
                                        WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: FutureBuilder<String>(
                                            future: _getBookName(
                                                '${item['book2'].id}'),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator(); // Display a loading indicator.
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                  "Error: ${snapshot.error}",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize:
                                                          18), // Change the text style for error message.
                                                );
                                              } else {
                                                return Text(
                                                  snapshot.data ??
                                                      'Book name not found',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize:
                                                          18), // Change the text style for the book name.
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextSpan(
                                      text: '.',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              );
            },
          ))
        ]));
  }
}
