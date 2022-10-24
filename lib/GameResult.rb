class GameResult

  def initialize(winners,losers, log)
    @winners = winners #format: [игрок :Player, результат игры для этого игрока: string]
    @losers = losers
    @game_log = log
  end
end

