require_relative 'game'
require_relative 'Chess'

#Режим игры
class Mode
  attr_reader :allowed_setups
  def initialize(board,spawns,team_count,player_count,allowed_setups,player_defeat_conditions,player_win_conditions,possible_moves_postprocessors=nil, no_move_policy = 'skipping')
    @board = board
    @spawn = spawns
    @team_count = team_count
    @player_count = player_count
    @allowed_setups = allowed_setups
    @player_defeat_conditions = player_defeat_conditions #format [string method(position :Position),...]
    @player_win_conditions = player_win_conditions #format [string method(position :Position),...]
    @possible_moves_postprocessors = possible_moves_postprocessors
    #что происходит, если у игрока нет доступных ходов, но при этом он не проиграл
    # есть 4 варианта на выбор:
    # 'skipping' - игрок пропускает ход
    # 'winning' - игрок одерживает победу
    # 'losing' - игрок проигрывает
    # 'draw' - ничья
    @no_move_policy = no_move_policy

  end
  # Создает игру в выбранном режиме с конкретными игроками, сетапами и параметрами
  def make_game(players,setups)
    board = @board.dup
    setups.each_index do |ind|
      i = j = 0

      if(!@allowed_setups.include?(setups[ind].name)) then return nil end

      setups[ind].placement.each do |line|
        line.each do |pName|
          cur_pos = @spawn[ind].startPos + j * @spawn[ind].right_dir + i * @spawn[ind].up_dir
          if(pName == nil) then
            board.matrix[cur_pos[0]][cur_pos[1]] = 0
          else
            is_chief = false
            pn = pName.dup
            p pName
            #Если в записи сетапа перед названием фигуры стоит !
            # то помечаем фигуру как главную
            if(pn[0] == '!') then
              pn.delete_prefix!('!')
              is_chief = true
            end
            p is_chief

            board.matrix[cur_pos[0]][cur_pos[1]] =
              Piece.new(cur_pos,players[ind].color,players[ind].color,@spawn[ind].up_dir,Chess.instance.pieces[pn],is_chief)

          end
          j += 1
        end
        j = 0
        i += 1
      end
    end
    postprocessors = Hash.new
    players.each do |pl|
      postprocessors[pl.color] = @possible_moves_postprocessors
    end
    position = Position.new(board,players.map {|player| player.color},@player_defeat_conditions,@player_win_conditions,postprocessors,@no_move_policy)
    return Game.new(players,position)
  end
end
