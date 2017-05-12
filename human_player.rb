require_relative "cursor.rb"

class HumanPlayer
  attr_reader :name, :color, :display
  def initialize(name, color, display)
    @name = name
    @color = color
    @display = display
  end

  def get_move
    start_pos, end_pos = nil, nil
    until start_pos
      system("clear")
      display.render
      puts "#{name}, select your piece:"
      start_pos = display.cursor.get_input
    end
    until end_pos
      system("clear")
      display.render
      puts "#{name}, select your destination:"
      end_pos = display.cursor.get_input
    end
    [start_pos,end_pos]
  end

end
