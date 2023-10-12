import 'package:flutter/material.dart';
import '../models/models.dart';

class PreferencesPage extends StatefulWidget {
  final String id;

  PreferencesPage({required this.id});

  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  bool isLoading = true;
  List<String> genres = [];
  final TextEditingController genreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadFavoriteGenres().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> loadFavoriteGenres() async {
    try {
      final favoriteGenres = await fetchFavoriteGenresById(widget.id);
      print(favoriteGenres);
      setState(() {
        genres = favoriteGenres;
      });
    } catch (error) {
      print('Error fetching genres: $error');
    }
  }

  void modifyGenres() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modify Genres'),
          content: Container(
            height: 300, // Limiting height
            child: ListView.builder(
              itemCount: genres.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(genres[index]),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final List<String> authors = [
    "Jane Austen",
    "Harper Lee",
    "Nicholas Sparks",
    "Saley Rooney",
    "J.D. Salinger"
  ];

  double selectedDistance = 10.0;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Preferences"),
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
                          onTap: modifyGenres,
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
                    Row(
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
                  ],
                ),
              ),

              // Authors section
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
                    InkWell(
                      onTap: () {
                        // Handle modification button press for authors
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Authors",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.edit),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // Build the list of authors
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: authors.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(authors[index]),
                        );
                      },
                    ),
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
