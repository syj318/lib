import 'package:flutter/material.dart';
import 'report_page.dart';
import 'weather_page.dart';

class ChargingPage extends StatelessWidget {
  const ChargingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FB),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '충전 상태',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F3A5C),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '태양광으로 충전 중',
                      style: TextStyle(fontSize: 18, color: Color(0xFF2F3A5C)),
                    ),
                    const SizedBox(height: 30),
                    Image.asset('assets/charging.png', height: 200),
                    const SizedBox(height: 20),
                    const Text(
                      '75%',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F3A5C),
                      ),
                    ),
                  ],
                ),
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
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _BottomIcon(
                    text: '충전상태',
                    icon: Icons.power_settings_new,
                  ),
                  _BottomIcon(
                    text: '리포트',
                    icon: Icons.insert_chart_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExercisePage(), // 리포트용 페이지
                        ),
                      );
                    },
                  ),
                  _BottomIcon(
                    text: '날씨',
                    icon: Icons.wb_sunny,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => WeatherPage()),
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
