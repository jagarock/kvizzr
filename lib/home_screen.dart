import 'package:flutter/material.dart';
import 'detaljkunnskap_screen.dart';
import 'category_screen.dart';
import 'reaction_game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('userId');

    if (storedUserId == null) {
      var uuid = const Uuid();
      storedUserId = uuid.v4();
      await prefs.setString('userId', storedUserId);
    }

    setState(() {
      userId = storedUserId;
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeContent(),
    const CategoryScreen(category: "Allmenkunnskap"),
    const DetaljkunnskapScreen(),
    const ReactionGameScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Hjem',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'Allmen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Detaljkunnskap',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Hjernetrim',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'KvizzR',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                QuizCategoryButton(
                  icon: Icons.person,
                  label: '3652. plass',
                ),
              ],
            ),
            const SizedBox(height: 40),
            QuizActionButton(
              label: 'Sjekk allmenkunnskapen',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const CategoryScreen(category: "Allmenkunnskap")),
                );
              },
            ),
            const SizedBox(height: 20),
            QuizActionButton(
              label: 'Gå i dybden',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DetaljkunnskapScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            QuizActionButton(
              label: 'Hjernetrim',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReactionGameScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QuizCategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const QuizCategoryButton({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white,
          child: Icon(icon, size: 40, color: Colors.blue),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}

class QuizActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const QuizActionButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400, // Sett ønsket bredde
      height: 60, // Sett ønsket høyde
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          textStyle: const TextStyle(fontSize: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
