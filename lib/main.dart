import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'firebase_options.dart';
import 'room_page.dart';
import 'reader_page.dart';
import 'package:go_router/go_router.dart';
import 'confirmation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Configure GoRouter
  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return HomePage();
        },
        routes: [
          GoRoute(
            path: '/room/:roomId',
            builder: (BuildContext context, GoRouterState state) {
              final String roomId = state.pathParameters['roomId']!;
              return RoomPage(roomId: roomId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/join/:roomId',
        builder: (BuildContext context, GoRouterState state) {
          final String roomId = state.pathParameters['roomId']!;
          return ReaderPage(roomId: roomId);
        },
      ),
      GoRoute(
        path: '/joined/:roomId/:userId',
        builder: (BuildContext context, GoRouterState state) {
          final String roomId = state.pathParameters['roomId']!;
          final String userId = state.pathParameters['userId']!;
          return ConfirmationPage(roomId: roomId, userId: userId);
        },
      ),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData.dark().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _roomController = TextEditingController();
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              TextField(
                controller: _roomController,
                decoration: InputDecoration(
                  errorText: error,
                  labelText: "Insert RoomID",
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  ElevatedButton(
                    child: Text('Main Room'),
                    onPressed: () {
                      _navigateTo('room');
                    },
                  ),
                  ElevatedButton(
                    child: Text('Join Room'),
                    onPressed: () {
                      _navigateTo('join');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(String route) {
    final roomId = _roomController.text;
    if (roomId.isEmpty) {
      setState(() => error = 'Please enter a room ID');
      return;
    }
    context.go('/$route/$roomId');
  }
}
