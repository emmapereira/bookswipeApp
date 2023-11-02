// ignore_for_file: avoid_print

//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class BookInformation {
  final String title;
  final String author;
  final String isbn;
  final String edition;
  final double condition;
  final String comment;
  final DocumentReference genre;
  final String picture;
  final DocumentReference owner;
  final bool swapped;

  BookInformation({
    required this.title,
    required this.author,
    required this.isbn,
    required this.edition,
    required this.condition,
    required this.comment,
    required this.genre,
    required this.picture,
    required this.owner,
    required this.swapped,
  });

  // Convert to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'isbn': isbn,
      'edition': edition,
      'condition': condition,
      'comment': comment,
      'genre': genre,
      'picture': picture,
      'owner': owner,
      'swapped': swapped,
    };
  }
}

Future<void> printUsers() async {
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
Future<List<String>> getGenres() async {
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

Future<DocumentSnapshot> getGenreByName(String genreName) async {
  try {
    // Reference to the "genres" collection
    CollectionReference genresCollection =
        FirebaseFirestore.instance.collection('genres');

    // Query for the genre document with the specified name
    QuerySnapshot querySnapshot =
        await genresCollection.where('name', isEqualTo: genreName).get();

    if (querySnapshot.docs.isNotEmpty) {
      // If a matching document is found, return the first one (assuming genre names are unique)
      return querySnapshot.docs.first;
    } else {
      // No matching document found, return a default genre document with ID 8
      return FirebaseFirestore.instance.collection('genres').doc('8').get();
    }
  } catch (e) {
    print('Error: $e');
    // Return the default genre document with ID 8 in case of an error
    return FirebaseFirestore.instance.collection('genres').doc('8').get();
  }
}

// reading data from Genres table
// Future<List<Map<String, dynamic>>> getBooks() async {
//   List<Map<String, dynamic>> books = [];
//   //List<String> genreNames = [];
//   try {
//     // Reference to the "books" collection
//     CollectionReference booksCollection =
//         FirebaseFirestore.instance.collection('books');

//     // Get all documents in the "genres" collection
//     QuerySnapshot querySnapshot = await booksCollection.get();

//     // Iterate through the documents and print their data
//     querySnapshot.docs.forEach((doc) {
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       books.add(data);
//     });

//     return books; // Return the list of "name" values
//   } catch (e) {
//     print('Error: $e');
//     return []; // Return an empty list in case of an error
//   }
// }


// function to read the favourite genres of the user (to be used for user 1)
Future<List<String>> fetchFavoriteGenresById(String id) async {
  List<String> favoriteGenres = [];

  try {
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(id);
    final userSnapshot = await userDocRef.get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      print("User data for ID $id: $userData");

      if (userData.containsKey('favourite_genres')) {
        // Cast the favorite genres references to a list of DocumentReferences
        List<DocumentReference> genreRefs =
            (userData['favourite_genres'] as List<dynamic>)
                .cast<DocumentReference>();
        List<String> genreIds = genreRefs.map((ref) => ref.id).toList();

        // Fetch all genres in a single query
        final genresSnapshot = await FirebaseFirestore.instance
            .collection('genres')
            .where(FieldPath.documentId, whereIn: genreIds)
            .get();

        for (var genreDoc in genresSnapshot.docs) {
          final genreData = genreDoc.data() as Map<String, dynamic>;
          if (genreData.containsKey('name')) {
            favoriteGenres.add(genreData['name']);
          }
        }
      } else {
        print("User with ID $id does not have 'favourite_genres' field.");
      }
    } else {
      print("No user found with ID $id");
    }
  } catch (e) {
    // Handle any errors that occur during the fetch
    print("Error fetching user data: $e");
  }

  return favoriteGenres;
}

// Function to write a timestamp to the database
Future<void> addGenre(String genreName) async {
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

// Function to write a book to the database
Future<void> addBook(BookInformation bookInfo, String bookId) async {
  try {
    CollectionReference booksCollection =
        FirebaseFirestore.instance.collection('books');
    DocumentReference docRef =
        booksCollection.doc(bookId); // Set the specific document ID
    await docRef.set(bookInfo.toMap());
    print('New book added to Firestore with ID: ${docRef.id}');
  } catch (e) {
    print('Error adding a new book: $e');
  }
}

Future<Map<String, dynamic>?> getBookById(String bookId) async {
  try {
    // Reference to the Firestore collection 'books' and the specific document by ID
    DocumentSnapshot bookDoc =
        await FirebaseFirestore.instance.collection('books').doc(bookId).get();

    if (bookDoc.exists) {
      // The document exists, you can access its data
      Map<String, dynamic> bookData = bookDoc.data() as Map<String, dynamic>;
      //print('User Data: $bookData');
      return bookData;
      // Use the book data in your Flutter app
      // For example, set it in a state variable or display it in a widget
    } else {
      print('User document with ID $bookId does not exist.');
      return null;
      // Handle the case where the document does not exist
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return null;
    // Handle any errors that occur during the fetch
  }
}

String getKmNumber() {
  final random = Random();
  int r = random.nextInt(10) + 1;
  String s = r.toString();
  return s;
}

Future<String?> getGenreById(String genreId) async {
  try {
    DocumentSnapshot genreDoc = await FirebaseFirestore.instance
        .collection('genres')
        .doc(genreId)
        .get();

    if (genreDoc.exists) {
      Map<String, dynamic> genreData = genreDoc.data() as Map<String, dynamic>;
      //print('User Data: $genreData');

      if (genreData.containsKey("name")) {
        String name = genreData["name"];
        //print('name: $name');

        return name;
      } else {
        print("Name attribute not found in document ${genreDoc.id}");
      }
      // Use the genre data in your Flutter app
      // For example, set it in a state variable or display it in a widget
    } else {
      print('User document with ID $genreId does not exist.');
      return '';
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return '';
  }
  return null;
}

Future<String?> getUserNameById(String userId) async {
  try {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      //print('User Data: $userData');

      if (userData.containsKey("name")) {
        String name = userData["name"];
        //print('name: $name');

        return name;
      } else {
        print("Name attribute not found in document ${userDoc.id}");
      }
      // Use the user data in your Flutter app
      // For example, set it in a state variable or display it in a widget
    } else {
      print('User document with ID $userId does not exist.');
      return '';
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return '';
  }
  return null;
}

Future<List<Map<String, dynamic>>> getMatches() async {
  List<Map<String, dynamic>> matches = [];
  try {
    // Reference to the "matches" collection
    CollectionReference matchesCollection =
        FirebaseFirestore.instance.collection('matches');

    // Get all documents in the "matches" collection
    QuerySnapshot querySnapshot = await matchesCollection.get();

    // Iterate through the documents and print their data
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      matches.add(data);
    });

    return matches;
  } catch (e) {
    print('Error: $e');
    return []; // Return an empty list in case of an error
  }
}

Future<List<Map<String, dynamic>>> getBooks() async {
  List<Map<String, dynamic>> books = [];
  try {
    // Reference to the "books" collection
    CollectionReference booksCollection =
        FirebaseFirestore.instance.collection('books');

    // Get all documents in the "books" collection
    QuerySnapshot querySnapshot = await booksCollection.get();

    // Iterate through the documents and print their data
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      books.add(data);
    });

    return books;
  } catch (e) {
    print('Error: $e');
    return []; // Return an empty list in case of an error
  }
}

