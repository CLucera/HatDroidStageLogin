import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class ConfirmationPage extends StatelessWidget {
  final String roomId;
  final String userId;

  const ConfirmationPage({Key? key, required this.roomId, required this.userId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseReference userRef = FirebaseDatabase.instance.ref(
      '/rooms/$roomId/users/$userId',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome!')),
      body: Center(
        child: FutureBuilder<DatabaseEvent>(
          future: userRef.once(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final value =
                  snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;

              final username = value?['username'] ?? userId;
              final profileImage = value?['avatar'];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome, $username!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image:
                          profileImage != null
                              ? DecorationImage(
                                image: MemoryImage(base64Decode(profileImage)),
                                fit: BoxFit.cover,
                              )
                              : null,
                      color: Colors.grey[300], // Placeholder color
                    ),
                    child:
                        profileImage == null
                            ? const Icon(
                              Icons.person, // Placeholder icon for no image
                              size: 80,
                              color: Colors.grey,
                            )
                            : null, // No placeholder icon if image is present
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
