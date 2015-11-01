class Game
  @@view = View

  def initialize
    @players = [Player.new('Player 1'), Player.new('Player 2')]
    @dealer = Dealer.new('The Dealer')
    @deck = Deck.new
    @round_number = 0
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
    deal_hand(@dealer)
    @@view.display_single_card(@dealer.name,@dealer.hands.last.cards.last)
  end

  def draw_card(user)
    card = @deck.deal_card
    @@view.display_single_card(user.name,card)
    user.hands.last.add_card(card)
  end

  def deal_player_hands
    @players.each do |player|
      deal_hand(player)
      @@view.display_two_cards(player.name,player.hands.last.cards)
      evaluate_player_hand(player)
    end
  end

  def deal_hand(user)
    user.hands << Hand.new(@deck.deal_card,@deck.deal_card)
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