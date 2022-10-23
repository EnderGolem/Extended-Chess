require_relative 'Chess'
require_relative 'Move'
class Game
  attr_reader :players, :position
  attr_accessor :cur_player
  def initialize(players, position)
    @players = players
    @position = position
  end

  #notation - String
  def step!(notation)

    if(@position.has_move(notation))
      @position.step!(notation)
      return true
      else return false
    end
  end
end
