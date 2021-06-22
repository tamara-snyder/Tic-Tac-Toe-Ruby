class Player
  attr_reader :name, :symbol
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  # Prompt player to type their name
  def self.get_name(player_number)
    puts "Player #{player_number}: What is your name?"
    gets.chomp
  end
end

class Board
  attr_reader :board
  attr_accessor :plays

  WINNING_COMBOS = 
    [[0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6]]

  def initialize
    @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end

  # Pretty print the game board with current values
  def print_board
    puts ""
    puts "\t\t\t #{board[0]} | #{board[1]} | #{board[2]}"
    puts "\t\t\t-----------"
    puts "\t\t\t #{board[3]} | #{board[4]} | #{board[5]}"
    puts "\t\t\t-----------"
    puts "\t\t\t #{board[6]} | #{board[7]} | #{board[8]}"
    puts ""
  end

  def winner?
    check_arr = [1, 2, 3]
    WINNING_COMBOS.each {|combo|
      # Index is the index of the combo and value references an index on the board:
      combo.each_with_index {|value, index|
      check_arr[index] = @board[value]
      }
      # Check that only one symbol is used, e.g. ["X", "X", "X"]
      if check_arr.uniq.size == 1
        return true
      end
    }
    return false
  end

  def valid_move?(number)
    @board[number - 1] == number
  end

  def update_board(number, symbol)
    @board[number - 1] = symbol
    print_board
  end

  def board_full?
    @board.all? {|cell| cell == "X" || cell == "O"}
  end

  def game_over?
    board_full? || winner?
  end
end

class Game
  attr_reader :player_one, :player_two, :players
  attr_accessor :board, :current_player
  def initialize
    @board = Board.new
    @player_one = Player.new(Player.get_name(1), "X")
    @player_two = Player.new(Player.get_name(2), "O")
    @current_player = @player_one
  end

  def play
    set_up
    turns
    print_results
  end

  private
  def switch_player
    if @current_player == player_one
      player_two
    else
      player_one
    end
    
  end
  
  def current_symbol
    current_player.symbol
  end

  def set_up
    puts "Tic Tac Toe"
    puts "#{player_one.name} is Xs and #{player_two.name} is Os"
    puts "#{player_one.name} goes first"
    @board.print_board
  end

  def print_results
    if @board.winner?
      puts "#{switch_player.name} wins!"
    else
      puts "It's a draw :|"
    end
  end

  def turn_input(player)
    number = gets.chomp.to_i 
    return number if @board.valid_move?(number)
    
    puts "Try another space"
    turn_input(player)
  end

  def turn(player)
    puts "It's #{player.name}'s turn!"
    cell = turn_input(player)
    @board.update_board(cell, current_symbol)
  end

  def turns
    until @board.game_over?
      turn(current_player)
      @current_player = switch_player
    end
  end
end


# GAME DIALOGUE
def play_game
  game = Game.new
  game.play
  new_game
end

def new_game
  puts "Play again? Press 'y' for yes or 'n' for no."
  input = gets.chomp.downcase
  if input == 'y'
    play_game
  else
    puts "Thanks for playing!"
  end
end

play_game