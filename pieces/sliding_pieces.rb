require_relative 'piece.rb'

class Bishop < Piece
  include Slideable
  def symbol
    return " ♗ " if self.color == :w
    return " ♝ " if self.color == :b
  end

  protected
  def move_dirs
    diagonal_dirs
  end
end

class Rook < Piece
  include Slideable
  def symbol
    return " ♖ " if self.color == :w
    return " ♜ " if self.color == :b
  end

  protected
  def move_dirs
    horizontal_dirs
  end
end

class Queen < Piece
  include Slideable
  def symbol
    return " ♕ " if self.color == :w
    return " ♛ " if self.color == :b
  end

  protected
  def move_dirs
    horizontal_dirs + diagonal_dirs
  end
end
