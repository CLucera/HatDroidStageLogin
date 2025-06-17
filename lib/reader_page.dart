import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'dart:convert';
import 'package:image/image.dart' as img;

class ReaderPage extends StatefulWidget {
  final String roomId;

  const ReaderPage({Key? key, required this.roomId}) : super(key: key);

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  final TextEditingController _nicknameController = TextEditingController();
  late DatabaseReference _roomRef;

  @override
  void initState() {
    super.initState();
    _roomRef = FirebaseDatabase.instance
        .ref()
        .child('rooms')
        .child(widget.roomId)
        .child('users');
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _addNickname() async {
    final username = _nicknameController.text.trim();
    if (username.isNotEmpty) {
      try {
        final avatar = await _generateImage(username);
        final ref = _roomRef.push();
        await ref.set({'username': username, 'avatar': avatar});
        if (context.mounted) {
          context.go('/joined/${widget.roomId}/${ref.key}');
        }
      } catch (e) {
        print('Error adding nickname: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Nickname')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: 'Enter your nickname',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addNickname,
              child: const Text('Join Room'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _generateImage(String username) async {
    final model = FirebaseAI.vertexAI().generativeModel(
      model: 'gemini-2.0-flash-preview-image-generation',
      generationConfig: GenerationConfig(
        responseModalities: [ResponseModalities.text, ResponseModalities.image],
      ),
    );

    final prompt = [
      Content.text(
        'Generate a cute svg like avatar based for the user called: $username '
        'do not include any kind of text',
      ),
    ];

    final response = await model.generateContent(prompt);
    if (response.inlineDataParts.isNotEmpty) {
      final bytes = response.inlineDataParts.first.bytes;

      final image = img.decodeImage(bytes);
      if (image != null) {
        final resizedImage = img.copyResize(image, width: 100, height: 100);
        return base64Encode(img.encodePng(resizedImage));
      } else {
        return null; // Or handle the error appropriately
      }
    } else {
      return null;
    }
  }
}
