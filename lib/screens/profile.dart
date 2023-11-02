import 'package:flutter/material.dart';
import 'profile_preferences.dart';
import '../models/models.dart';

class Profile extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;

  const Profile({
    Key? key,
    this.name = 'John Doe',
    this.email = 'johndoe@example.com',
    this.imageUrl =
        'https://riverlegacy.org/wp-content/uploads/2021/07/blank-profile-photo.jpeg',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          bottom: 150), // Add a margin to move the expanded widget up
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Profile",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 79, 81, 140)),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                      radius: 50,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    // Add rectangular buttons here with fixed height
                    SizedBox(
                      height: 50, // Set a fixed height for the buttons
                      width: double.infinity, // Make buttons take up full width
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle the "Personal details" button press
                        },
                        child: const Text(
                          "Personal Details",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFABD2FA)), // Set your desired color here
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 50, // Set a fixed height for the buttons
                      width: double.infinity, // Make buttons take up full width
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreferencesPage(id: "1"),
                            ),
                          );
                        },
                        child: const Text(
                          "Preferences",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFABD2FA)), // Set your desired color here
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 50, // Set a fixed height for the buttons
                      width: double.infinity, // Make buttons take up full width
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle the "My Books" button press
                        },
                        child: const Text(
                          "My Books",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFABD2FA)), // Set your desired color here
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
