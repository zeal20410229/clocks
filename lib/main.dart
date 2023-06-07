import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'タイマー',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        TimerScreen.routeName: (context) => TimerScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ホーム画面'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '現在の時間',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            ClockWidget(),
            SizedBox(height: 32),
            ElevatedButton(
              child: Text('次の画面へ'),
              onPressed: () {
                Navigator.pushNamed(context, TimerScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ClockWidget extends StatefulWidget {
  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _getCurrentTime();
    _startClock();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getCurrentTime() {
    String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());
    setState(() {
      _currentTime = formattedTime;
    });
  }

  void _startClock() {
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      _getCurrentTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentTime,
      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
    );
  }
}

class TimerScreen extends StatefulWidget {
  static const routeName = '/timer';

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _secondsRemaining = 180;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_secondsRemaining < 1) {
            timer.cancel();
          } else {
            _secondsRemaining--;
          }
        });
      },
    );
  }

  String getTimerText() {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('タイマー画面'),
      ),
      body: Center(
        child: Text(
          getTimerText(),
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
