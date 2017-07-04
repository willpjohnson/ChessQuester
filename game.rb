require_relative "board.rb"
require_relative "human_player.rb"

class Game
  attr_accessor :board, :current_player, :display
  attr_reader :player_w, :player_b
  def initialize
    @board = Board.new
    @display = Display.new(self.board)
  end

  def play
    intro
    until board.checkmate?(:w) || board.checkmate?(:b)
      begin
        notify_players if in_check?
        start_pos, end_pos = self.current_player.get_move
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

  private
  def intro
    system('clear')
    puts "        /$$$$$$  /$$
       /$$__  $$| $$
      | $$  \__/| $$$$$$$   /$$$$$$   /$$$$$$$ /$$$$$$$
      | $$      | $$__  $$ /$$__  $$ /$$_____//$$_____/
      | $$      | $$  \ $$| $$$$$$$$|  $$$$$$|  $$$$$$
      | $$    $$| $$  | $$| $$_____/ \____  $$\____  $$
      |  $$$$$$/| $$  | $$|  $$$$$$$ /$$$$$$$//$$$$$$$/
       \______/ |__/  |__/ \_______/|_______/|_______/



  /$$$$$$                                 /$$
 /$$__  $$                               | $$
| $$  \ $$ /$$   /$$  /$$$$$$   /$$$$$$$/$$$$$$    /$$$$$$   /$$$$$$
| $$  | $$| $$  | $$ /$$__  $$ /$$_____/_  $$_/   /$$__  $$ /$$__  $$
| $$  | $$| $$  | $$| $$$$$$$$|  $$$$$$  | $$    | $$$$$$$$| $$  \__/
| $$/$$ $$| $$  | $$| $$_____/ \____  $$ | $$ /$$| $$_____/| $$
|  $$$$$$/|  $$$$$$/|  $$$$$$$ /$$$$$$$/ |  $$$$/|  $$$$$$$| $$
 \____ $$$ \______/  \_______/|_______/   \___/   \_______/|__/
      \__/

                                                                     "
    puts "Player 1 (white):"
    name1 = gets.chomp
    puts "Player 2 (black):"
    name2 = gets.chomp
    @player_w = HumanPlayer.new(name1,:w,self.display)
    @player_b = HumanPlayer.new(name2,:b,self.display)
    @current_player = @player_w
    system('clear')
  end

  def in_check?
    @board.in_check?(:b) || @board.in_check?(:w)
  end

  def notify_players
    if self.board.in_check?(:b)
      puts "#{self.player_b.name} is in check!"
    elsif self.board.in_check?(:w)
      puts "#{self.player_w.name} is in check!"
    end
    sleep(1)
  end

  def swap_turn!
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
