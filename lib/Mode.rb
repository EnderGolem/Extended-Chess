require_relative 'game'
require_relative 'Chess'
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
    chess = Chess.new
    setups.each_index do |ind|
      i = j = 0
      setups[ind].placement.each do |line|
        line.each do |pName|
          cur_pos = @spawn[ind].startPos + j * @spawn[ind].right_dir + i * @spawn[ind].up_dir
          @board.matrix[cur_pos[0]][cur_pos[1]] = (pName == nil) ? 0 :
            Piece.new(cur_pos,players[ind].color,players[ind].color,@spawn[ind].up_dir,chess.pieces[pName])
            j += 1
        end
        j = 0
        i += 1
      end
    end
    position = Position.new(@board,players.map {|player| player.color})
    return Game.new(players,position)
  end
end
