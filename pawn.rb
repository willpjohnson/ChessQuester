require_relative 'piece.rb'
require 'byebug'

class Pawn < Piece
  def symbol
    return " ♙ " if self.color == :w
    return " ♟ " if self.color == :b
  end

  def moves
    move_dirs
  end

  # protected
  def at_start_row?
    if self.color == :w
      return true if position[0] == 6
      false
    elsif self.color == :b
      return true if position[0] == 1
      false
    end
  end

  def forward_dir
    return [1,0] if self.color == :b
    return [-1,0] if self.color == :w
  end

  def forward_steps
    moves = []
    current = self.position
    one = forward_dir
    two = forward_dir.map {|dir| dir*2}
    if at_start_row?
      moves << [current[0]+one[0],current[1]+one[1]]
      moves << [current[0]+two[0],current[1]+two[1]]
    else
      moves << [current[0]+one[0],current[1]+one[1]]
    end
    moves
  end

  def side_attacks
    diags = []
    if self.color == :b
      diags << [self.position[0]+1,self.position[1]+1] if on_board?([self.position[0]+1,self.position[1]+1])
      diags << [self.position[0]+1,self.position[1]-1] if on_board?([self.position[0]+1,self.position[1]-1])
    elsif self.color == :w
      diags << [self.position[0]-1,self.position[1]+1] if on_board?([self.position[0]-1,self.position[1]+1])
      diags << [self.position[0]-1,self.position[1]-1] if on_board?([self.position[0]-1,self.position[1]-1])
    end

    good_diags = diags.reject do |pos|
      board[pos].color == self.color || board[pos].class == NullPiece
    end
    good_diags
  end

  def move_dirs
    forward_steps + side_attacks
  end

  def on_board?(move)
    move[0] >= 0 && move[0] <= 7 && move[1] >= 0 && move[1] <= 7
  end
end
