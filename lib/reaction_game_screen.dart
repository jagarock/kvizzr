import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:confetti/confetti.dart';

class ReactionGameScreen extends StatefulWidget {
  const ReactionGameScreen({super.key});

  @override
  _ReactionGameScreenState createState() => _ReactionGameScreenState();
}

class _ReactionGameScreenState extends State<ReactionGameScreen> with TickerProviderStateMixin {
  int _countdown = 5;
  int _score = 0;
  int _gameTime = 0;
  final int _gameId = 1; // Reaction Game
  bool _showInstruction = true;
  bool _gameStarted = false;
  bool _playedOnce = false;
  Timer? _countdownTimer;
  Timer? _gameTimer;
  Timer? _gameProgressTimer;
  final List<Color> _boxColors = [Colors.red, Colors.green, Colors.red, Colors.green];
  late AnimationController _controller;
  late List<Animation<Offset>> _offsetAnimations;
  final AudioCache _audioCache = AudioCache(prefix: 'assets/');
  final String _beepSound = 'beep.mp3';
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  bool _canCloseDialog = false;

  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 70),
      vsync: this,
    );
    _offsetAnimations = List.generate(4, (index) {
      return Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: const Offset(0.0, 0.0),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    });
    _startCountdownAndInstruction();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _gameTimer?.cancel();
    _gameProgressTimer?.cancel();
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _startCountdownAndInstruction() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        _showInstruction = false;
        _startGame();
      }
    });
  }

  void _startGame() {
    setState(() {
      _gameStarted = true;
      _score = 0;
      _gameTime = 0;
    });
    _controller.forward();
    _gameTimer = Timer(const Duration(seconds: 20), _endGame);
    _gameProgressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _gameTime++;
      });
      if (_gameTime == 16) {
        if (_playedOnce == false) {
        _audioCache.play(_beepSound);
        _playedOnce = true;
        }
      }
      if (_gameTime == 20) {
        _endGame();
      }
    });
  }

Future<void> _sendScore() async {
  final userId = await _getUserId();
  const url = 'https://kvizzr-3d8a.restdb.io/rest/scores';
  final headers = {
    'Content-Type': 'application/json',
    'x-apikey': '6648f1a480d0b0efe630bf23',
  };
  final body = jsonEncode({
    'userId': userId,
    'gameId': _gameId,
    'score': _score,
  });

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 201) {
    print('Data successfully sent!');
  } else {
    print('Failed to send data. Status code: ${response.statusCode}');
  }
}

  Future<void> _endGame() async {
    _gameTimer?.cancel();
    _gameProgressTimer?.cancel();
    _gameStarted = false;
    await _storeScore();
    await _sendScore();
    _confettiController.play();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => _canCloseDialog,
        child: AlertDialog(
          title: const Text('Spill ferdig!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Din score:',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 10),
              Text(
                '$_score',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [Colors.red, Colors.green, Colors.blue, Colors.yellow],
              ),
            ],
          ),
          
          actions: [
            TextButton(
              onPressed: () {
                if (_canCloseDialog) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _canCloseDialog = true;
      });
    });
  }

  Future<void> _storeScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_score', _score);
  }

  void _checkColor(Color color) {
    if ((_boxColors[0] == Colors.red && color == Colors.green) ||
        (_boxColors[0] == Colors.green && color == Colors.red)) {
      setState(() {
        _score++;
      });
    }
    _shiftBoxes();
  }

  void _shiftBoxes() {
    setState(() {
      _boxColors.removeAt(0);
      _boxColors.add(_generateRandomColor());
      _controller.forward(from: 0.0);
    });
  }

  Color _generateRandomColor() {
    return (DateTime.now().millisecond % 2 == 0) ? Colors.red : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reaction Game'),
        centerTitle: true,
      ),
      body: Center(
        child: _showInstruction
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Trykk på feil farge flest mulig ganger iløpet av 20 sekunder..',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '$_countdown',
                    style: const TextStyle(fontSize: 48, color: Colors.white),
                  ),
                ],
              )
            : _gameStarted
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Score: $_score', style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 20),
                      SlideTransition(
                        position: _offsetAnimations[3],
                        child: BoxWidget(color: _boxColors[3]),
                      ),
                      SlideTransition(
                        position: _offsetAnimations[2],
                        child: BoxWidget(color: _boxColors[2]),
                      ),
                      SlideTransition(
                        position: _offsetAnimations[1],
                        child: BoxWidget(color: _boxColors[1]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                            ),
                            onPressed: () => _checkColor(Colors.red),
                            child: const Text('Red'),
                          ),
                          const SizedBox(width: 20),
                          SlideTransition(
                            position: _offsetAnimations[0],
                            child: BoxWidget(color: _boxColors[0]),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                            ),
                            onPressed: () => _checkColor(Colors.green),
                            child: const Text('Green'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('Time: $_gameTime s', style: const TextStyle(fontSize: 24)),
                    ],
                  )
                : Text(
                    _countdown > 0 ? '$_countdown' : 'Go!',
                    style: const TextStyle(fontSize: 48, color: Colors.white),
                  ),
      ),
    );
  }
}

class BoxWidget extends StatelessWidget {
  final Color color;

  const BoxWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 10),
    );
  }
}
