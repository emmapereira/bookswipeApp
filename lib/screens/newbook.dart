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
  String? selectedGenre;
  bool isImageVisible = false;

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

  Future<void> _loadGenres() async {
    // Perform your asynchronous operations here
    genreNames = await loadGenres();
    // Use setState to trigger a rebuild with the fetched data
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadGenres();
    //getBookDetails("9780804172707");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
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
                  padding: const EdgeInsets.all(20.0),
                  height: 120.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Background color
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: isImageVisible
                      ? Image.asset(
                          'lib/assets/images/picture1.jpg',
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
                //rating contains the rating value from 1 to 5, also allows half values
                print(rating);
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
              // Comment input field
              maxLines: 3, // Allow multiple lines
              decoration: const InputDecoration(
                hintText: "Enter your comment...",
              ),
            ),

            const SizedBox(height: 20), // Add spacing

            // Save and Cancel Buttons
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add save functionality
                    },
                    child: const Text("Save"),
                  ),
                  const SizedBox(width: 10), // Add spacing
                  ElevatedButton(
                    onPressed: () {
                      // Add cancel functionality
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.red), // Red color for cancel button
                    ),
                    child: const Text("Cancel"),
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
