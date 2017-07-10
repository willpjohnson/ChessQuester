![main-title](/images/main-title.png)

ChessQuester is a 2-player chess game for terminal written in Ruby.

To play, clone this git onto your computer and run 'ruby game.rb'.

## Game Details

ChessQuest is played by two players, each using the same set of controls. In the starting screen, each player enters their name. During gameplay, players control the cursor with the arrow keys and make selections with the enter key.

![gameplay](/images/gameplay.png)

The game is played with traditional chess rules. Players take turns moving their pieces according to that piece's move set until one player puts the other in checkmate. Like in physical chess, players are not allowed to move into a position that places them in check or, if they are already in check, doesn't get them out of it. This is enforced by a move checking algorithm which scans through all of a piece's open spots for a potential move. For each of these moves, the board is duplicated and the potential move is made in the new board. If the new scenario in the duplicate board results in the player being in check, the potential move is rejected from the list.

```ruby
def valid_moves
  moves.reject{|move| move_into_check?(move)}
end

def move_into_check?(end_pos)
  test_board = board.dup
  test_board.move_piece!(self.position,end_pos)
  test_board.in_check?(self.color)
end
```

The game also allows for non-traditional piece moves such as castling and two-square pawn moving.
