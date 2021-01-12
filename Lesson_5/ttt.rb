require "pry"
class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select {|key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def computer_defense
    square = nil
    WINNING_LINES.each do |line|
      square = find_at_risk_square(line)
      break if square
    end
    square
  end

  def computer_offense
    square = nil
    WINNING_LINES.each do |line|
      square = find_winning_square(line)
      break if square
    end
    square
  end

  def reset
    (1..9).each {|key| @squares[key] = Square.new}
  end

  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end

  def find_at_risk_square(line)
      marker = @squares.values_at(*line).select(&:marked_x?).collect(&:marker)
    if marker.size == 2
      return @squares.select { |k,v| line.include?(k) && v.unmarked? }.keys.first
    else
      nil
    end
  end

  def find_winning_square(line)
    marker = @squares.values_at(*line).select(&:marked_o?).collect(&:marker)
    if marker.size == 2
      return @squares.select { |k,v| line.include?(k) && v.unmarked? }.keys.first
    else
      nil
    end
  end

end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def marked_x?
    marker == TTTGame::HUMAN_MARKER
  end

  def marked_o?
    marker == TTTGame::COMPUTER_MARKER
  end

end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"

  @@human_score = 0
  @@computer_score = 0

  attr_reader :board, :human, :computer, :current_marker

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker
  end

  def play
    clear
    display_welcome_message
    choose_first_move

    loop do
      #choose_marker
      clear_screen_and_display_board

      loop do
        current_player_moves
        break if board.someone_won? || board.full?
        display_board if human_turn?
        clear_screen_and_display_board

      end

      display_result
      display_score
      break unless play_again?
      reset
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def choose_first_move
    puts "Please select you goes first: (Human or Computer)"
    player = nil
    loop do
      player = gets.chomp.downcase
      break if player == "human" || player == "computer"
      puts "Sorry, that's not a valid choice."
    end

    if player == "human"
      @current_marker = HUMAN_MARKER
    else
      @current_marker = COMPUTER_MARKER
    end
  end

  #   def choose_marker
  #   puts "Please select your marker: (X or O)"
  #   marker = nil
  #   loop do
  #     marker = gets.chomp.upcase
  #     break if marker == "X" || marker == "O"
  #     puts "Sorry, that's not a valid choice."
  #   end
  # end

  def joinor(array, delim1 = ', ', delim2 = ', ')
    if array.size < 3
      array.join(" or ")
    else
      array[0..-3].join(delim1) + delim1 + array[-2..-1].join(delim2)
    end
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys, ', ', ' or ')}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    if board.computer_defense == nil
      square = board.computer_offense
    end

    if board.computer_offense == nil
      square = board.computer_defense
    end

    if board.unmarked_keys.include?(5)
      square = 5
    end

    if board.computer_defense == nil && board.computer_offense == nil
      square = board.unmarked_keys.sample
    end

    #binding.pry
    board[square] = computer.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
  end

  def human_score
    @@human_score += 1 if board.winning_marker == TTTGame::HUMAN_MARKER
    @@human_score
  end

  def computer_score
    @@computer_score += 1 if board.winning_marker == TTTGame::COMPUTER_MARKER
    @@computer_score
  end

  def display_score
    puts "Your score is #{human_score}"
    puts "Computer score is #{computer_score}"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def clear
    system "clear"
  end

  def reset
    board.reset
    choose_first_move
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

game = TTTGame.new
game.play