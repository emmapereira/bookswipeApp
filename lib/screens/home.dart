// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, sized_box_for_whitespace, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/models.dart';
import 'dart:async';

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
  late bool showLiked = false;
  late bool showDisliked = false;
  bool isFetchingBookData = false;

  void _toggleImageSize() {
    setState(() {
      isImageLarge = !isImageLarge;
    });
  }

  Future<void> _fetchBookDataByID(String id) async {
    try {
      // Fetch the book data using the getBookById function
      final Map<String, dynamic>? bookData = await getBookById(id);

      // If book data is found
      if (bookData != null) {
        // Fetch additional details like genre and owner if they exist
        String fetchedGenreName = '';
        String fetchedBookOwner = '';

        if (bookData['genre'] != null) {
          DocumentReference<Map<String, dynamic>> genreRef = bookData['genre'];
          String genreId = genreRef.id;
          fetchedGenreName = await getGenreById(genreId) as String;
        }

        if (bookData['owner'] != null) {
          DocumentReference<Map<String, dynamic>> userRef = bookData['owner'];
          String userId = userRef.id;
          fetchedBookOwner = await getUserNameById(userId) as String;
        }

        // Update the state with the fetched data
        setState(() {
          currentBook = bookData;
          genreName = fetchedGenreName;
          bookOwner = fetchedBookOwner;
          kmNumber =
              getKmNumber(); // Assuming this function returns a string for kmNumber
        });
      } else {
        print('Book with ID $id not found');
        // Handle the case where no book is found
      }
    } catch (e) {
      print('Error fetching book data: $e');
      // Handle any exceptions during fetch
    } finally {
      // Reset the flags in finally block to ensure they are reset whether the fetch is successful or not
      setState(() {
        swipeDetected = false;
        isFetchingBookData = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isImageLarge = true;
    // TO DO: List to contain only books filtered for this user
    bookToShow = '1';
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
    Color tagColor = Colors.grey;
    if (currentBook['genre'].id == "1") {
      tagColor = Colors.pink;
    } else if (currentBook['genre'].id == "2") {
      tagColor = Colors.orange;
    } else if (currentBook['genre'].id == "3") {
      tagColor = Colors.green;
    } else if (currentBook['genre'].id == "4") {
      tagColor = Colors.blue;
    } else if (currentBook['genre'].id == "5") {
      tagColor = Colors.brown;
    } else if (currentBook['genre'].id == "6") {
      tagColor = Colors.red;
    } else if (currentBook['genre'].id == "7") {
      tagColor = Colors.yellow;
    } else if (currentBook['genre'].id == "8") {
      tagColor = Colors.purple;
    }

    return Scaffold(
        body: Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            style: TextStyle(
                fontSize: 16.0, color: Color.fromARGB(255, 98, 94, 92)),
          ),
        ),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (!swipeDetected && !isFetchingBookData) {
              swipeDetected = true;
              isFetchingBookData = true;

              // Assuming book IDs are sequential and start from 1
              int currentId = int.tryParse(bookToShow) ?? 0;
              currentId = (currentId % numberOfBooks) +
                  1; // Increment to get the next book ID
              bookToShow = currentId.toString();

              setState(() {
                showDisliked = details.delta.dx > 0;
                showLiked = details.delta.dx < 0;
              });

              _fetchBookDataByID(bookToShow); // Fetch data for the new book

              Timer(Duration(milliseconds: 500), () {
                setState(() {
                  showLiked = false;
                  showDisliked = false;
                  swipeDetected = false;
                });
              });
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
                      isImageLarge =
                          false; // Toggle the visibility of the image
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
                                Row(
                                  // Wrap title and button in another Row
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, top: 8.0),
                                      child: Text(
                                        currentBook['title'] ?? 'BookTitle',
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.expand_less),
                                      onPressed: _toggleImageSize,
                                    ),
                                  ],
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
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 5.0),
                            child: Row(children: [
                              Icon(
                                Icons
                                    .location_on_outlined, // Use the person icon
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
                                Row(
                                  // Wrap title and button in another Row
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, top: 8.0),
                                      child: Text(
                                        currentBook['title'] ?? 'BookTitle',
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.expand_more),
                                      onPressed: _toggleImageSize,
                                    ),
                                  ],
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
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 5.0),
                            child: Row(children: [
                              Icon(
                                Icons
                                    .location_on_outlined, // Use the person icon
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
                            padding:
                                const EdgeInsets.only(left: 20.0, top: 15.0),
                            child: Text(
                              'Author: ${currentBook['author'] ?? ''}',
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
                                'Genre:',
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 3.0, top: 8.0),
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: tagColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text(
                                  '$genreName',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                  ),
                                ),
                              ),
                            ),
                          ]),
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
                              itemPadding: EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                          ]),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, top: 8.0),
                            child: Text(
                              'Edition: ${currentBook['edition'] ?? ''}',
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, top: 8.0),
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
      ]),
      if (showLiked)
        Center(
          child: Icon(
            Icons.favorite,
            color: Colors.green,
            size: 100.0,
          ),
        ),
      if (showDisliked)
        Center(
          child: Icon(
            Icons.close,
            color: Colors.red,
            size: 100.0,
          ),
        ),
    ]));
  }
}
