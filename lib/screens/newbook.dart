// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewBook extends StatefulWidget {
  @override
  _NewBookState createState() => _NewBookState();

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class BookDetails {
  final String title;
  final List<String> authors;

  BookDetails({
    required this.title,
    required this.authors,
  });
}

Future<BookDetails?> getBookDetails(String isbn) async {
  final url = Uri.parse(
      'https://openlibrary.org/api/books?bibkeys=ISBN:$isbn&format=json&jscmd=data');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);

    if (jsonResponse.isNotEmpty) {
      final bookDetails = jsonResponse['ISBN:$isbn'];

      // Extract book details as needed
      final title = bookDetails['title'];
      final authors = (bookDetails['authors'] as List<dynamic>)
          .map((author) => author['name'].toString())
          .toList();

      // Create a BookDetails object to return the data
      final book = BookDetails(
        title: title,
        authors: authors,
      );

      return book;
    } else {
      print('No book found for ISBN: $isbn');
      return null;
    }
  } else {
    throw Exception('Failed to load book details');
  }
}

class _NewBookState extends State<NewBook> {
  late List<String> genreNames = [];
  final isbnController = TextEditingController();
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final editionController = TextEditingController();
  final commentController = TextEditingController();
  String? selectedGenre;
  bool isImageVisible = false;
  late String booksLength = "";
  double userRating = 0.0;
  DocumentReference selectedGenreRef =
      FirebaseFirestore.instance.collection('genres').doc('8');

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed to prevent memory leaks
    isbnController.dispose();
    titleController.dispose();
    authorController.dispose();
    super.dispose();
  }

  void handleISBNInput() {
    final isbn = isbnController.text;
    if (isbn.isNotEmpty) {
      getBookDetails(isbn).then((bookDetails) {
        setState(() {
          if (bookDetails != null) {
            // Update the controllers with book details
            titleController.text = bookDetails.title;
            authorController.text = bookDetails.authors.join(", ");
            // ...
          } else {
            // Handle the case when no book is found
            // Clear or update controllers as needed
          }
        });
      }).catchError((error) {
        // Handle any errors that occur during the API call
        print('Error fetching book details: $error');
      });
    }
  }

  Future<void> _getGenres() async {
    // Perform your asynchronous operations here
    genreNames = await getGenres();
    // Use setState to trigger a rebuild with the fetched data
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> _getBooksNumber() async {
    // Perform your asynchronous operations here
    List<Map<String, dynamic>> books = await getBooks();
    int length = books.length + 1;
    // Use setState to trigger a rebuild with the fetched data
    setState(() {
      booksLength = length.toString();
    });
    return books;
  }

// function to add book calling the model
  Future<void> _addBook(BookInformation book) async {
    String bookId = booksLength;
    await addBook(book, bookId);
  }

  // function to get a genre by the name
  Future<void> _getGenreByName(String genreName) async {
    final genreSnapshot = await getGenreByName(genreName);
    setState(() {
      selectedGenreRef = genreSnapshot.reference;
    });
  }

// will call this function from the save button soon, need to not hard code some values!
//i think it should not be async???
  Future<void> addBookToFirestore() async {
    final isbn = isbnController.text;
    final author = authorController.text;
    final title = titleController.text;
    final edition = editionController.text;
    final comment = commentController.text;
    final condition = userRating;
    final genreRef = selectedGenreRef;
    final userRef = FirebaseFirestore.instance.collection('users').doc("1");

    // Create a new BookInformation object with the extracted data
    BookInformation newBook = BookInformation(
      title: title,
      author: author,
      isbn: isbn,
      edition: edition,
      condition: condition,
      comment: comment,
      genre: genreRef,
      picture: booksLength,
      owner: userRef,
      swapped: false,
    );

    _addBook(newBook);
  }

  @override
  void initState() {
    super.initState();
    _getGenres();
    _getBooksNumber();
    //getBookDetails("9780451499066");
  }

  //let me merge!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          color: Color.fromARGB(255, 79, 81, 140),
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Implement the functionality to navigate back
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Add a new book",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 79, 81, 140),
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Upload (To be implemented later)
            // Upload a Picture Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[200], // Background color
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: GestureDetector(
                onTap: () {
                  // when user clicks on "upload a picture"
                  setState(() {
                    isImageVisible =
                        !isImageVisible; // Toggle the visibility of the image
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(3.0),
                  height: 120.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Background color
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: isImageVisible
                      ? Image.asset(
                          booksLength != ""
                              ? 'lib/assets/images/$booksLength.png'
                              : 'lib/assets/images/1.png',
                          height: 120.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const <Widget>[
                            Text(
                              "Upload a Picture",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            SizedBox(height: 10),
                            // You can add image upload functionality here later
                          ],
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20), // Add spacing

            // ISBN
            const Text(
              "ISBN",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              // ISBN input field
              controller: isbnController,
              onFieldSubmitted: (_) => handleISBNInput(),
              decoration: const InputDecoration(
                hintText: "Enter ISBN",
              ),
            ),
            const SizedBox(height: 10), // Add spacing

            // Title
            const Text(
              "Title",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: titleController,
              readOnly: true, // To make it non-editable
              decoration: const InputDecoration(
                hintText: "Auto-filled later",
              ),
            ),
            const SizedBox(height: 10), // Add spacing

            // Author
            const Text(
              "Author",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: authorController,
              readOnly: true, // To make it non-editable
              decoration: const InputDecoration(
                hintText: "Auto-filled later",
              ),
            ),
            const SizedBox(height: 10), // Add spacing
            // Edition
            const Text(
              "Edition",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: editionController,
              readOnly: false, // To make it editable
              decoration: const InputDecoration(
                hintText: "Book edition",
              ),
            ),
            const SizedBox(height: 10), // Add spacing

            // Genre Dropdown
            const Text(
              "Genre",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              // Genre dropdown loads them from db
              items: genreNames.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Handle dropdown selection
                setState(() {
                  selectedGenre = newValue; // Update the selected genre
                });

                if (newValue != null) {
                  // Fetch the genre reference based on the selected value
                  _getGenreByName(newValue);
                }
              },
              value: selectedGenre,
              hint: const Text("Select Genre"),
              dropdownColor: Colors.white,
              focusColor: Colors.transparent,
            ),
            const SizedBox(height: 10), // Add spacing

            // Condition (Star Rating)
            const Text(
              "Condition",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            //5 stars widget to rate the book
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                // Update the userRating controller with the selected rating
                setState(() {
                  userRating = rating;
                });
              },
            ),
            const SizedBox(height: 10), // Add spacing

            // Comment
            const Text(
              "Comment",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: commentController,
              maxLines: 3, // Allow multiple lines
              decoration: const InputDecoration(
                hintText: "Enter your comment...",
              ),
            ),

            const SizedBox(height: 20), // Add spacing

            // Save button
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // adding the book to the database
                      addBookToFirestore();
                    },
                    child: const Text("Save"),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(
                          120, 50)), // Adjust the width and height as needed
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
