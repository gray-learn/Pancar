# Event Management Application

This project is an event management application built with **Flutter** for the frontend and **Node.js** with **Firebase** for the backend. It allows users to create, view, manage, and filter events.

## Features
- Create, read, update, and delete events
- Real-time updates of event list
- Filter events by event type
- Firebase Cloud Functions for serverless backend
- Firestore database for data storage
- Flutter frontend with Provider for state management

## Tech Stack
- **Frontend**: Flutter
- **Backend**: Node.js, Firebase Cloud Functions
- **Database**: Firebase Firestore
- **State Management**: Provider

## Project Structure

```plaintext
pancar/
├── frontend/               # Flutter application
│   ├── lib/                
│   │   ├── models/         
│   │   ├── screens/        
│   │   ├── services/       
│   │   ├── providers/      
│   │   └── main.dart       
│   └── pubspec.yaml        
└── backend/                # Firebase Cloud Functions
    ├── functions/          
    │   ├── src/            
    │   │   ├── controllers/  
    │   │   └── triggers/    
    │   ├── index.js        
    │   └── package.json    
    └── firebase.json       
