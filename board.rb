require_relative "pieces/piece.rb"
require_relative "pieces/null_piece.rb"
require_relative "pieces/stepping_pieces.rb"
require_relative "pieces/sliding_pieces.rb"
require_relative "pieces/pawn.rb"
require_relative "display.rb"
require_relative "cursor.rb"

class Board
  attr_accessor :grid
  def initialize(fill = true)
    @grid = Array.new(8) {Array.new(8)}
    make_starting_grid if fill
  end

  def self.all_null_pieces
    board = Board.new(false)
    board.grid = Array.new(8) { Array.new(8) { NullPiece.instance }}
    board
  end

  def move_piece(start_pos, end_pos)
    if self[start_pos] ==  NullPiece.instance
      raise PickedEmptySquareError.new
    elsif !self[start_pos].valid_moves.include?(end_pos)
      raise InvalidMoveError.new
    end

    if white_castling(start_pos, end_pos)
      move_piece!([7,7], [7,5])
    elsif black_castling(start_pos, end_pos)
      move_piece!([0,7], [0,5])
    end
    move_piece!(start_pos, end_pos)
  end

  def move_piece!(start_pos, end_pos)
    self[end_pos] = self[start_pos]
    self[end_pos].position = end_pos
    self[start_pos] = NullPiece.instance
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    grid[row][col] = piece
  end

  def color_at(pos)
    self[pos].color
  end

  def dup
    board2 = Board.new(false)

    grid.each_with_index do |row, i|
      row.each_with_index do |col, j|
        piece = self[[i,j]]
        if piece.class == NullPiece
          board2[[i,j]] = NullPiece.instance
        else
          piece.class.new(piece.position,piece.color,board2)
        end
      end
    end

    board2
  end

  def check_all_moves(color)
    all_moves = []
    grid.flatten.each do |piece|
      if piece.color == color && piece.class != NullPiece
        all_moves << piece.moves
      end
    end
    all_moves
  end

  def check_all_pieces(color)
    all_pieces = []
    grid.flatten.each do |piece|
      all_pieces << piece if piece.color == color
    end
    all_pieces
  end

  def in_check?(color)
    king_pos = find_king(color)
    enemy_color = :w if color == :b
    enemy_color = :b if color == :w
    all_enemy_moves = check_all_moves(enemy_color)
    all_enemy_moves.each do |piece_moves|
      next if piece_moves.empty?
      piece_moves.each do |move|
        return true if king_pos == move
      end
    end
    false
  end

  def checkmate?(color)
    #king has no more valid moves
    return false unless in_check?(color)
    all_pieces = check_all_pieces(color)
    all_pieces.each do |piece|
      return false unless piece.valid_moves.empty?
    end
    true
  end

  private
  def make_starting_grid
    (2..5).each do |row| #MAKE NULL PIECES
      (0..7).each do |column|
        self[[row,column]] = NullPiece.instance
      end
    end

    (1..6).each do |row| #MAKE PAWNS
      (0..7).each do |column|
        next if row > 1 && row < 6
        self[[row,column]] = Pawn.new([row,column],:b,self) if row == 1
        self[[row,column]] = Pawn.new([row,column],:w,self) if row == 6
      end
    end

    Knight.new([0,1],:b,self)
    Knight.new([0,6],:b,self)
    Knight.new([7,1],:w,self)
    Knight.new([7,6],:w,self)
    King.new([7,4],:w,self)
    King.new([0,4],:b,self)
    Queen.new([7,3],:w,self)
    Queen.new([0,3],:b,self)
    Bishop.new([7,2],:w,self)
    Bishop.new([7,5],:w,self)
    Bishop.new([0,2],:b,self)
    Bishop.new([0,5],:b,self)
    Rook.new([0,0],:b,self)
    Rook.new([0,7],:b,self)
    Rook.new([7,0],:w,self)
    Rook.new([7,7],:w,self)
  end

  def find_king(color)
    grid.each_with_index do |row, i|
      row.each_with_index do |col, j|
        return [i,j] if self[[i,j]].class == King && self[[i,j]].color == color
      end
    end
  end

  def white_castling(start_pos, end_pos)
    return true if self[start_pos].class == King && start_pos == [7,4] && end_pos == [7,6]
    false
  end

  def black_castling(start_pos, end_pos)
    return true if self[start_pos].class == King && start_pos == [0,4] && end_pos == [0,6]
    false
  end

end

class PickedEmptySquareError < StandardError
end

class InvalidMoveError < StandardError
end
