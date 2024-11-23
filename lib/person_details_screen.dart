import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'image_viewer_screen.dart';

class PersonDetailsScreen extends StatelessWidget {
  final int personId;

  const PersonDetailsScreen({Key? key, required this.personId}) : super(key: key);

  Future<Map<String, dynamic>> fetchPersonDetails() async {
    final response = await Dio().get(
        'https://api.themoviedb.org/3/person/$personId?api_key=2dfe23358236069710a379edd4c65a6b');
    return response.data;
  }

  Future<List<dynamic>> fetchPersonImages() async {
    final response = await Dio().get(
        'https://api.themoviedb.org/3/person/$personId/images?api_key=2dfe23358236069710a379edd4c65a6b');
    return response.data['profiles'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Person Details')),
      body: FutureBuilder(
        future: Future.wait([fetchPersonDetails(), fetchPersonImages()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else {
            final personData = snapshot.data![0] as Map<String, dynamic>;
            final images = snapshot.data![1] as List<dynamic>;

            return Column(
              children: [
                Text(personData['name'], style: const TextStyle(fontSize: 24)),
                Text(personData['biography'] ?? 'No biography available'),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final imageUrl = 'https://image.tmdb.org/t/p/w500${images[index]['file_path']}';
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageViewerScreen(imageUrl: imageUrl),
                            ),
                          );
                        },
                        child: Image.network(imageUrl, fit: BoxFit.cover),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
