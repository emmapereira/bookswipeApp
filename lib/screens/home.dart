// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/models.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class _HomeState extends State<Home> {
  late String bookToShow;
  late Map<String, dynamic> currentBook = {};
  late String genreName = '';
  late String bookOwner = '';
  late bool isImageLarge;
  late String kmNumber = '0';
  late bool swipeDetected = false;
  late int numberOfBooks = 0;

  Future<void> _fetchBookDataByID(String id) async {
    try {
      // Perform your asynchronous operations here
      final bookData = await fetchBookDataByID(id) as Map<String, dynamic>;

      DocumentReference<Map<String, dynamic>> genreRef = bookData['genre'];
      String genreId = genreRef.id;
      final gName = await fetchGenreNameByID(genreId) as String;

      DocumentReference<Map<String, dynamic>> userRef = bookData['owner'];
      String userId = userRef.id;
      final userName = await fetchUserNameByID(userId) as String;
      // Update currentBook with the fetched data
      setState(() {
        currentBook = bookData;
        genreName = gName;
        bookOwner = userName;
        kmNumber = getKmNumber();
        swipeDetected = false;
        numberOfBooks = numberOfBooks;
      });
    } catch (e) {
      print('Error fetching book data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    isImageLarge = true;
    // TO DO: List to contain only books filtered for this user
    bookToShow = '14';
    _fetchBookDataByID(bookToShow);

    CollectionReference booksCollection =
        FirebaseFirestore.instance.collection('books');

    booksCollection.get().then((QuerySnapshot querySnapshot) {
      numberOfBooks = querySnapshot.docs.length;
      print("Number of documents in the collection: $numberOfBooks");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          "Start swiping!",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 79, 81, 140)),
        ),
      ),
      const Padding(
        padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
        child: Text(
          "Swipe right if you like a book, swipe left to move onto the next one.",
          style:
              TextStyle(fontSize: 16.0, color: Color.fromARGB(255, 98, 94, 92)),
        ),
      ),
      GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (!swipeDetected) {
            // swipe Right
            if (details.delta.dx < 0) {
              swipeDetected = true;
              //print("LEFT SWIPE");
              setState(() {
                // TO DO: Change here
                int number =
                    int.parse(bookToShow); // Convert the string to an integer
                number++; // Increment the integer
                if (number == numberOfBooks + 1) number = 1;
                bookToShow = number.toString();
                _fetchBookDataByID(bookToShow);
              });
              // Positive velocity means a right swipe
              // swipe Left
            } else if (details.delta.dx > 0) {
              swipeDetected = true;
              //print("RIGHT SWIPE");
              setState(() {
                // TO DO: Change here
                int number =
                    int.parse(bookToShow); // Convert the string to an integer
                number--; // Increment the integer
                if (number == 0) number = numberOfBooks;
                bookToShow = number.toString();
                _fetchBookDataByID(bookToShow);
              });
              // Negative velocity means a left swipe
            }
          }
        },
        onHorizontalDragEnd: (details) {
          swipeDetected = false;
        },
        child: isImageLarge
            ? Center(
                child: Align(
                    alignment: Alignment.center, // Adjust alignment as needed
                    child: Image.asset(
                      currentBook['picture'] != null
                          ? 'lib/assets/images/${currentBook['picture']}'
                          : 'lib/assets/images/1.png',
                      height: 495.0,
                    )),
              )
            : Center(
                child: Align(
                    alignment: Alignment.center, // Adjust alignment as needed
                    child: Image.asset(
                      currentBook['picture'] != null
                          ? 'lib/assets/images/${currentBook['picture']}'
                          : 'lib/assets/images/1.png',
                      height: 300.0,
                    )),
              ),
      ),
      isImageLarge
          ? GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy < 0) {
                  // User swiped up, perform a different action.
                  //print('Swiped Up');
                  setState(() {
                    isImageLarge = false; // Toggle the visibility of the image
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  width: (MediaQuery.of(context).size.width),
                  height: 77, // 75 is not enough
                  child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xffdabfff), width: 3.0),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: ListView(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15.0, top: 8.0),
                                child: Text(
                                  currentBook['title'] ?? 'BookTitle',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 15.0, top: 8.0),
                                child: Row(children: [
                                  Text(
                                    '$bookOwner',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.person, // Use the person icon
                                    size: 25.0, // Adjust the size as needed
                                    color: Color(
                                        0xffdabfff), // Customize the color
                                  ),
                                ]),
                              )
                            ]),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 5.0),
                          child: Row(children: [
                            Icon(
                              Icons.location_on_outlined, // Use the person icon
                              size: 15.0, // Adjust the size as needed
                              color: Color.fromARGB(
                                  255, 88, 158, 228), // Customize the color
                            ),
                            Text(
                              '$kmNumber km away',
                              style: TextStyle(
                                fontSize: 13.0,
                              ),
                            ),
                          ]),
                        ),
                      ])),
                ),
              ))
          : GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  // User swiped down, perform an action.
                  //print('Swiped Down');
                  setState(() {
                    isImageLarge = true; // Toggle the visibility of the image
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  width: (MediaQuery.of(context).size.width),
                  height: (MediaQuery.of(context).size.width) - 250.0,
                  child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xffdabfff), width: 3.0),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: ListView(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15.0, top: 8.0),
                                child: Text(
                                  currentBook['title'] ?? 'BookTitle',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 15.0, top: 8.0),
                                child: Row(children: [
                                  Text(
                                    '$bookOwner',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.person, // Use the person icon
                                    size: 25.0, // Adjust the size as needed
                                    color: Color(
                                        0xffdabfff), // Customize the color
                                  ),
                                ]),
                              )
                            ]),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 5.0),
                          child: Row(children: [
                            Icon(
                              Icons.location_on_outlined, // Use the person icon
                              size: 15.0, // Adjust the size as needed
                              color: Color.fromARGB(
                                  255, 88, 158, 228), // Customize the color
                            ),
                            Text(
                              '$kmNumber km away',
                              style: TextStyle(
                                fontSize: 13.0,
                              ),
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 15.0),
                          child: Text(
                            'Author: ${currentBook['author'] ?? ''}',
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                          child: Text(
                            'Genre: $genreName',
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        Row(children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, top: 8.0),
                            child: Text(
                              'Book Condition:',
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: currentBook['condition'] != null
                                ? currentBook['condition'].toDouble()
                                : 3.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 25.0,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ]),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                          child: Text(
                            'Edition: ${currentBook['edition'] ?? ''}',
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                          child: Text(
                            'ISBN: ${currentBook['isbn'] ?? ''}',
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align the first Text to the top of the second one
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 8.0),
                              child: Text(
                                'Comment: ',
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text in the Column to the start (left)
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 8.0, right: 8.0),
                                    child: Text(
                                      '${currentBook['comment'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      maxLines:
                                          4, // Adjust the number of lines as needed
                                      overflow: TextOverflow
                                          .ellipsis, // Truncate text with ellipsis if it overflows
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ])),
                ),
              ))
    ]));
  }
}
