import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/store_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storeProvider = StoreProvider();
  await storeProvider.loadData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: storeProvider),
      ],
      child: const MohammedDhairApp(),
    ),
  );
}

class MohammedDhairApp extends StatelessWidget {
  const MohammedDhairApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mohammed Dhair Perfume Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        fontFamily: 'sans-serif',
      ),
      home: const HomeScreen(),
    );
  }
}
