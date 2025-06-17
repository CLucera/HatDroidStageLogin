# **AI Sprint 2025: Firebase & Gemini QR Code Room**

Welcome to our sample project for the **AI Sprint 2025**\! This application is a simple demonstration of how to integrate Firebase and the Gemini API to create a fun, interactive experience. The app allows users to join a room by scanning a QR code, choose a nickname, and have a unique avatar generated for them by Gemini.

## **Before you start**

This project relies on Firebase Real Time database and Firebase AI.
to generate all the necessary file for the project (Not included in this repo) you need:

- a Valid firebase Project, you can create from your [Firebase console](https://console.firebase.google.com/)
- Enable Firebase realtime database
- Enable Firebase AI Logic

# Configure the project;
My suggestion is to use [Firebase CLI](https://firebaseopensource.com/projects/firebase/firebase-tools/) and [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup?hl=it&platform=android) both tools are available by default on Firebase Studio.

With both tools available you need first to log in Firebase:
```firebase login```
Follow the instruction on the terminal to connect your account.

Then you need to configure the project:
```flutterfire configure```
Follow the instruction by selecting the project you want to use and the platforms.
This will generate the `firebase_options.dart` file you need to run the project.


## **About The Project**

This application was developed as an exploration of the new possibilities offered by combining Firebase's powerful backend services with the generative capabilities of Google's Gemini API, all within the Firebase Studio environment.

For a detailed walkthrough of the idea, the development process, and the "why" behind this project, please check out my article on Medium:

**➡️ [Hey Google, can you help me build my login?](https://templink)**

## **Features**

* **Real-time Rooms:** Uses Firebase Realtime Database to manage rooms and user lists in real-time.  
* **QR Code Joining:** The host screen displays a QR code that others can scan to easily join the room.  
* **AI-Powered Avatars:** When a user enters their nickname, the application calls the Gemini API to generate a unique, cute avatar based on the name.  
* **Live User List:** The host screen displays a live list of all users who have joined the room, complete with their AI-generated avatars.

## **Technology Stack**

This project is built with a combination of modern tools to create a seamless cross-platform experience:

* [**Flutter**](https://flutter.dev/): The UI toolkit for building the application for web and mobile from a single codebase.  
* [**Firebase Realtime Database**](https://firebase.google.com/products/realtime-database): To store and sync room and user data in real-time.  
* [**Gemini API**](https://ai.google.dev/): For generating unique user avatars based on text prompts.  
* [**GoRouter**](https://pub.dev/packages/go_router): For declarative routing within the Flutter app.  
* [**QR Flutter**](https://pub.dev/packages/qr_flutter): To generate the QR codes for joining rooms.

## **How It Works**

1. **Host a Room**: The main page allows a user to open a "room". This generates a unique session and displays a QR code.  
2. **Join a Room**: Other users can use their device's camera to scan the QR code, which directs them to the joining page.  
3. **Enter Nickname**: The new user enters a nickname.  
4. **Generate Avatar**: The app sends a prompt with the nickname to the Gemini API, which returns a unique image.  
5. **Welcome\!**: The user's nickname and newly generated avatar are saved to the Firebase Realtime Database, and they are welcomed into the room. The host's screen updates instantly to show the new user.

Thank you for checking out this project\!