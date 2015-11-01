class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    create_cards
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  #I renamed this create_cards becuase it only fills the playable_cards array with card objects. I created a shuffle_card method that actually randomizes the order of playable_cards.

  def create_cards
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end

  def shuffle
    @playable_cards.shuffle!
  end

end

class Hand
  attr_accessor :cards, :stay
  attr_reader :blackjack
  attr_reader :bust

  def initialize(card_1,card_2)
    @cards = [card_1,card_2]
    @bust = false
    @blackjack = false
    @stay = false
    evaluate_hand
  end

  def add_card(card)
    @cards << card
    evaluate_hand
  end

  def evaluate_hand
    @bust = true if bust?
    @blackjack = true if blackjack?
  end

  def bust?
    if !include_ace?
      return count_without_ace > 21
    else
      return count_with_ace.all?{|value| value > 21}
    end
  end

  def blackjack?
    if !include_ace?
      return count_without_ace == 21
    else
      return count_with_ace.any?{|value| value == 21}
    end
  end

  def include_ace?
    @cards.map{|card| card.name}.include?(:ace)
  end

  def count_with_ace
    other_cards = @cards.select{|card| card.name != :ace}.map{|card| card.value.to_i}
    if other_cards.length == 1
      value_sum = other_cards[0]
    else
      value_sum = other_cards.reduce(:+)
    end
    return [value_sum + 1, value_sum + 11]
  end

  def count_without_ace
    @cards.map{|card| card.value}.reduce(:+)
  end

  def bust_blackjack_or_stay?
    return true if blackjack?
    return true if bust?
    return true if stay
    return false
  end

end


class User
  attr_accessor :hands
  attr_reader :name

  def initialize(name)
    @hands = []
    @name = name
  end
end

class Player < User
end

class Dealer < User

  def stop_drawing_cards?
    if @hands.last.include_ace?
      count = @hands.last.count_with_ace.min
    else
      count = @hands.last.count_without_ace
    end
    if count > 17
      return true
    else
      return false
    end
  end

end


class View

  def self.display_single_card(name,card)
    puts "#{name} drew a #{card.name} of #{card.suite}"
  end

  def self.display_two_cards(name,cards)
    puts "#{name} drew a #{cards.first.name} of #{cards.first.suite} and a #{cards.last.name} of #{cards.last.suite}"
  end

  def self.display_player_blackjack(name)
    puts "#{name} got blackjack!"
  end

  def self.display_player_bust(name)
    puts "#{name} went bust!"
  end

  def self.display_player_stay(name)
    puts "#{name} decided to stay."
  end

  def self.hit_or_stay(name)
    puts "#{name}, would you like to hit or stay"
    input = nil
    until input == "hit" || input == "stay" do
      puts "please enter 'hit' or 'stay'"
      input = gets.chomp.downcase
    end
    return input
  end

  def self.round_over(round_number)
    puts "Round #{round_number} is over. Results:"
  end

  def self.user_round_total(name,total)
    puts "#{name} got a total of #{total}."
  end

  def self.user_round_total_with_ace(name,totals)
    puts "#{name} had an ace and got a total of either #{totals[0]} or #{totals[1]}."
  end

end


class Game
  @@view = View

  def initialize
    @players = [Player.new('Player 1'), Player.new('Player 2')]
    @dealer = Dealer.new('The Dealer')
    @deck = Deck.new
    @round_number = 0
  end

  def play_game

  end

  def play_round
    @round_number += 1
    deal_dealer_hand
    deal_player_hands
    players_hit_or_stay
    dealer_draws_additional_cards
    round_result
  end

  def deal_dealer_hand
    @dealer.hands << Hand.new(@deck.deal_card,@deck.deal_card)
    @@view.display_single_card(@dealer.name,@dealer.hands.last.cards.last)
  end

  def draw_card(user)
    card = @deck.deal_card
    @@view.display_single_card(user.name,card)
    user.hands.last.add_card(card)
  end

  def deal_player_hands
    @players.each do |player|
      deal_player_hand(player)
      evaluate_player_hand(player)
    end
  end

  def deal_player_hand(player)
    player.hands << Hand.new(@deck.deal_card,@deck.deal_card)
    @@view.display_two_cards(player.name,player.hands.last.cards)
  end

  def evaluate_player_hand(player)
    if player.hands.last.blackjack
      @@view.display_player_blackjack(player.name)
    elsif player.hands.last.bust
      @@view.display_player_bust(player.name)
    elsif player.hands.last.stay
      @@view.display_player_stay(player.name)
    end
  end

  def players_hit_or_stay
    @players.each do |player|
      until player.hands.last.bust_blackjack_or_stay?
        hit_or_stay(player)
        evaluate_player_hand(player)
      end
    end
  end

  def hit_or_stay(player)
    action = @@view.hit_or_stay(player.name)
    if action == 'hit'
      draw_card(player)
    else
      player.hands.last.stay = true
    end
  end

  def dealer_draws_additional_cards
    until @dealer.stop_drawing_cards? || @dealer.hands.last.bust_blackjack_or_stay? do
      draw_card(@dealer)
    end
  end

  def round_result
    @@view.round_over(@round_number)
    user_round_result(@dealer)
    @players.each do |player|
      user_round_result(player)
    end
  end

  def user_round_result(user)
    if user.hands.last.include_ace?
      @@view.user_round_total_with_ace(user.name,user.hands.last.count_with_ace)
    else
      @@view.user_round_total(user.name,user.hands.last.count_without_ace)
    end
    if user.hands.last.blackjack
      @@view.display_player_blackjack(user.name)
    end
    if user.hands.last.bust
      @@view.display_player_bust(user.name)
    end
  end

end