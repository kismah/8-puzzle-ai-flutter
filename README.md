# 🧩 8 Puzzle AI Flutter Game

A mobile puzzle game built using **Flutter** that solves the classic **8 Puzzle Problem using the A* (A-Star) Algorithm with Manhattan Distance heuristic**.

This project demonstrates how **Artificial Intelligence search algorithms** can be used to solve optimization problems.

---

## 📱 Features

✔ Clean Home Page  
✔ Interactive Puzzle Board  
✔ Timer starts on first move  
✔ Timer stops when puzzle is solved  
✔ Moves Counter  
✔ Undo / Hint / Reset options  
✔ AI Solve using **A\* Algorithm**  
✔ Difficulty Levels (Easy / Medium / Hard)  
✔ Achievements System  
✔ Local Database using **SharedPreferences**

---

## 🧠 AI Algorithm Used

### A* (A-Star) Search Algorithm

The game uses the **A\* algorithm with Manhattan Distance heuristic** to find the optimal path from the current puzzle state to the goal state.

**Heuristic used:**
h(n) = Manhattan Distance
This calculates the distance of each tile from its goal position.

Total cost:f(n) = g(n) + h(n)

Where:

- `g(n)` = cost from start node
- `h(n)` = estimated cost to goal

---

## 🎮 Game Controls

| Button | Function |
|------|------|
| Undo | Reverts last move |
| Hint | Shows next best move |
| AI Solve | Automatically solves puzzle |
| Reset | Generates a new puzzle |

---

## 📦 APK Download

You can install the game from the release page:

👉 **Download APK**

https://github.com/kismah/8-puzzle-ai-flutter/releases

---

## 🛠 Built With

- Flutter
- Dart
- A* Algorithm
- SharedPreferences

---

