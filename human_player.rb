require_relative "cursor.rb"
require 'byebug'

class HumanPlayer
  attr_reader :name, :color, :display
  def initialize(name, color, display)
    @name = name
    @color = color
    @display = display
  end

  def wrong_color?(start_pos)
    piece_color = display.cursor.board[start_pos].color
    return false if piece_color.nil?
    piece_color != color
  end

  def get_move
    start_pos, end_pos = nil, nil
    until start_pos
      system("clear")
      display.render
      puts "#{name}, select your piece:"
      start_pos = display.cursor.get_input
    end
    raise PickedWrongColorError if wrong_color?(start_pos)
    until end_pos
      system("clear")
      display.render
      puts "#{name}, select your destination:"
      end_pos = display.cursor.get_input
    end
    # raise PickedWrongColorError if wrong_color?(start_pos)
    [start_pos,end_pos]
  end

end

class PickedWrongColorError < StandardError
end
