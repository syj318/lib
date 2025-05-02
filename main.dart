import 'package:flutter/material.dart';

void main() => runApp(WaterIntakeApp());

class WaterIntakeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '수분 섭취 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WaterIntakeHomePage(),
    );
  }
}

class WaterIntakeHomePage extends StatelessWidget {
  final int currentIntake = 1220;
  final int dailyGoal = 2000;

  @override
  Widget build(BuildContext context) {
    double progress = currentIntake / dailyGoal;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              '수분 섭취',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('하루 권장량: 2000 ml'),
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.blue.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '$currentIntake ml',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('of 2000 ml'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('${(progress * 100).round()}%', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text('추가'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _bottomIcon('수분측정', Icons.opacity),
                  _bottomIcon('충전상태', Icons.power_settings_new),
                  _bottomIcon('운동량', Icons.pool),
                  _bottomIcon('날씨', Icons.wb_sunny),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _bottomIcon(String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue.shade800),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}
