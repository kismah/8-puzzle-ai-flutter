import 'package:flutter/material.dart';
import 'game_page.dart';
import 'achievements_manager.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void openAchievements(BuildContext context) async{
    List<String> achievements = await AchievementsManager.getAchievements();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Achievements"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: achievements.map((e) => Text(e)).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("8 Puzzle")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GamePage()),
                );
              },
              child: const Text("Start Game"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => openAchievements(context),
              child: const Text("Achievements"),
            ),
          ],
        ),
      ),
    );
  }
}