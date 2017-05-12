require_relative 'piece.rb'

class Knight < Piece
  include Stepable
  def symbol
    return " ♘ " if self.color == :w
    return " ♞ " if self.color == :b
  end

  protected
  def move_diffs
    [[1,2],
     [2,1],
     [-1,2],
     [-2,1],
     [1,-2],
     [2,-1],
     [-1,-2],
     [-2,-1]]
  end

end

class King < Piece
  include Stepable

  def symbol
    return " ♔ " if self.color == :w
    return " ♚ " if self.color == :b
  end

  protected
  def move_diffs
    [[-1,-1],
     [-1,0],
     [-1,1],
     [0,-1],
     [0,1],
     [1,-1],
     [1,0],
     [1,1]]
  end

end
