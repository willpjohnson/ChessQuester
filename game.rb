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
      begin
        start_pos, end_pos = @current_player.get_move
        board.move_piece(start_pos, end_pos)
      rescue PickedWrongColorError
        puts "Can't pick enemy piece."
        puts "Please select again:"
        sleep(1)
        retry
      rescue PickedEmptySquareError
        puts "Can't pick piece at empty square."
        puts "Please select again:"
        sleep(1)
        retry
      rescue InvalidMoveError
        puts "Move is not valid."
        puts "Please select again:"
        sleep(1)
        retry
      end
      swap_turn!
    end
    puts "Checkmate! #{player_w.name} wins!" if board.checkmate?(:b)
    puts "Checkmate! #{player_b.name} wins!" if board.checkmate?(:w)
  end

  # private
  def notify_players
    # notify about check status
  end

  def swap_turn!
    # debugger
    if current_player.color == :w
      self.current_player = player_b
    elsif current_player.color == :b
      self.current_player = player_w
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end
