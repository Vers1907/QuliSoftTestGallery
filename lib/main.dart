import 'dart:convert';

import 'package:gallery/PhotoPage.dart';
import 'package:gallery/models/abbreviatedPhoto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<AbbreviatedPhoto>> fetchPhotos() async {
  final response = await http
      .get(Uri.parse('https://api.unsplash.com/photos/?page=1&per_page=100&client_id=896d4f52c589547b2134bd75ed48742db637fa51810b49b607e37e46ab2c0043'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.map((rawPhoto)
    {
      return AbbreviatedPhoto.fromJson(rawPhoto);
    }).toList();
  } else {

    throw Exception('Failed to load photos');
  }
}

void main() {
  runApp(const GalleryApp());
}

class GalleryApp extends StatefulWidget {
  const GalleryApp({Key? key}) : super(key: key);

  @override
  _GalleryAppState createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  late Future<List<AbbreviatedPhoto>> _futurePhotos;

  @override
  void initState() {
    super.initState();
    _futurePhotos = fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Unsplash Photo Gallery',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Unsplash Photo Gallery'),
          ),
          body: FutureBuilder<List<AbbreviatedPhoto>>(
            future: _futurePhotos,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var photos = snapshot.data!;
                return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0
                    ),
                    itemCount: 100,
                    itemBuilder: (context, index) {
                      if (index >= photos.length) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        var photo = photos[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => PhotoPage(photo)));
                          },
                          child: GridTile(
                            child: Image.network(photo.small,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                        null
                                        ? loadingProgress
                                        .cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                            header: Container(
                              child: Center(
                                  child: Text(photo.title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                              color: const Color(0x44000000),
                            ),
                            footer: Container(
                              child: Center(
                                  child: Text(photo.authorName,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                              color: const Color(0x44000000),
                            ),
                          ),
                        );
                      }
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const Center(child: CircularProgressIndicator());
            },
          ),
        )
    );
  }
}
