import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class RoomPage extends StatelessWidget {
  const RoomPage({required this.roomId, super.key});

  final String roomId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join live Room')),
      body: Row(
        children: [
          // Left Section: Joined Users
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [JoinedUsersList(roomId: roomId)]),
            ),
          ),

          // Right Section: Join the Room (QR Code Placeholder)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    'Join the Room',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: QrCodeGenerator(data: roomId),
                  ), // Replace with dynamic room ID later
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QrCodeGenerator extends StatelessWidget {
  final String data;
  const QrCodeGenerator({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final uri = Uri.base;
    final url = '${uri.scheme}://${uri.authority}/#/join/$data';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: QrImageView(data: url, version: QrVersions.auto, size: 200.0),
      ),
    );
  }
}

class JoinedUsersList extends StatelessWidget {
  const JoinedUsersList({required this.roomId, super.key});

  final String roomId;

  @override
  Widget build(BuildContext context) {
    // Replace 'your_room_id' with the actual room ID you will use
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child(
      'rooms/$roomId/users',
    );

    return Expanded(
      child: StreamBuilder<DatabaseEvent>(
        stream: usersRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            final data = snapshot.data!.snapshot.value;
            // print(data);
            final users =
                (data as Map<dynamic, dynamic>?)?.values
                    .cast<Map<dynamic, dynamic>>()
                    .toList() ??
                [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Joined Users',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final profileImage = users[index]['avatar'];
                      return ListTile(
                        title: Text(users[index]['username']),
                        leading: Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image:
                                profileImage != null
                                    ? DecorationImage(
                                      image: MemoryImage(
                                        base64Decode(profileImage),
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                            color: Colors.grey[300], // Placeholder color
                          ),
                          child:
                              profileImage == null
                                  ? const Icon(
                                    Icons
                                        .person, // Placeholder icon for no image
                                    size: 30,
                                    color: Colors.grey,
                                  )
                                  : null, // No placeholder icon if image is present
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(
              child: const CircularProgressIndicator(),
            ); // Loading indicator
          }
        },
      ),
    );
  }
}
