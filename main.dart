import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;      // ← http 패키지 import
import 'pages/charging_page.dart';
import 'pages/report_page.dart';
import 'pages/weather_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '수분 섭취 앱',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}

// ─────────────────────────────────────────────────────────
// 1) ApiService: REST API 호출을 모아두는 클래스
// ─────────────────────────────────────────────────────────
class ApiService {
  // 에뮬레이터에서 로컬 백엔드 테스트 시: 10.0.2.2:8080
  // 실제 기기나 원격 서버를 쓸 때는 서버 주소로 바꿔주세요.
  static const String _baseUrl = 'http://192.168.126.209:8080/api';

  /// 로그인 API 호출 (POST /api/login)
  static Future<bool> login(String name, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'password': password}),
    );
    return response.statusCode == 200;
  }

  /// (예시) 물 섭취량 조회 API (GET /api/water/{userId})
  static Future<int?> fetchWaterIntake(int userId) async {
    final url = Uri.parse('$_baseUrl/water/$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['currentIntake'] as int;
    }
    return null;
  }

  /// (예시) 물 섭취량 등록 API (POST /api/water/{userId})
  static Future<bool> postWaterIntake(int userId, int amount) async {
    final url = Uri.parse('$_baseUrl/water/$userId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'amount': amount}),
    );
    return response.statusCode == 200;
  }

  /// (예시) 충전 상태 조회 API (GET /api/device/{deviceId}/status)
  static Future<int?> fetchChargeStatus(String deviceId) async {
    final url = Uri.parse('$_baseUrl/device/$deviceId/status');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['chargePercent'] as int;
    }
    return null;
  }
}

// ─────────────────────────────────────────────────────────
// 2) LoginPage: 로그인 화면, _login()에서 ApiService.login 호출
// ─────────────────────────────────────────────────────────
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorText; // 오류 메시지 표시용

  void _login() async {
    final name = nameController.text.trim();
    final password = passwordController.text.trim();

    // 빈 필드 체크
    if (name.isEmpty || password.isEmpty) {
      setState(() {
        errorText = '이름과 비밀번호를 모두 입력하세요.';
      });
      return;
    }

    // 백엔드에 로그인 요청
    bool success = await ApiService.login(name, password);
    if (success) {
      // 로그인 성공 → 메인 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WaterIntakeHomePage()),
      );
    } else {
      // 로그인 실패 → 오류 표시
      setState(() {
        errorText = '로그인 정보가 올바르지 않습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '로그인',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: '이름',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              if (errorText != null) ...[
                Text(errorText!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],
              ElevatedButton(
                onPressed: _login,
                child: const Text('로그인'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// 3) WaterIntakeHomePage: 로그인 후 보여줄 메인 화면
// ─────────────────────────────────────────────────────────
class WaterIntakeHomePage extends StatefulWidget {
  const WaterIntakeHomePage({super.key});
  @override
  _WaterIntakeHomePageState createState() => _WaterIntakeHomePageState();
}

class _WaterIntakeHomePageState extends State<WaterIntakeHomePage> {
  int currentIntake = 1220;
  int dailyGoal = 2000;

  // 목표 설정 다이얼로그
  void _showGoalDialog() {
    final TextEditingController goalController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('하루 목표 물 섭취량 설정'),
          content: TextField(
            controller: goalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: '목표 섭취량 (ml)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                int? newGoal = int.tryParse(goalController.text);
                if (newGoal != null && newGoal < 2000) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('경고'),
                        content: const Text('목표 섭취량은 2000ml 이상이어야 합니다.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  setState(() {
                    dailyGoal = newGoal ?? dailyGoal;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // 로그아웃 다이얼로그
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
              );
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = currentIntake / dailyGoal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('수분 섭취'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: '로그아웃',
          ),
        ],
      ),
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '$currentIntake ml',
                            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                          Text('of $dailyGoal ml'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('${(progress * 100).round()}%', style: const TextStyle(fontSize: 27)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showGoalDialog,
                    child: const Text('추가'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                    onTap: () {},
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
                        MaterialPageRoute(builder: (_) => const ExercisePage()),
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
