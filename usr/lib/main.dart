import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/project_list_screen.dart';
import 'screens/project_detail_screen.dart';
import 'screens/project_edit_screen.dart';

void main() {
  runApp(const RFICManagerApp());
}

class RFICManagerApp extends StatelessWidget {
  const RFICManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RFIC Project Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          primary: Colors.indigo,
          secondary: Colors.amber,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/projects': (context) => const ProjectListScreen(),
        '/project_detail': (context) => const ProjectDetailScreen(),
        '/project_edit': (context) => const ProjectEditScreen(),
      },
    );
  }
}
