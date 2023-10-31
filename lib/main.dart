import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/tic_tac_toe_screen.dart';

import 'game_logic_bloc.dart';

// События
class TicTacToeEvent {
  final int row;
  final int col;
  TicTacToeEvent(this.row, this.col);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      home: TicTacToeScreen(),
    );
  }
}
