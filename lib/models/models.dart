// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> readUserData() async {
  print("holaa readuserdata");

  try {
    // Reference to the "users" collection
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    // Get all documents in the "users" collection
    QuerySnapshot querySnapshot = await usersCollection.get();

    // Iterate through the documents and print their data
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      print("Document ID: ${doc.id}");
      print("Data: $data");
    });
  } catch (e) {
    print('Error: $e');
  }
}

// reading data from Genres table
Future<void> readGenreData() async {
  print("READING GENRES");

  try {
    // Reference to the "genres" collection
    CollectionReference genresCollection =
        FirebaseFirestore.instance.collection('genres');

    // Get all documents in the "genres" collection
    QuerySnapshot querySnapshot = await genresCollection.get();

    // Iterate through the documents and print their data
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      print("Document ID: ${doc.id}");
      print("Data: $data");
    });
  } catch (e) {
    print('Error: $e');
  }
}

// reading data from Genres table
Future<List<String>> loadGenres() async {
  List<String> genreNames = [];
  try {
    // Reference to the "genres" collection
    CollectionReference genresCollection =
        FirebaseFirestore.instance.collection('genres');

    // Get all documents in the "genres" collection
    QuerySnapshot querySnapshot = await genresCollection.get();

    // Iterate through the documents and print their data
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data.containsKey("name")) {
        String name = data["name"];

        genreNames.add(name);
      } else {
        print("Name attribute not found in document ${doc.id}");
      }
    });

    return genreNames; // Return the list of "name" values
  } catch (e) {
    print('Error: $e');
    return []; // Return an empty list in case of an error
  }
}

// Function to write a timestamp to the database
Future<void> writeNewGenre(String genreName) async {
  print("trying to add a new genre");

  try {
    // Reference to the "genres" collection
    CollectionReference genresCollection =
        FirebaseFirestore.instance.collection('genres');

    QuerySnapshot querySnapshot = await genresCollection.get();

    int customId = querySnapshot.size + 1;
    // Set the document with the custom ID and data
    await genresCollection.doc(customId.toString()).set({
      'name': genreName,
    });

    print(
        'New genre "$genreName" added to Firestore with custom ID "$customId".');
  } catch (e) {
    print('Error adding new genre: $e');
  }
}
