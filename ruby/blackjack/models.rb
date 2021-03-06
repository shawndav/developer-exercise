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