Future<String?> fetchBookNameByID(String bookId) async {
  try {
    DocumentSnapshot bookDoc =
        await FirebaseFirestore.instance.collection('books').doc(bookId).get();

    if (bookDoc.exists) {
      Map<String, dynamic> bookData = bookDoc.data() as Map<String, dynamic>;
      //print('Book Data: $bookData');

      if (bookData.containsKey("title")) {
        String title = bookData["title"];

        return title;
      } else {
        print("Name attribute not found in document ${bookDoc.id}");
      }
      // Use the user data in your Flutter app
      // For example, set it in a state variable or display it in a widget
    } else {
      print('Book document with ID $bookId does not exist.');
      return '';
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return '';
  }
  return null;
}

Future<String?> fetchGenreNameByID(String genreId) async {
  try {
    DocumentSnapshot genreDoc = await FirebaseFirestore.instance
        .collection('genres')
        .doc(genreId)
        .get();

    if (genreDoc.exists) {
      Map<String, dynamic> genreData = genreDoc.data() as Map<String, dynamic>;
      //print('User Data: $genreData');

      if (genreData.containsKey("name")) {
        String name = genreData["name"];
        //print('name: $name');

        return name;
      } else {
        print("Name attribute not found in document ${genreDoc.id}");
      }
      // Use the genre data in your Flutter app
      // For example, set it in a state variable or display it in a widget
    } else {
      print('User document with ID $genreId does not exist.');
      return '';
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return '';
  }
  return null;
}

Future<List<String>> fetchFavouriteAuthors(String userId) async {
  try {
    // Fetch the user document from Firestore
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // If the user has favourite authors, return them as a list
      if (userData.containsKey("favourite_authors")) {
        List<String> authors = List<String>.from(userData["favourite_authors"]);
        return authors;
      } else {
        print("favourite_authors attribute not found for user ${userDoc.id}");
        return [];
      }
    } else {
      print('User document with ID $userId does not exist.');
      return [];
    }
  } catch (e) {
    print('Error fetching favourite authors: $e');
    return [];
  }
}

Future<String?> fetchBookPictureByID(String bookId) async {
  try {
    DocumentSnapshot bookDoc =
        await FirebaseFirestore.instance.collection('books').doc(bookId).get();

    if (bookDoc.exists) {
      Map<String, dynamic> bookData = bookDoc.data() as Map<String, dynamic>;
      //print('Book Data: $bookData');

      if (bookData.containsKey("picture")) {
        String picture = bookData["picture"];

        return picture;
      } else {
        print("Picture attribute not found in document ${bookDoc.id}");
      }
      // Use the user data in your Flutter app
      // For example, set it in a state variable or display it in a widget
    } else {
      print('Book document with ID $bookId does not exist.');
      return '';
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return '';
  }
  return null;
}

Future<String?> fetchUserNameByID(String userId) async {
  try {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      //print('User Data: $userData');

      if (userData.containsKey("name")) {
        String name = userData["name"];
        //print('name: $name');

        return name;
      } else {
        print("Name attribute not found in document ${userDoc.id}");
      }
      // Use the user data in your Flutter app
      // For example, set it in a state variable or display it in a widget
    } else {
      print('User document with ID $userId does not exist.');
      return '';
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return '';
  }
  return null;
}

Future<void> deleteFavoriteGenreFromUser(
    String genreName, String userId) async {
  try {
    // Reference to the specific user document
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Find the genreId based on the genreName
    QuerySnapshot genreQuery = await FirebaseFirestore.instance
        .collection('genres')
        .where('name', isEqualTo: genreName)
        .get();

    // Check if the genre exists
    if (genreQuery.docs.isEmpty) {
      print('No genre found with the name: $genreName');
      return;
    }

    String genreId = genreQuery.docs.first.id;
    DocumentReference genreRef = FirebaseFirestore.instance
        .collection('genres')
        .doc(genreId); // Reference to the genre

    // Use a transaction to safely update the favorite genres
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await transaction.get(userDocRef);
      if (userSnapshot.exists) {
        List<dynamic> favoriteGenres =
            (userSnapshot.data() as Map<String, dynamic>)['favourite_genres'] ??
                [];

        // Remove the genre reference from the list if it exists
        favoriteGenres.removeWhere(
            (element) => (element as DocumentReference).id == genreRef.id);

        // Update the user document with the modified list
        transaction.update(userDocRef, {'favourite_genres': favoriteGenres});
      }
    });

    print(
        'Genre with name "$genreName" (ID: $genreId) removed from user $userId favorites.');
  } catch (e) {
    print('Error removing favorite genre: $e');
  }
}

