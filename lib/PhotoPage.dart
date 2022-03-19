import 'package:flutter/material.dart';
import 'package:gallery/models/abbreviatedPhoto.dart';

class PhotoPage extends StatelessWidget {
  final AbbreviatedPhoto selectedPhoto;

  const PhotoPage(this.selectedPhoto, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(selectedPhoto.title),
        ),
        body: Center(
            child: Image.network(selectedPhoto.full,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            )
        )
    );
  }
}