import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

// Состояния
enum TicTacToeSquare { empty, x, o, xWin, oWin }

class TicTacToeCubit extends Cubit<List<List<TicTacToeSquare>>> {
  TicTacToeCubit()
      : super(List.generate(3, (_) => List.filled(3, TicTacToeSquare.empty)));

  bool gameOver = false;
  TicTacToeSquare currentPlayer = TicTacToeSquare.x;
  TicTacToeSquare lastLoser = TicTacToeSquare
      .o; // Добавляем переменную для хранения проигравшего игрока

  void handleCellTap(int row, int col) {
    if (!gameOver && isEmptyCell(row, col)) {
      if (!checkForWinAndHighlight()) {
        makeMove(row, col);

        if (gameOver) {
          currentPlayer = lastLoser;
          lastLoser = TicTacToeSquare.empty;
          lastLoser = currentPlayer; // Запоминаем проигравшего игрока
          emit(state);
        } else {
          makeComputerMove();
        }
      }
    }
  }

  void makeComputerMove() {
    if (!gameOver && currentPlayer == TicTacToeSquare.o) {
      int bestScore = -1000; // Минимальное возможное значение
      int bestMoveRow = -1;
      int bestMoveCol = -1;

      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (state[i][j] == TicTacToeSquare.empty) {
            state[i][j] = TicTacToeSquare.o;
            int score = minimax(state, 0, false);
            state[i][j] = TicTacToeSquare.empty;

            if (score > bestScore) {
              bestScore = score;
              bestMoveRow = i;
              bestMoveCol = j;
            }
          }
        }
      }

      if (bestMoveRow != -1 && bestMoveCol != -1) {
        makeMove(bestMoveRow, bestMoveCol);
      }
    }
  }

  int minimax(List<List<TicTacToeSquare>> board, int depth, bool isMaximizing) {
    if (checkForWin(TicTacToeSquare.x)) {
      return -10 + depth;
    } else if (checkForWin(TicTacToeSquare.o)) {
      return 10 - depth;
    } else if (isBoardFull()) {
      return 0;
    }

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == TicTacToeSquare.empty) {
            board[i][j] = TicTacToeSquare.o;
            int score = minimax(board, depth + 1, false);
            board[i][j] = TicTacToeSquare.empty;
            bestScore = max(bestScore, score);
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == TicTacToeSquare.empty) {
            board[i][j] = TicTacToeSquare.x;
            int score = minimax(board, depth + 1, true);
            board[i][j] = TicTacToeSquare.empty;
            bestScore = min(bestScore, score);
          }
        }
      }
      return bestScore;
    }
  }

  bool isBoardFull() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (state[i][j] == TicTacToeSquare.empty) {
          return false;
        }
      }
    }
    return true;
  }

  bool isEmptyCell(int row, int col) {
    return state[row][col] == TicTacToeSquare.empty;
  }

  bool checkForWinAndHighlight() {
    if (!gameOver && checkForWin(TicTacToeSquare.x)) {
      gameOver = true;
      lastLoser = TicTacToeSquare.x;
      emit(List.generate(3, (row) {
        return List.generate(3, (col) {
          if (state[row][col] == TicTacToeSquare.x) {
            return TicTacToeSquare.xWin;
          } else {
            return state[row][col];
          }
        });
      }));
      return true;
    } else if (!gameOver && checkForWin(TicTacToeSquare.o)) {
      gameOver = true;
      lastLoser = TicTacToeSquare.o;
      emit(List.generate(3, (row) {
        return List.generate(3, (col) {
          if (state[row][col] == TicTacToeSquare.o) {
            return TicTacToeSquare.oWin;
          } else {
            return state[row][col];
          }
        });
      }));
      return true;
    } else if (!gameOver && isBoardFull()) {
      // Добавляем проверку на ничью
      gameOver = true;
      lastLoser =
          currentPlayer; // Устанавливаем проигравшего игрока в текущего игрока
      emit(state); // Оставляем состояние доски без изменений
      return true;
    }
    return false;
  }

  void makeMove(int row, int col) {
    if (!gameOver && state[row][col] == TicTacToeSquare.empty) {
      final newState = List<List<TicTacToeSquare>>.from(state);
      newState[row][col] = currentPlayer;
      currentPlayer = currentPlayer == TicTacToeSquare.x
          ? TicTacToeSquare.o
          : TicTacToeSquare.x;

      emit(newState);
      checkForWinAndHighlight();
    }
  }

  void resetGame() {
    gameOver = false;
    currentPlayer =
        lastLoser; // Игрок, который проиграл, начинает следующую игру
    currentPlayer =
        lastLoser; // Игрок, который проиграл, начинает следующую игру
// Сбрасываем проигравшего игрока
    emit(List.generate(3, (_) => List.filled(3, TicTacToeSquare.empty)));

    if (currentPlayer == TicTacToeSquare.o) {
      makeComputerMove();
    }
  }

  bool checkForWin(TicTacToeSquare player) {
    // Проверка на горизонтальные, вертикальные и диагональные линии для победы
    for (int i = 0; i < 3; i++) {
      if (state[i][0] == player &&
          state[i][1] == player &&
          state[i][2] == player) {
        return true; // Горизонтальная линия
      }
      if (state[0][i] == player &&
          state[1][i] == player &&
          state[2][i] == player) {
        return true; // Вертикальная линия
      }
    }
    if (state[0][0] == player &&
        state[1][1] == player &&
        state[2][2] == player) {
      return true; // Диагональ (лево-верх -> право-низ)
    }
    if (state[0][2] == player &&
        state[1][1] == player &&
        state[2][0] == player) {
      return true; // Диагональ (право-верх -> лево-низ)
    }
    return false;
  }
}
