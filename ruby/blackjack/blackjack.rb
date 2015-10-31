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
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards
  attr_reader :blackjack
  attr_reader :bust

  def initialize(initial_cards)
    @cards = []
    @bust = false
    @blackjack = false
    initial_cards.each{|card| add_card(card)}
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
    value_sum = @cards.select{|card| card.name != :ace}.map{|card| card.value}.reduce(:+)
    return [value_sum + 1, value_sum + 11]
  end

  def count_without_ace
    @cards.map{|card| card.value}.reduce(:+)
  end

end

# test_deck = Deck.new

# cards = [Card.new(:hearts, :ten, 10),Card.new(:hearts, :ace, 11)]

# test_hand = Hand.new(cards)

# p test_hand.bust?
# p test_hand.blackjack






require 'test/unit'


# class CardTest < Test::Unit::TestCase
#   def setup
#     @card = Card.new(:hearts, :ten, 10)
#   end

#   def test_card_suite_is_correct
#     assert_equal @card.suite, :hearts
#   end

#   def test_card_name_is_correct
#     assert_equal @card.name, :ten
#   end
#   def test_card_value_is_correct
#     assert_equal @card.value, 10
#   end
# end

# class DeckTest < Test::Unit::TestCase
#   def setup
#     @deck = Deck.new
#   end

#   def test_new_deck_has_52_playable_cards
#     assert_equal @deck.playable_cards.size, 52
#   end

#   def test_dealt_card_should_not_be_included_in_playable_cards
#     card = @deck.deal_card
#     refute(@deck.playable_cards.include?(card))
#   end

#   def test_shuffled_deck_has_52_playable_cards
#     @deck.shuffle
#     assert_equal @deck.playable_cards.size, 52
#   end
# end

class HandTest < Test::Unit::TestCase

  def setup
    cards = [Card.new(:hearts, :ten, 10),Card.new(:clubs, :five, 5)]
    blackjack_cards = [Card.new(:hearts,:ten,10),Card.new(:hearts,:ace,[1,11])]
    @hand = Hand.new(cards)
    @blackjack_hand = Hand.new([Card.new(:hearts,:ten,10),Card.new(:hearts,:ace,[1,11])])
  end

  def test_hand_is_initialized_with_two_cards
    assert_equal @hand.cards.count, 2
  end

  def test_hand_is_not_bust
    refute(@hand.bust)
  end

  def test_hand_is_not_blackjack
    refute(@hand.blackjack)
  end

  def test_hand_does_not_have_ace
    refute(@hand.include_ace?)
  end

  def test_hand_can_have_ace_added
    @hand.add_card(Card.new(:hearts, :ace, [11,1]))
    assert(@hand.include_ace?)
  end

  def test_hand_card_count_updates_when_card_added
    @hand.add_card(Card.new(:hearts, :ace, [11,1]))
    assert_equal @hand.cards.count, 3
  end

  def test_hand_can_get_blackjack_when_card_added
    @hand.add_card(Card.new(:hearts, :six, 6))
    assert(@hand.blackjack)
  end

  def test_hand_can_get_blackjack_with_only_two_cards
    assert(@blackjack_hand.blackjack)
  end

  def test_hand_can_go_bust
    @hand.add_card(Card.new(:spades, :ten, 10))
    assert(@hand.bust)
  end



end