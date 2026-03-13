import 'dart:async';
import 'package:flutter/material.dart';
import 'puzzle_logic.dart';
import 'achievements_manager.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<int> tiles = [];
  List<List<int>> history = [];

  int moves = 0;
  int seconds = 0;
  Timer? timer;
  bool solved = false;
  bool timerStarted = false;

  String difficulty = "Easy";

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    tiles = generatePuzzle(difficulty);
    history.clear();
    moves = 0;
    seconds = 0;
    solved = false;
    timerStarted = false;

    timer?.cancel();
  }

  void startTimer() {
    if (timerStarted) return;
    timerStarted = true;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        seconds++;
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  void moveTile(int index) {
    if (solved) return;

    int empty = tiles.indexOf(0);

    if (isValidMove(index, empty)) {

      // 🔥 TIMER STARTS HERE (FIRST MOVE ONLY)
      if (!timerStarted) {
        startTimer();
      }

      setState(() {
        history.add(List.from(tiles));
        tiles[empty] = tiles[index];
        tiles[index] = 0;
        moves++;
      });

      if (isSolved(tiles)) {
        solved = true;
        stopTimer();
        AchievementsManager.recordWin(seconds, moves);
        showWinDialog();
      }
    }
  }

  void showWinDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("You Solved It! 🎉"),
        content: Text("Time: $seconds sec\nMoves: $moves"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Home"),
          )
        ],
      ),
    );
  }

  void undo() {
    if (history.isNotEmpty && !solved) {
      setState(() {
        tiles = history.removeLast();
        moves--;
      });
    }
  }

  void hint() {
    if (solved) return;

    if (!timerStarted) {
      startTimer();
    }

    List<int> next = getHintMove(tiles);
    setState(() {
      history.add(List.from(tiles));
      tiles = next;
      moves++;
    });
  }

  void aiSolve() async {
    if (solved) return;

    if (!timerStarted) {
      startTimer();
    }

    List<List<int>> solution = solvePuzzle(tiles);

    for (int i = 1; i < solution.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        history.add(List.from(tiles));
        tiles = solution[i];
        moves++;
      });
    }

    solved = true;
    stopTimer();
    AchievementsManager.recordWin(seconds, moves);
    showWinDialog();
  }

  void reset() {
    setState(() {
      startGame();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("8 Puzzle")),
      body: Column(
        children: [
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Time: $seconds s",
                  style: const TextStyle(fontSize: 18)),
              Text("Moves: $moves",
                  style: const TextStyle(fontSize: 18)),
            ],
          ),

          const SizedBox(height: 10),

          DropdownButton<String>(
            value: difficulty,
            items: ["Easy", "Medium", "Hard"]
                .map((e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                difficulty = value!;
                startGame();
              });
            },
          ),

          const SizedBox(height: 20),

          Expanded(
            child: GridView.builder(
              itemCount: 9,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () => moveTile(index),
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: tiles[index] == 0
                          ? Colors.grey[300]
                          : Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        tiles[index] == 0
                            ? ""
                            : tiles[index].toString(),
                        style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(onPressed: undo, child: const Text("Undo")),
                ElevatedButton(onPressed: hint, child: const Text("Hint")),
                ElevatedButton(onPressed: aiSolve, child: const Text("AI Solve")),
                ElevatedButton(onPressed: reset, child: const Text("Reset")),
              ],
            ),
          )
        ],
      ),
    );
  }
}