require_relative "cursor.rb"
require_relative "board.rb"
require 'colorize'

class Display
  attr_accessor :cursor
  def initialize(board)
    @cursor = Cursor.new([0,0], board)
  end

  PIECE_HASH = {}

  def render
    self.cursor.board.grid.each_with_index do |row, row_index|
      row_render = []
      row.each_with_index do |square, index|
        piece = self.cursor.board[[row_index,index]]
        if [row_index, index] == self.cursor.cursor_pos
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
