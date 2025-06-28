import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'thelegs.dart'; // Import the motor controller

class AlarmHomePage extends StatefulWidget {
  const AlarmHomePage({super.key});

  @override
  State<AlarmHomePage> createState() => _AlarmHomePageState();
}

class _AlarmHomePageState extends State<AlarmHomePage> {
  TimeOfDay? _alarmTime;
  Timer? _alarmTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final MotorController _motorController = MotorController();
  String _connectionStatus = "Connecting...";

  @override
  void initState() {
    super.initState();
    _initMotor();
  }

  // Initialize motor connection
  Future<void> _initMotor() async {
    final status = await _motorController.connect();
    setState(() {
      _connectionStatus = status;
    });
  }

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _alarmTime = picked;
      });
      _startAlarmTimer(picked);
    }
  }

  void _startAlarmTimer(TimeOfDay time) {
    final now = DateTime.now();
    final alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    final duration =
        alarmDateTime.isAfter(now)
            ? alarmDateTime.difference(now)
            : alarmDateTime.add(const Duration(days: 1)).difference(now);

    _alarmTimer?.cancel();
    _alarmTimer = Timer(duration, () {
      if (mounted) {
        _triggerAlarm();
      }
    });
  }

  void _triggerAlarm() async {
    // Play alarm sound
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('alarm.wav'));

    // Send command to motor to start movement
    _motorController.sendCommand('s'); // 's' is for start movement

    if (context.mounted) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Alarm Triggered!'),
              content: const Text('Time to wake up!'),
              actions: [
                TextButton(
                  onPressed: () {
                    // Stop alarm and motor
                    _audioPlayer.stop();
                    _motorController.sendCommand('x'); // 'x' is for stop
                    Navigator.of(context).pop();
                  },
                  child: const Text('Dismiss'),
                ),
              ],
            ),
      );
    }
  }

  @override
  void dispose() {
    _alarmTimer?.cancel();
    _audioPlayer.dispose();
    _motorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alarmText =
        _alarmTime != null ? _alarmTime!.format(context) : 'No alarm set';

    return Scaffold(
      appBar: AppBar(title: const Text('Alarm Clock')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Motor: $_connectionStatus'),
            const SizedBox(height: 10),
            Text(
              'Alarm Time: $alarmText',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickTime,
              child: const Text('Set Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: AlarmHomePage()));
}
