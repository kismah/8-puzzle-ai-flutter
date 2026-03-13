import 'dart:collection';
import 'dart:math';

bool isValidMove(int index, int emptyIndex) {
  int row = index ~/ 3;
  int col = index % 3;
  int emptyRow = emptyIndex ~/ 3;
  int emptyCol = emptyIndex % 3;

  return (row == emptyRow && (col - emptyCol).abs() == 1) ||
      (col == emptyCol && (row - emptyRow).abs() == 1);
}

bool isSolved(List<int> tiles) {
  for (int i = 0; i < 8; i++) {
    if (tiles[i] != i + 1) return false;
  }
  return tiles[8] == 0;
}

List<int> generatePuzzle(String difficulty) {
  Random random = Random();
  List<int> tiles = [1,2,3,4,5,6,7,8,0];

  int shuffleMoves = difficulty == "Easy"
      ? 25
      : difficulty == "Medium"
      ? 60
      : 120;

  for (int i = 0; i < shuffleMoves; i++) {
    int empty = tiles.indexOf(0);
    List<int> possible = [];

    for (int j = 0; j < 9; j++) {
      if (isValidMove(j, empty)) {
        possible.add(j);
      }
    }

    int move = possible[random.nextInt(possible.length)];
    tiles[empty] = tiles[move];
    tiles[move] = 0;
  }

  return tiles;
}

int manhattanDistance(List<int> state) {
  int distance = 0;

  for (int i = 0; i < 9; i++) {
    if (state[i] == 0) continue;

    int targetRow = (state[i] - 1) ~/ 3;
    int targetCol = (state[i] - 1) % 3;

    int currentRow = i ~/ 3;
    int currentCol = i % 3;

    distance += (currentRow - targetRow).abs() +
        (currentCol - targetCol).abs();
  }

  return distance;
}

class Node {
  List<int> state;
  int g; // cost so far
  int h; // heuristic
  Node? parent;

  Node(this.state, this.g, this.h, this.parent);

  int get f => g + h;
}

List<List<int>> solvePuzzle(List<int> start) {
  final goal = [1,2,3,4,5,6,7,8,0];

  List<Node> open = [];
  Set<String> closed = {};

  open.add(Node(start, 0, manhattanDistance(start), null));

  while (open.isNotEmpty) {

    open.sort((a, b) => a.f.compareTo(b.f));
    Node current = open.removeAt(0);

    if (current.state.toString() == goal.toString()) {
      List<List<int>> path = [];
      Node? node = current;

      while (node != null) {
        path.insert(0, node.state);
        node = node.parent;
      }

      return path;
    }

    closed.add(current.state.toString());

    int empty = current.state.indexOf(0);

    for (int i = 0; i < 9; i++) {
      if (isValidMove(i, empty)) {
        List<int> next = List.from(current.state);
        next[empty] = next[i];
        next[i] = 0;

        if (closed.contains(next.toString())) continue;

        open.add(Node(
          next,
          current.g + 1,
          manhattanDistance(next),
          current,
        ));
      }
    }
  }

  return [start];
}

List<int> getHintMove(List<int> tiles) {
  List<List<int>> solution = solvePuzzle(tiles);
  if (solution.length > 1) {
    return solution[1];
  }
  return tiles;
}