module Hand
  def show_hand
    puts "---- #{self.class} Hand ----"
    cards.each do |card|
      puts "=> #{card}"
    end
  end

  def hit(deal)
    cards << deal
  end

  def busted?
    total > 21
  end

  def won?
    total == 21
  end

  def ace_correction
    cards.select { |card| card.face == 'Ace' }.count.times do
      break if total <= 21

      total - 10
    end
  end

  def total
    total = 0
    cards.each do |card|
      if card.face == 'Ace'
        total += 11
      elsif card.face == 'Jack' || card.face == 'Queen' || card.face == 'King'
        total += 10
      else
        total += card.face.to_i
      end
    end
    ace_correction
    total
  end
end

class Participant
  include Hand

  attr_accessor :cards

  def initialize
    @cards = []
  end
end

class Player < Participant
  def stay
    true
  end
end

class Dealer < Participant
  def initialize
    # seems like very similar to Player... do we even need this?
  end

  def show_initial_hand
    puts "---- Dealer's Hand ----"
    puts "=> #{cards[0]}"
    puts '=> Unknown card'
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::FACES.each do |face|
        @cards << Card.new(face, suit)
      end
    end
  end

  def deal_two
    cards.shuffle!
    cards.pop(2)
  end

  def deal_one
    cards.pop
  end
end

class Card
  SUITS = %w[Diamonds Clubs Hearts Spades].freeze
  FACES = %w[1 2 3 4 5 6 7 8 9 10 Jack Queen King].freeze

  attr_reader :face, :suit

  def initialize(face, suit)
    @suit = suit
    @face = face
  end

  def to_s
    "#{@face} of #{@suit}"
  end
end

class Game
  attr_reader :player, :dealer
  attr_accessor :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def display_welcome_message
    puts 'Welcome to the game of 21!'
    puts ''
  end

  def reset
    self.deck = Deck.new
    player.cards = []
    dealer.cards = []
  end

  def deal_cards
    player.cards = deck.deal_two
    dealer.cards = deck.deal_two
  end

  def show_initial_cards
    player.show_hand
    puts ''
    dealer.show_initial_hand
  end

  def player_turn
    puts ''
    puts 'Player turn!'

    answer = nil
    loop do
      loop do
        puts 'Hit or Stay? (Enter h or s)'
        answer = gets.chomp.downcase
        break if answer.include?('h') || answer.include?('s')

        puts 'Sorry, invalid choice.'
      end

      if answer == 'h'
        puts 'The Player hits.'
        player.hit(deck.deal_one)
        player.show_hand
        puts "The Player total is: #{player.total}"
      elsif answer == 's'
        player.stay
        puts 'Player chose to stay.'
        break
      end

      break if player.busted? || player.won?
    end
  end

  def dealer_turn
    puts ''
    puts 'Dealer turn!'
    loop do
      dealer.hit(deck.deal_one)
      puts 'The Dealer hits.'
      dealer.show_hand
      puts "The Dealer total is: #{dealer.total}"
      break if dealer.total >= 17 || dealer.busted?
    end
  end

  def detect_winner(dealer_total, player_total)
    if player.won?
      puts 'Player Wins!'
    elsif dealer.busted?
      puts 'Dealer Busted!'
      puts 'Player Wins!'
    elsif player.busted?
      puts 'Player Busted!'
      puts 'Dealer Wins!'
    elsif dealer_total < player_total
      puts 'Player Wins'
    elsif dealer_total > player_total
      puts 'Dealer wins'
    end
  end

  def show_result
    detect_winner(dealer.total, player.total)
  end

  def play_again?
    answer = nil
    loop do
      puts ''
      puts 'Do you want to play again? (y or n)'
      answer = gets.chomp.downcase
      break if answer.include?('y') || answer.include?('n')

      put 'Sorry invalid choice.'
    end
    return true if answer == 'y'

    false
  end

  def start
    display_welcome_message

    loop do
      deal_cards
      show_initial_cards
      player_turn
      dealer_turn unless player.busted? || player.won?
      show_result
      break unless play_again?

      reset
    end
    puts 'Thanks for playing!'
  end
end

Game.new.start