Future<void> addFavoriteGenreToUser(String genreName, String userId) async {
  try {
    // Reference to the specific user document
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Find the genreId based on the genreName
    QuerySnapshot genreQuery = await FirebaseFirestore.instance
        .collection('genres')
        .where('name', isEqualTo: genreName)
        .get();

    // Check if the genre exists
    if (genreQuery.docs.isEmpty) {
      print('No genre found with the name: $genreName');
      return;
    }

    DocumentReference genreRef = FirebaseFirestore.instance
        .collection('genres')
        .doc(genreQuery.docs.first.id); // Reference to the genre

    // Use a transaction to safely update the favorite genres
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await transaction.get(userDocRef);
      if (userSnapshot.exists) {
        List<dynamic> favoriteGenres =
            (userSnapshot.data() as Map<String, dynamic>)['favourite_genres'] ??
                [];

        // Add the genre reference to the list if it doesn't already exist
        if (!favoriteGenres.contains(genreRef)) {
          favoriteGenres.add(genreRef);
        }

        // Update the user document with the modified list
        transaction.update(userDocRef, {'favourite_genres': favoriteGenres});
      }
    });

    print('Genre "$genreName" added to user $userId favorites.');
  } catch (e) {
    print('Error adding favorite genre: $e');
  }
}

