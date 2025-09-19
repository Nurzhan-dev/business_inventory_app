import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import the home screen
import 'services/notification_service.dart';

void main() {
  runApp(BusinessApp());
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.init();
}

class BusinessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Учёт бизнеса',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(), // Set the home screen
    );
  }
}
