require_relative 'Chess'
require_relative 'Move'
require_relative 'GameResult'
class Game
  attr_reader :players, :position
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

  def is_ended?
    return @position.is_final
  end

  def get_result
    if(!@position.is_final) then return nil end
    return GameResult.new(@position.winners,@position.losers,nil)
  end
end