Future<List<String>> fetchAllGenres() async {
  try {
    QuerySnapshot genreQuery =
        await FirebaseFirestore.instance.collection('genres').get();
    return genreQuery.docs.map((doc) => doc.get('name') as String).toList();
  } catch (e) {
    print('Error fetching all genres: $e');
    return [];
  }
}

Future<void> addFavoriteAuthorToUser(String authorName, String userId) async {
  try {
    // Reference to the specific user document
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Use a transaction to safely update the favorite authors
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await transaction.get(userDocRef);
      if (userSnapshot.exists) {
        List<dynamic> favoriteAuthors = (userSnapshot.data()
                as Map<String, dynamic>)['favourite_authors'] ??
            [];

        // Add the author name to the list if it doesn't already exist
        if (!favoriteAuthors.contains(authorName)) {
          favoriteAuthors.add(authorName);
        }

        // Update the user document with the modified list
        transaction.update(userDocRef, {'favourite_authors': favoriteAuthors});
      }
    });

    print('Author "$authorName" added to user $userId favorites.');
  } catch (e) {
    print('Error adding favorite author: $e');
  }
}

Future<void> deleteFavoriteAuthorFromUser(
    String authorName, String userId) async {
  try {
    // Reference to the specific user document
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Use a transaction to safely update the favorite authors
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await transaction.get(userDocRef);
      if (userSnapshot.exists) {
        List<dynamic> favoriteAuthors = (userSnapshot.data()
                as Map<String, dynamic>)['favourite_authors'] ??
            [];

        // Remove the author name from the list if it exists
        favoriteAuthors.remove(authorName);

        // Update the user document with the modified list
        transaction.update(userDocRef, {'favourite_authors': favoriteAuthors});
      }
    });

    print('Author "$authorName" removed from user $userId favorites.');
  } catch (e) {
    print('Error removing favorite author: $e');
  }
}

Future<String?> fetchUserNameByBookID(String bookId) async {
  try {
    DocumentSnapshot bookDoc =
        await FirebaseFirestore.instance.collection('books').doc(bookId).get();

    if (bookDoc.exists) {
      Map<String, dynamic> bookData = bookDoc.data() as Map<String, dynamic>;

      if (bookData.containsKey("owner")) {
        DocumentReference<Map<String, dynamic>> ownerRef = bookData["owner"];
        String userId = ownerRef.id;

        String userName = await fetchUserNameByID(userId) as String;

        return userName;
      } else {
        print("Name attribute not found in document ${bookDoc.id}");
      }
      // Use the user data in your Flutter app
      // For example, set it in a state variable or display it in a widget
    } else {
      print('User document with ID $bookId does not exist.');
      return '';
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return '';
  }
  return null;
}

Future<String?> fetchGenreNameByID(String genreId) async {
  try {
    DocumentSnapshot genreDoc = await FirebaseFirestore.instance
        .collection('genres')
        .doc(genreId)
        .get();

    if (genreDoc.exists) {
      Map<String, dynamic> genreData = genreDoc.data() as Map<String, dynamic>;
      //print('User Data: $genreData');

      if (genreData.containsKey("name")) {
        String name = genreData["name"];
        //print('name: $name');

        return name;
      } else {
        print("Name attribute not found in document ${genreDoc.id}");
      }
      // Use the genre data in your Flutter app
      // For example, set it in a state variable or display it in a widget
    } else {
      print('User document with ID $genreId does not exist.');
      return '';
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return '';
  }
  return null;
}

Future<String?> fetchUserNameByID(String userId) async {
  try {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      //print('User Data: $userData');

      if (userData.containsKey("name")) {
        String name = userData["name"];
        //print('name: $name');

        return name;
      } else {
        print("Name attribute not found in document ${userDoc.id}");
      }
      // Use the user data in your Flutter app
      // For example, set it in a state variable or display it in a widget
    } else {
      print('User document with ID $userId does not exist.');
      return '';
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return '';
  }
  return null;
}
