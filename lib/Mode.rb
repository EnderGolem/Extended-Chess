#Режим игры
class Mode
  def initialize(board,spawns,team_count,player_count,allowed_setups)
    @board = board
    @spawn = spawns
    @team_count = team_count
    @player_count = player_count
    @allowed_setups = allowed_setups
  end
  # Создает игру в выбранном режиме с конкретными игроками, сетапами и параметрами
  def make_game(players,setups)

  end
end
