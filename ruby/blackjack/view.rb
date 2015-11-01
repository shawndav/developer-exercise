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