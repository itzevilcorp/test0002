import 'dart:async';

import 'package:flutter/material.dart';
import 'poke.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokemon Cards',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(), // Display SplashScreen initially
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    Timer(Duration(seconds: 30), () {
      // Navigate to PokemonList after 2 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PokemonList()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Pokemon Cards',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the login screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  // Continue as guest logic
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PokemonList()),
                  );
                },
                child: Text('Continue as Guest'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform login logic
                // For now, navigate to PokemonList screen after login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PokemonList()),
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
