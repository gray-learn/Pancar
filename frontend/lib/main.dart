import 'package:flutter/material.dart';
import 'package:frontend/providers/event_provider.dart';
import 'package:provider/provider.dart';

import 'get.dart';
import 'post.dart';
import 'screens/event_list_screen.dart';

void main() {
  runApp(const MaterialApp(
    title: "APP",
    home: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  // CARD
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: MaterialApp(
        title: 'Event Management App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: EventListScreen(),
      ),
    );
  }
}

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (BuildContext context) {
//                         return const POST();
//                       },
//                     ),
//                   );
//                 },
//                 child: const Text("UPDATE")),
//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) {
//                       return const GET();
//                     },
//                   ));
//                 },
//                 child: const Text("GET")),
//           ],
//         ),
//       ),
//     );
//   }
// }
