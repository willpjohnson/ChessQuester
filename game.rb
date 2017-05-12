require_relative "board.rb"
require_relative "human_player.rb"
require 'byebug'
class Game
  attr_accessor :board, :current_player, :display
  attr_reader :player_w, :player_b
  def initialize
    @board = Board.new
    @display = Display.new(self.board)
    # debugger
    @player_w = HumanPlayer.new("Will",:w,self.display)
    @player_b = HumanPlayer.new("Tron",:b,self.display)
    @current_player = @player_w
  end

  def play
    until board.checkmate?(:w) || board.checkmate?(:b)
      # system('clear')
      # display.render
      # display.cursor.get_input
      start_pos, end_pos = @current_player.get_move
      board.move_piece(start_pos, end_pos)
      swap_turn!
    end
  end

  private
  def notify_players
    # notify about check status
  end

  def swap_turn!
    if current_player == player_w
      current_player = player_b
    elsif current_player == player_b
      current_player = player_w
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end
