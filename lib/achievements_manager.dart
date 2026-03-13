import 'package:shared_preferences/shared_preferences.dart';

class AchievementsManager {

  static int gamesWon = 0;
  static int fastestTime = 999999;
  static int leastMoves = 999999;

  static Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    gamesWon = prefs.getInt("gamesWon") ?? 0;
    fastestTime = prefs.getInt("fastestTime") ?? 999999;
    leastMoves = prefs.getInt("leastMoves") ?? 999999;
  }

  static Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt("gamesWon", gamesWon);
    await prefs.setInt("fastestTime", fastestTime);
    await prefs.setInt("leastMoves", leastMoves);
  }

  static Future<void> recordWin(int time, int moves) async {

    await loadData();

    gamesWon++;

    if (time < fastestTime) {
      fastestTime = time;
    }

    if (moves < leastMoves) {
      leastMoves = moves;
    }

    await saveData();
  }

  static Future<List<String>> getAchievements() async {

    await loadData();

    List<String> achievements = [];

    if (gamesWon >= 1) {
      achievements.add("First Win 🏆");
    }

    if (gamesWon >= 5) {
      achievements.add("5 Wins Master 🎯");
    }

    if (fastestTime < 60) {
      achievements.add("Under 1 Minute ⚡");
    }

    if (leastMoves <= 25) {
      achievements.add("Under 25 Moves 🔥");
    }

    if (achievements.isEmpty) {
      achievements.add("No achievements yet 😅");
    }

    return achievements;
  }
}