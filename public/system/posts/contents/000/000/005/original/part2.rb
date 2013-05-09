class WrongNumberOfPlayersError < StandardError ; end
class NoSuchStrategyError < StandardError ; end

def rps_result(m1, m2)
  # YOUR CODE HERE
end

def rps_game_winner(game)
  STRATEGY = ["P", "R", "S"]
  raise WrongNumberOfPlayersError unless game.length == 2
  raise NoSuchStrategyError  if !STRATEGY.include?(game[0][1]) || !STRATEGY.include?(game[1][1])
end

def rps_tournament_winner(tournament)
  # YOUR CODE HERE
end


