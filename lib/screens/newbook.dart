import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class NewBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add a new book",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 79, 81, 140)),
            ),
            // Image Upload (To be implemented later)
            // Upload a Picture Box
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[200], // Background color
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload a Picture",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10), // Add spacing
                  // You can add image upload functionality here later
                ],
              ),
            ),

            SizedBox(height: 20), // Add spacing

            // ISBN
            Text(
              "ISBN",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              // ISBN input field
              decoration: InputDecoration(
                hintText: "Enter ISBN",
              ),
            ),
            SizedBox(height: 10), // Add spacing

            // Title
            Text(
              "Title",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              // Title input field (auto-filled later)
              readOnly: true, // To make it non-editable
              decoration: InputDecoration(
                hintText: "Auto-filled later",
              ),
            ),
            SizedBox(height: 10), // Add spacing

            // Edition
            Text(
              "Edition",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              // Edition input field (auto-filled later)
              readOnly: true, // To make it non-editable
              decoration: InputDecoration(
                hintText: "Auto-filled later",
              ),
            ),
            SizedBox(height: 10), // Add spacing

            // Author
            Text(
              "Author",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              // Author input field (auto-filled later)
              readOnly: true, // To make it non-editable
              decoration: InputDecoration(
                hintText: "Auto-filled later",
              ),
            ),
            SizedBox(height: 10), // Add spacing

            // Genre Dropdown
            Text(
              "Genre",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              // Genre dropdown (you can replace the items with your genres)
              items: ["Genre 1", "Genre 2", "Genre 3"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Handle dropdown selection
              },
              hint: Text("Select Genre"),
            ),
            SizedBox(height: 10), // Add spacing

            // Condition (Star Rating)
            Text(
              "Condition",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            //5 stars widget to rate the book
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                //rating contains the rating value from 1 to 5, also allows half values
                print(rating);
              },
            ),
            SizedBox(height: 10), // Add spacing

            // Comment
            Text(
              "Comment",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              // Comment input field
              maxLines: 3, // Allow multiple lines
              decoration: InputDecoration(
                hintText: "Enter your comment...",
              ),
            ),

            SizedBox(height: 20), // Add spacing

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
                    child: Text("Save"),
                  ),
                  SizedBox(width: 10), // Add spacing
                  ElevatedButton(
                    onPressed: () {
                      // Add cancel functionality
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.red), // Red color for cancel button
                    ),
                    child: Text("Cancel"),
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
