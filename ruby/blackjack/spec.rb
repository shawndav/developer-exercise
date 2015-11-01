require 'test/unit'
require_relative 'helper'


class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end

  def test_card_suite_is_correct
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end

  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end

  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    refute(@deck.playable_cards.include?(card))
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end

class HandTest < Test::Unit::TestCase

  def setup
    @hand = Hand.new(Card.new(:hearts, :ten, 10),Card.new(:clubs, :five, 5))
    @blackjack_hand = Hand.new(Card.new(:hearts,:ten,10),Card.new(:hearts,:ace,[1,11]))
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