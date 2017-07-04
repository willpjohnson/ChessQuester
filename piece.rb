class Piece
  attr_reader :color
  attr_accessor :position, :board
  def initialize(position, color, board)
    @position = position
    @color = color
    @board = board

    board[position] = self
  end

  def inspect
    [self.class,self.color,self.position]
  end

  def to_s
    symbol
  end

  def symbol
    self.symbol
  end

  def valid_moves
    moves.reject{|move| move_into_check?(move)}
  end

  def move_into_check?(end_pos)
    test_board = board.dup
    test_board.move_piece!(self.position,end_pos)
    test_board.in_check?(self.color)
  end

end

module Slideable
  def moves
    grow_unblocked_moves_in_dir
  end

  private
  def move_dirs
    move_dirs
  end

  def horizontal_dirs
    [[1,0],
     [-1,0],
     [0,1],
     [0,-1]]
  end

  def diagonal_dirs
    [[-1,-1],
     [1,-1],
     [1,1],
     [-1,1]]
  end

  def capturable?(move, color)
    move_color = board[move].color
    return false if move_color == nil
    return false if move_color == color
    true
  end

  def same_color?(move, color)
    board[move].color == color
  end

  def null_piece?(move)
    board[move].class == NullPiece
  end

  def on_board?(move)
    move[0] >= 0 && move[0] <= 7 && move[1] >= 0 && move[1] <= 7
  end

  def grow_unblocked_moves_in_dir
    total_moves = []
    move_dirs.each do |dir|
      move = self.position
      direction_complete = false
      until direction_complete
        move = [move[0]+dir[0], move[1]+dir[1]]
        if !on_board?(move)
          direction_complete = true
        elsif capturable?(move, color)
          total_moves << move
          direction_complete = true
        elsif null_piece?(move)
          total_moves << move
          direction_complete = false
        elsif same_color?(move, color)
          direction_complete = true
        end
      end
    end
    total_moves
  end
end

module Stepable
  def on_board?(move)
    move[0] >= 0 && move[0] <= 7 && move[1] >= 0 && move[1] <= 7
  end

  def list_of_moves
    move_diffs.map do |move|
      [self.position[0]+move[0],self.position[1]+move[1]]
    end
  end

  def moves
    on_board_moves = list_of_moves.select { |move| on_board?(move) }
    available_moves = on_board_moves.reject { |move| board.color_at(move) == self.color }
    available_moves << castle_move if castleable?
    available_moves
  end

  def castleable?
    return false if self.class != King
    if self.color == :w
      return false if self.position != board[[7,4]] && board[[7,7]].class != Rook
      return false unless board[[7,5]].class == NullPiece && board[[7,6]].class == NullPiece
    elsif self.color == :b
      return false if self.position != board[[0,4]] && board[[0,7]].class != Rook
      return false unless board[[0,5]].class == NullPiece && board[[0,6]].class == NullPiece
    end
    true
  end

  def castle_move
    if color == :w
      [7,6]
    elsif color == :b
      [0,6]
    end
  end

  private
  def move_diffs
    move_diffs
  end
end
