import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game_logic_bloc.dart';

class TicTacToeScreen extends StatelessWidget {
  const TicTacToeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TicTacToeCubit(),
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              'Tic Tac Toe Game',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold, // Жирный стиль
                color: Colors.blue, // Классический синий цвет
              ),
            ),
            Align(
              alignment:
                  Alignment.center, // Горизонтальное выравнивание по центру
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap:
                    true, // Разрешает сетке занимать только необходимое место по вертикали
                children: [
                  for (int row = 0; row < 3; row++)
                    for (int col = 0; col < 3; col++)
                      BlocBuilder<TicTacToeCubit, List<List<TicTacToeSquare>>>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<TicTacToeCubit>()
                                  .handleCellTap(row, col);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue,
                                ),
                                color: _getCellColor(state[row][col]),
                              ),
                              child: Center(
                                child: _buildSymbol(state[row][col]),
                              ),
                            ),
                          );
                        },
                      ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Отступ между сеткой и кнопкой
            BlocBuilder<TicTacToeCubit, List<List<TicTacToeSquare>>>(
              builder: (context, state) {
                return Column(
                  children: [
                    _buildWinMessage(state),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<TicTacToeCubit>().resetGame();
                      },
                      icon: const Icon(Icons.refresh), // Иконка перезагрузки
                      label: const Text(
                        'New Game',
                        style: TextStyle(
                            fontSize: 20), // Увеличиваем размер текста
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.0), // Круглые углы
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12), // Увеличиваем отступы
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getCellColor(TicTacToeSquare square) {
    switch (square) {
      case TicTacToeSquare.xWin:
        return Colors.green;
      case TicTacToeSquare.oWin:
        return Colors.blue;
      default:
        return Colors.white;
    }
  }

  Widget _buildWinMessage(List<List<TicTacToeSquare>> state) {
    bool xWins =
        state.any((row) => row.any((square) => square == TicTacToeSquare.xWin));
    bool oWins =
        state.any((row) => row.any((square) => square == TicTacToeSquare.oWin));

    if (xWins) {
      return const Text('You wins!',
          style: TextStyle(fontSize: 24, color: Colors.green));
    } else if (oWins) {
      return const Text('CPU wins!',
          style: TextStyle(fontSize: 24, color: Colors.blue));
    } else if (isBoardFull(state)) {
      return const Text('It\'s a draw!',
          style: TextStyle(fontSize: 24, color: Colors.black));
    } else {
      return const Text('',
          style: TextStyle(fontSize: 24, color: Colors.black));
    }
  }

  bool isBoardFull(List<List<TicTacToeSquare>> state) {
    return state
        .every((row) => row.every((square) => square != TicTacToeSquare.empty));
  }

  Widget _buildSymbol(TicTacToeSquare square) {
    switch (square) {
      case TicTacToeSquare.x:
        return const Text('X', style: TextStyle(fontSize: 24));
      case TicTacToeSquare.o:
        return const Text('O', style: TextStyle(fontSize: 24));
      case TicTacToeSquare.empty:
      default:
        return const SizedBox.shrink();
    }
  }
}
