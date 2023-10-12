// ignore_for_file: prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:bookswipe/models/models.dart';
import 'package:flutter/material.dart';

class Matches extends StatefulWidget {
  @override
  _MatchesState createState() => _MatchesState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Matches(),
    );
  }
}

class _MatchesState extends State<Matches> {
  late List<Map<String, dynamic>> allMatches = [];

  Future<void> _getMatches() async {
    try {
      // Perform your asynchronous operations here
      final matches = await getMatches();
      //print(matches);
      setState(() {
        allMatches = matches;
      });
    } catch (e) {
      print('Error fetching book data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          "My book matches",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 79, 81, 140)),
        ),
      ),
      const Divider(),
      // ListView.builder(
      //     scrollDirection: Axis.vertical,
      //     shrinkWrap: true,
      //     itemCount: allMatches.length,
      //     itemBuilder: (context, index) {
      //       final item = allMatches[index];

      //       return Column(
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.only(left: 9.0),
      //             child: Row(
      //               children: [
      //                 Row(
      //                   children: [
      //                     Container(
      //                       width: 80,
      //                       height: 80,
      //                       decoration: BoxDecoration(
      //                         shape: BoxShape.circle,
      //                         border: Border.all(
      //                           color: Colors.green, // Border color
      //                           width: 4.0, // Border width
      //                         ),
      //                       ),
      //                       child: Padding(
      //                         padding: const EdgeInsets.all(3.0),
      //                         child: CircleAvatar(
      //                           backgroundImage:
      //                               AssetImage('lib/assets/images/1.png'),
      //                         ),
      //                       ),
      //                     ),
      //                     SizedBox(width: 3), // Spacing between images
      //                     Container(
      //                       width: 80,
      //                       height: 80,
      //                       decoration: BoxDecoration(
      //                         shape: BoxShape.circle,
      //                         border: Border.all(
      //                           color: Colors.red, // Border color
      //                           width: 4.0, // Border width
      //                         ),
      //                       ),
      //                       child: Padding(
      //                         padding: const EdgeInsets.all(3.0),
      //                         child: CircleAvatar(
      //                           backgroundImage:
      //                               AssetImage('lib/assets/images/2.png'),
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 // Right side with title and subtitle
      //                 SizedBox(width: 20), // Spacing between images

      //                 Expanded(
      //                   child: Padding(
      //                     padding: const EdgeInsets.all(1.0),
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Text(
      //                           'Title',
      //                           style: TextStyle(
      //                               fontSize: 25, fontWeight: FontWeight.bold),
      //                         ),
      //                         //Text('subtitle', style: TextStyle(fontSize: 16)),
      //                         RichText(
      //                           text: TextSpan(
      //                             children: [
      //                               TextSpan(
      //                                 text: 'Get their ',
      //                                 style: TextStyle(
      //                                     color: Colors.black, fontSize: 18),
      //                               ),
      //                               TextSpan(
      //                                 text: 'their book',
      //                                 style: TextStyle(
      //                                     color: Colors.green, fontSize: 18),
      //                               ),
      //                               TextSpan(
      //                                 text: ' for your ',
      //                                 style: TextStyle(
      //                                     color: Colors.black, fontSize: 18),
      //                               ),
      //                               TextSpan(
      //                                 text: 'your book',
      //                                 style: TextStyle(
      //                                     color: Colors.red, fontSize: 18),
      //                               ),
      //                               TextSpan(
      //                                 text: '.',
      //                                 style: TextStyle(
      //                                     color: Colors.black, fontSize: 18),
      //                               ),
      //                             ],
      //                           ),
      //                         )
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           const Divider(),
      //         ],
      //       );
      //     })
      Expanded(
          child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: allMatches.length,
        itemBuilder: (context, index) {
          final item = allMatches[index];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 9.0),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.green, // Border color
                              width: 4.0, // Border width
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('lib/assets/images/1.png'),
                            ),
                          ),
                        ),
                        SizedBox(width: 3), // Spacing between images
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.red, // Border color
                              width: 4.0, // Border width
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('lib/assets/images/2.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Right side with title and subtitle
                    SizedBox(width: 20), // Spacing between images
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Title',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Get their ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              TextSpan(
                                text: 'their book',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 18),
                              ),
                              TextSpan(
                                text: ' for your ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              TextSpan(
                                text: 'your book',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 18),
                              ),
                              TextSpan(
                                text: '.',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          );
        },
      ))
    ]));
  }
}
