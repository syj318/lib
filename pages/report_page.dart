// 📄 exercise_page.dart (UI 개선 + 하단 네비게이션 수정)
import 'package:flutter/material.dart';
import '../main.dart';
import 'charging_page.dart';
import 'weather_page.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> weeklyData = [1100, 1450, 1900, 950, 850, 930, 700];
    final List<String> days = ['일', '월', '화', '수', '목', '금', '토'];

    return Scaffold(
      backgroundColor: const Color(0xEAF3FBFF),
      appBar: AppBar(
        title: const Text('나의 건강 리포트'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '최근 일주일간 수분 섭취량',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(7, (index) {
                        final heightFactor = weeklyData[index] / 2000;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 150 * heightFactor,
                              width: 18,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(days[index]),
                          ],
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                _StatBox(
                  icon: Icons.opacity,
                  label: '가장 많이 마신 요일',
                  value: '화요일',
                ),
                SizedBox(height: 10),
                _StatBox(
                  icon: Icons.track_changes,
                  label: '목표 달성률',
                  value: '86%',
                ),
                SizedBox(height: 10),
                _StatBox(
                  icon: Icons.calendar_today,
                  label: '연속 달성일',
                  value: '3일',
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BottomIcon(
                text: '수분측정',
                icon: Icons.opacity,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => WaterIntakeHomePage()),
                  );
                },
              ),
              _BottomIcon(
                text: '충전상태',
                icon: Icons.power_settings_new,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ChargingPage()),
                  );
                },
              ),
              _BottomIcon(
                text: '리포트',
                icon: Icons.insert_chart_outlined,
              ),
              _BottomIcon(
                text: '날씨',
                icon: Icons.wb_sunny,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => WeatherPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatBox({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
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