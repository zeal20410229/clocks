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
      title: 'Flutter 仮眠タイマー',
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
  TextEditingController _minutesController = TextEditingController();
  TextEditingController _secondsController = TextEditingController();
  int _secondsRemaining = 0;
  Timer? _timer;
  bool _isTimerRunning = false;

  @override
  void dispose() {
    _minutesController.dispose();
    _secondsController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (_isTimerRunning) return;

    int minutes = int.parse(_minutesController.text);
    int seconds = int.parse(_secondsController.text);
    _secondsRemaining = (minutes * 60) + seconds;

    _timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          if (_secondsRemaining < 1) {
            timer.cancel();
            _isTimerRunning = false;
          } else {
            _secondsRemaining--;
          }
        });
      },
    );

    _isTimerRunning = true;
  }

  String getTimerText() {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void pauseTimer() {
    _timer?.cancel();
    _isTimerRunning = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('タイマー画面'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('分: '),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _minutesController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('秒: '),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _secondsController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text(_isTimerRunning ? '一時停止' : '開始'),
              onPressed: () {
                if (_isTimerRunning) {
                  pauseTimer();
                } else {
                  startTimer();
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              getTimerText(),
              style: TextStyle(fontSize: 32),
            ),
          ],
        ),
      ),
    );
  }
}
