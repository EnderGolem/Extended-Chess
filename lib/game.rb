class Game
  attr_reader :players, :position

  def initialize(players, position)
    @players = players
    @position = position
  end
end
