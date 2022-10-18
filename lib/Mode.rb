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
    puts "!!!!#{@board.matrix}"
    chess = Chess.new
    setups.each_index do |ind|
      i=j=0
      #cur_pos = @spawn[ind].startPos
      puts "*****#{setups[ind].placement[0].length}"
      setups[ind].placement.each do |line|
        line.each do |pName|
          cur_pos=@spawn[ind].startPos + j*@spawn[ind].right_dir + i*@spawn[ind].up_dir

          @board.matrix[cur_pos[0]][cur_pos[1]] = (pName == nil)? 0 :
            Piece.new(cur_pos,nil,players[ind].color,@spawn[ind].up_dir,chess.pieces[pName])
            puts "&&&&&&#{cur_pos}"
            j+=1
            puts "#{cur_pos}"
          #puts @board.matrix
        end
        j=0
        i+=1
      end
    end
    position = Position.new(@board)
    return Game.new(players,position)
  end
end
