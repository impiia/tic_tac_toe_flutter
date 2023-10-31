Sure, here's a basic README for your Tic Tac Toe game with explanations about its usage and the implementation of the Min-Max algorithm for CPU logic. Please customize and expand it as needed.

# Tic Tac Toe Game with Flutter and Bloc

This is a simple Tic Tac Toe game implemented in Flutter with the use of the BLoC (Business Logic Component) pattern. Additionally, it features CPU logic based on the Min-Max algorithm for the opponent.

## Usage

To play the game, clone the repository to your local machine:

   ```bash
   git clone https://github.com/impiia/tic_tac_toe_flutter.git
   ```

## Features

- Implements the Tic Tac Toe game with a Flutter frontend.
- Utilizes the BLoC pattern for managing game state and logic.
- Provides options to play against the CPU with Min-Max algorithm-based logic.

## Min-Max Algorithm for CPU Logic

The CPU opponent in this game uses the Min-Max algorithm, which is a decision-making algorithm widely used in two-player games. It helps the CPU find the best move to maximize its chances of winning or minimize its chances of losing.

Here's an overview of how the Min-Max algorithm is implemented in the game:

1. The algorithm explores all possible moves on the game board recursively, simulating the outcomes of each move.

2. It assigns a score to each possible outcome. Positive scores indicate a winning move for the CPU, while negative scores mean a potential winning move for the opponent.

3. The CPU chooses the move with the highest score to maximize its chances of winning.

The Min-Max algorithm ensures that the CPU provides a challenging opponent that makes smart moves throughout the game.
