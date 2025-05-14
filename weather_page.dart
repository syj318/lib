import 'package:flutter/material.dart';
import 'charging_page.dart';
import 'exercise_page.dart';
import 'main.dart'; // WaterIntakeHomePage가 main.dart에 있다면

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text('날씨 기반 수분 조절'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WeatherSection(),
              Divider(height: 30),
              InfoRow(
                icon: Icons.local_drink,
                text: '날씨에 따른 수분 손실 예상: +250ml\n오늘은 더운 날씨로 인해 땀 배출이 많습니다.',
              ),
              SizedBox(height: 16),
              InfoRow(
                icon: Icons.flag,
                text: '새로운 섭취 목표: 2,550ml\n(기존 2,300ml + 날씨 기반 250ml 추가)',
              ),
              SizedBox(height: 16),
              InfoRow(
                icon: Icons.chat_bubble_outline,
                text: '기온이 25도 이상이거나\n습도가 낮은 날은 하루에 1~2컵 더 마셔주세요.',
              ),
            ],
          ),
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => WaterIntakeHomePage()),
                        (route) => false,
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
                text: '운동량',
                icon: Icons.pool,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ExercisePage()),
                  );
                },
              ),
              _BottomIcon(
                text: '날씨',
                icon: Icons.wb_sunny,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.wb_sunny, color: Colors.orange, size: 40),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('맑음', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('26°C', style: TextStyle(fontSize: 18)),
          ],
        )
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueAccent),
        SizedBox(width: 12),
        Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
      ],
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
