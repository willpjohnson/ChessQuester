require_relative "cursor.rb"
require_relative "board.rb"
require 'colorize'
require 'byebug'
# class NilClass
#   def symbol
#     "   "
#   end
# end
class Display
  attr_accessor :cursor
  def initialize(board)
    @cursor = Cursor.new([0,0], board)
  end

  PIECE_HASH = {}

  def render
    @cursor.board.grid.each_with_index do |row, row_index|
      row_render = []
      row.each_with_index do |square, index|
        piece = @cursor.board[[row_index,index]]
        if [row_index, index] == @cursor.cursor_pos
          row_render << piece.symbol.colorize(:background => :yellow)
        elsif row_index.even?
          row_render << piece.symbol.colorize(:background => :light_black) if index.even?
          row_render << piece.symbol.colorize(:background => :light_white) if index.odd?
        else
          row_render << piece.symbol.colorize(:background => :light_white) if index.even?
          row_render << piece.symbol.colorize(:background => :light_black) if index.odd?
        end
      end
      puts row_render.join
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Display.new(Board.new)
  until "word" == "not_word"
    system('clear')
    game.render
    game.cursor.get_input

  end
end
