import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<String>> fetchAuthors(String query) async {
  final response = await http
      .get(Uri.parse('http://openlibrary.org/search/authors.json?q=$query'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List<dynamic> authors = data['docs'];
    return authors.map((author) => author['name'] as String).toList();
  } else {
    throw Exception('Failed to load authors');
  }
}

class PreferencesPage extends StatefulWidget {
  final String id;

  PreferencesPage({required this.id});

  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  bool isLoading = true;
  List<String> genres = [];
  List<String> authors = [];

  final TextEditingController genreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.wait([loadFavoriteGenres(), loadFavoriteAuthors()]).then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> loadFavoriteGenres() async {
    try {
      final favoriteGenres = await fetchFavoriteGenresById(widget.id);
      setState(() {
        genres = favoriteGenres;
      });
    } catch (error) {
      print('Error fetching genres: $error');
    }
  }

  Future<void> loadFavoriteAuthors() async {
    try {
      final favoriteAuthors = await fetchFavouriteAuthors(widget.id);
      setState(() {
        authors = favoriteAuthors;
      });
    } catch (error) {
      print('Error fetching authors: $error');
    }
  }

  void modifyGenres(BuildContext context, String userId) async {
    // ... (rest of the code remains the same)
    String? selectedGenre;
    List<String> currentGenres = await fetchFavoriteGenresById(userId);
    List<String> availableGenres = (await fetchAllGenres())
        .where((genre) => !currentGenres.contains(genre))
        .toList();
    TextEditingController genreController = TextEditingController();
    ValueNotifier<String?> dropdownValueNotifier = ValueNotifier<String?>(null);

    final bool? changesMade = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Modify Genres'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Current Favorite Genres:'),
                  ...currentGenres.map((genre) => ListTile(
                        title: Text(genre),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await deleteFavoriteGenreFromUser(genre, userId);
                            setState(() {
                              currentGenres.remove(genre);
                            });
                            // Removed the Navigator.pop line here
                          },
                        ),
                      )),
                  ValueListenableBuilder<String?>(
                    valueListenable: dropdownValueNotifier,
                    builder: (context, value, _) {
                      return DropdownButton<String>(
                        value: value,
                        items: availableGenres
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text("Select a genre"),
                        onChanged: (String? newValue) {
                          dropdownValueNotifier.value = newValue;
                        },
                      );
                    },
                  ),
                ],
              ),
              // ... (rest of the dialog content remains the same)
              actions: <Widget>[
                TextButton(
                  child: Text('Add Genre'),
                  onPressed: () async {
                    if (dropdownValueNotifier.value != null &&
                        dropdownValueNotifier.value!.isNotEmpty) {
                      await addFavoriteGenreToUser(
                          dropdownValueNotifier.value!, userId);
                      setState(() {
                        currentGenres.add(dropdownValueNotifier.value!);
                        availableGenres.remove(dropdownValueNotifier
                            .value); // Remove the added genre from the dropdown list
                      });
                      dropdownValueNotifier.value =
                          null; // Reset the dropdown selection
                    }
                  },
                ),
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Return true to indicate changes were made
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (changesMade == true) {
      loadFavoriteGenres();
    }
  }

  void modifyAuthors(BuildContext context, String userId) async {
    TextEditingController authorController = TextEditingController();
    List<String> currentAuthors = await fetchFavouriteAuthors(userId);

    final bool? changesMade = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Modify Authors'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Current Favorite Authors:'),
                  ...currentAuthors.map((author) => ListTile(
                        title: Text(author),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await deleteFavoriteAuthorFromUser(author, userId);
                            setState(() {
                              currentAuthors.remove(author);
                            });
                          },
                        ),
                      )),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) async {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return await fetchAuthors(textEditingValue.text);
                    },
                    onSelected: (String selection) {
                      authorController.text = selection;
                    },
                    fieldViewBuilder: (context, textEditingController,
                        focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Add New Author',
                          hintText: 'Enter author name',
                        ),
                      );
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Add Author'),
                  onPressed: () async {
                    if (authorController.text.isNotEmpty) {
                      await addFavoriteAuthorToUser(
                          authorController.text, userId);
                      setState(() {
                        currentAuthors.add(authorController.text);
                      });
                      authorController.clear();
                    }
                  },
                ),
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (changesMade == true) {
      loadFavoriteAuthors(); // Refresh the UI after making changes.
    }
  }

  double selectedDistance = 10.0;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
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
          "Preferences",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Genres section
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Genres",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () => modifyGenres(context, widget.id),
                          child: Icon(Icons.edit),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: genres.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(genres[index]),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Max Distance section
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Lighter color
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Max Distance",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    // Add a Slider for max distance selection
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Color(
                            0xFFABD2FA), // Change the color of the active track.
                        inactiveTrackColor: Color(0xffD3D3D3),
                        thumbColor: Color(
                            0xFFABD2FA), // Change the color of the inactive track.
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${selectedDistance.toStringAsFixed(0)} km",
                            style: TextStyle(fontSize: 16),
                          ),
                          Slider(
                            value: selectedDistance,
                            onChanged: (newValue) {
                              setState(() {
                                selectedDistance = newValue;
                              });
                            },
                            min: 0,
                            max: 100,
                            divisions: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              // Authors section
              // Favourite Authors section
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Authors",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () => modifyAuthors(context, widget.id),
                          child: Icon(Icons.edit),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    authors.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: authors.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(authors[index]),
                              );
                            },
                          )
                        : Text("No favourite authors found."),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
