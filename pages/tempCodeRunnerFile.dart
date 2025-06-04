import 'package:flutter/material.dart';
import 'charging_page.dart';
import 'report_page.dart';
import 'weather_page.dart';

void main() => runApp(WaterIntakeApp());

class WaterIntakeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '수분 섭취 앱',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WaterIntakeHomePage(),
    );
  }
}

class WaterIntakeHomePage extends StatefulWidget {
  @override
  _WaterIntakeHomePageState createState() => _WaterIntakeHomePageState();
}

class _WaterIntakeHomePageState extends State<WaterIntakeHomePage> {
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
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '수분 섭취',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text('하루 권장량: $dailyGoal ml'),
                  const SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 12,
                          backgroundColor: Colors.blue.shade100,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '$currentIntake ml',
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('of $dailyGoal ml'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(fontSize: 27),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // 향후 수동 기록 추가 기능 연결
                    },
                    child: const Text('추가'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Colors.black12),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomIcon(
                    text: '수분측정',
                    icon: Icons.opacity,
                    onTap: () {}, // 현재 페이지이므로 비활성
                  ),
                  _BottomIcon(
                    text: '충전상태',
                    icon: Icons.power_settings_new,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChargingPage()),
                      );
                    },
                  ),
                  _BottomIcon(
                    text: '리포트',
                    icon: Icons.insert_chart_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ExercisePage()), // report_page.dart 안에 있음
                      );
                    },
                  ),
                  _BottomIcon(
                    text: '날씨',
                    icon: Icons.wb_sunny,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WeatherPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onTap;

  const _BottomIcon({required this.text, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: Colors.blue.shade800),
          const SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(color: Colors.blue.shade800, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
