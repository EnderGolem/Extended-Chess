require_relative 'Board'
require_relative 'Move'
require_relative 'Piece'
require_relative 'piece_description'
require_relative 'setup'
require_relative 'Mode'
require_relative 'spawner'
require_relative 'Helpers/notation_translation_helper'

class Chess
  attr_reader :boards, :movement_rules, :pieces, :modes, :setups
    def initialize
      @boards = Hash.new
      @boards['Square4x4'] = Board.new(Array.new(4){Array.new(4){0}})
      @boards['Square8x8'] = Board.new(Array.new(8){Array.new(8){0}})
      ffa = [
        [nil,nil,nil,nil,0,0,0,0,0,0,0,0,nil,nil,nil,nil],
        [nil,nil,nil,nil,0,0,0,0,0,0,0,0,nil,nil,nil,nil],
        [nil,nil,nil,nil,0,0,0,0,0,0,0,0,nil,nil,nil,nil],
        [nil,nil,nil,nil,0,0,0,0,0,0,0,0,nil,nil,nil,nil],
        [ 0,  0,  0,  0, 0,0,0,0,0,0,0,0, 0,  0,  0,  0],
        [ 0,  0,  0,  0, 0,0,0,0,0,0,0,0, 0,  0,  0,  0],
        [ 0,  0,  0,  0, 0,0,0,0,0,0,0,0, 0,  0,  0,  0],
        [ 0,  0,  0,  0, 0,0,0,0,0,0,0,0, 0,  0,  0,  0],
        [ 0,  0,  0,  0, 0,0,0,0,0,0,0,0, 0,  0,  0,  0],
        [ 0,  0,  0,  0, 0,0,0,0,0,0,0,0, 0,  0,  0,  0],
        [ 0,  0,  0,  0, 0,0,0,0,0,0,0,0, 0,  0,  0,  0],
        [ 0,  0,  0,  0, 0,0,0,0,0,0,0,0, 0,  0,  0,  0],
        [nil,nil,nil,nil,0,0,0,0,0,0,0,0,nil,nil,nil,nil],
        [nil,nil,nil,nil,0,0,0,0,0,0,0,0,nil,nil,nil,nil],
        [nil,nil,nil,nil,0,0,0,0,0,0,0,0,nil,nil,nil,nil],
        [nil,nil,nil,nil,0,0,0,0,0,0,0,0,nil,nil,nil,nil],
      ]
      @boards['FFA'] = Board.new(ffa)

      @movement_rules = Hash.new
      movement_rules['step_forward'] = method(:step_forward) # Maybe:   movement_rules['step_forward'] = step_forward()  and step_forward(without arg)
      movement_rules['step_diagonal_right'] = method(:step_diagonal_right)
      movement_rules['step_diagonal_left'] = method(:step_diagonal_left)
      movement_rules['diagonal_jump_with_kill'] = method(:diagonal_jump_with_kill)
      movement_rules['verhor_jump_with_kill'] = method(:verhor_jump_with_kill)
      movement_rules['step_any_dir'] = method(:step_any_dir)
      movement_rules['man_step'] = method(:man_step)


      @pieces = Hash.new
      @pieces['Pawn'] = PieceDescription.new("Pawn","","p",[movement_rules['step_forward']])
      @pieces['Man'] = PieceDescription.new("Man","m","m",
                                            [movement_rules['man_step'],
                                             movement_rules['diagonal_jump_with_kill']])
      @pieces['Dame'] = PieceDescription.new("Dame", "D", "D",
                                             [movement_rules['step_any_dir'],
                                              movement_rules['verhor_jump_with_kill'],
                                              movement_rules['diagonal_jump_with_kill']])


      @setups = Hash.new
      @setups['Classic'] = Setup.new('Classic',
        [
          [nil,nil,nil,nil,nil,nil,nil,nil],
          %w[Pawn Pawn Pawn Pawn Pawn Pawn Pawn Pawn]
        ]
      )
      @setups['test1'] = Setup.new('test1',
        [[nil, nil, nil, nil],
                 [ nil,'!Man',nil ,nil]]
      )

      @setups['Checkers'] = Setup.new('Checkers',
        [
          ['Man', nil, 'Man', nil, 'Man', nil, 'Man', nil ],
          [ nil, 'Man', nil, 'Man', nil, 'Man', nil, 'Man'],
          ['Man', nil, 'Man', nil, 'Man', nil, 'Man', nil ]
        ]
      )
      @end_game_conditions = Hash.new
      @end_game_conditions['Piece_lost'] = method(:lost_all_pieces)
      @end_game_conditions['Chiefs_lost'] = method(:lost_all_chiefs)
      @end_game_conditions['All_opponents_lost'] = method(:all_opponents_lost)

      @possible_moves_postprocessors = Hash.new
      @possible_moves_postprocessors['Mandatory_killings'] = method(:mandatory_killings)

      @modes = Hash.new
      @modes['Classic'] = Mode.new(@boards['Square8x8'],
                                   [Spawner.new(Vector[0,0],Vector[1,0],Vector[0,1]),
                                    Spawner.new(Vector[7,0],Vector[-1,0],Vector[0,1])],
                                   2,2,['Classic'],
                                   [@end_game_conditions['Piece_lost']],
                                   [@end_game_conditions["All_opponents_lost"]])
      @modes['Checkers'] = Mode.new(@boards['Square8x8'],
                                   [Spawner.new(Vector[0,0],Vector[1,0],Vector[0,1]),
                                    Spawner.new(Vector[7,7],Vector[-1,0],Vector[0,-1])],
                                   2,2,['Checkers'],
                                    [@end_game_conditions['Piece_lost']],
                                    [@end_game_conditions["All_opponents_lost"]])
      @modes['Test'] = Mode.new(@boards['Square4x4'],
                                [Spawner.new(Vector[0,0],Vector[1,0],Vector[0,1]),
                                 Spawner.new(Vector[3,3],Vector[-1,0],Vector[0,-1])],
                                2,2,['test1'],
                                [@end_game_conditions['Chiefs_lost']],
                                [@end_game_conditions["All_opponents_lost"]],
                                [@possible_moves_postprocessors['Mandatory_killings']])
    end

  #piece - Piece
  #positiong - Position
  #return - Array[Move]
  # Делает шаг вперед
  def step_forward(piece,position)
    #Если впереди нас стоит какая-либо фигураЮ то походить не можем
    if(check_figure(piece.pos + piece.dir,position) != nil) then
      return []
    end

    movement = [[piece.pos,piece.pos + piece.dir]]
    notation = piece.piece_description.notation_name +
      NotationTranslationHelper.array_to_notation(movement[0][0]) + "-" +
      NotationTranslationHelper.array_to_notation(movement[0][1]);
    return [Move.new(notation,movement)]
  end

  #piece - Piece
  #positiong - Position
  #return - Array[Move]
  def step_diagonal_right(piece, position)
    right_dir = piece.dir.cross + piece.dir
    if(!is_on_board?(piece.pos + right_dir,position) || check_figure(piece.pos + right_dir,position) != nil) then
      return []
    end

    movement = [[piece.pos,piece.pos + right_dir]]
    notation = piece.piece_description.notation_name +
      NotationTranslationHelper.array_to_notation(movement[0][0]) + "-" +
      NotationTranslationHelper.array_to_notation(movement[0][1]);
    return [Move.new(notation,movement)]

  end
  #piece - Piece
  #positiong - Position
  #return - Array[Move]
  def step_diagonal_left(piece, position)
    left_dir = -piece.dir.cross + piece.dir
    if(!is_on_board?(piece.pos + left_dir,position) || check_figure(piece.pos + left_dir,position) != nil) then
      return []
    end

    movement = [[piece.pos,piece.pos + left_dir]]
    notation = piece.piece_description.notation_name +
      NotationTranslationHelper.array_to_notation(movement[0][0]) + "-" +
      NotationTranslationHelper.array_to_notation(movement[0][1]);
    return [Move.new(notation,movement)]

  end
  
  #piece - Piece
  #positiong - Position
  #TODO Пояснения как ходит
  def man_step(piece,position)
    moves = step_diagonal_left(piece,position) + step_diagonal_right(piece,position)
    moves.each_index do |ind|
      #Если мы походили на последнюю линию, то надо поставить дамку
      if(is_pos_on_finish_line(moves[ind].movements[0][1],piece.dir,position)) then
        removing = [piece.pos]
        spawning = [[moves[ind].movements[0][1],piece.team_color,piece.player_color,piece.dir,'Dame']]
        notation = piece.piece_description.notation_name +
          NotationTranslationHelper.array_to_notation(moves[ind].movements[0][0]) + "-" +
          NotationTranslationHelper.array_to_notation(moves[ind].movements[0][1]) + "D"
        moves[ind] = Move.new(notation,nil,removing,spawning)
      end
    end
    return moves
  end


  #piece - Piece
  #positiong - Position
  #return - Array[Move]
  def diagonal_jump_with_kill(piece,position)
    moves = []
    forward = piece.dir
    right_dir = piece.dir.cross
    ([1,-1].product [1,-1] ).to_a.each do |p|
      near = piece.pos + p[0]*right_dir + p[1]*forward
      far = piece.pos+p[0]*2*right_dir + p[1]*2*forward
      p = check_figure(near,position)
      if(p != nil && is_on_board?(near,position) && is_on_board?(far,position) &&
      p.team_color != piece.team_color && check_figure(far,position).nil?) then
        movement = [[piece.pos,far]]
        removing = [near]
        notation = piece.piece_description.notation_name+
          NotationTranslationHelper.array_to_notation(movement[0][0]) + "-" +
          NotationTranslationHelper.array_to_notation(movement[0][1]);
        move = Move.new(notation,movement,removing)
        moves.push(move)
      end
    end
    return moves
  end

    #TODO Пояснения как ходит
  def verhor_jump_with_kill(piece,position)
    moves = []
    forward = piece.dir
    right_dir = piece.dir.cross
    [[1,0],[-1,0],[0,1],[0,-1]].each do |p|
      near = piece.pos + p[0]*right_dir + p[1]*forward
      far = piece.pos+p[0]*2*right_dir + p[1]*2*forward
      p = check_figure(near,position)
      if(p != nil && is_on_board?(near,position) && is_on_board?(far,position) &&
        p.team_color != piece.team_color && check_figure(far,position).nil?) then
        movement = [[piece.pos,far]]
        removing = [near]
        notation = piece.piece_description.notation_name+
          NotationTranslationHelper.array_to_notation(movement[0][0]) + "-" +
          NotationTranslationHelper.array_to_notation(movement[0][1]);
        move = Move.new(notation,movement,removing)
        moves.push(move)
      end
    end
    return moves
  end
  
  #TODO Пояснения как ходит
  def step_any_dir(piece,position)
    moves = []
    right_dir = piece.dir.cross

    var = ([0,1,-1].product [0,1,-1] ).to_a
    var.delete([0,0])
    var.each do |v|
      pos = piece.pos + piece.dir * v[0] + right_dir*v[1]

      if(is_on_board?(pos,position) || check_figure(pos,position) == nil) then
        movement = [[piece.pos,pos]]
        notation = piece.piece_description.notation_name+
          NotationTranslationHelper.array_to_notation(movement[0][0]) + "-" +
          NotationTranslationHelper.array_to_notation(movement[0][1]);
        move = Move.new(notation,movement,nil)
        moves.push(move)
      end

    end
    return moves
  end


  #pos - Vector
  #positiong - Position
  #return - Array[Move]
  def check_figure(pos, position)
    if (position.board.matrix[pos[0]] != nil &&
      position.board.matrix[pos[0]][pos[1]] != nil &&
      position.board.matrix[pos[0]][pos[1]] != 0) then
      return position.board.matrix[pos[0]][pos[1]]
    end
    return nil
  end

  def lost_all_pieces(player_color,position)
    c = 0

    position.board.matrix.each do |line|
      c+= line.count { |p| p.class == Piece && p.player_color == player_color}
    end
    if c == 0 then
      return 'Lost all pieces!'
    end
    return nil
  end

  def all_opponents_lost(player_color,position)
    if(position.losers.length == position.colors.length-1 && position.active_players.include?(player_color)) then
      return 'All opponents lost!'
    end
    return nil
  end

  def all_opponents_won(player_color,position)
    if(position.winners.length == position.colors.length-1 && position.active_players.include?(player_color)) then
      return 'All opponents won!'
    end
    return nil
  end
  def lost_all_chiefs(player_color,position)
    c = 0
    position.board.matrix.each do |line|
      c+= line.count { |p| p.class == Piece && p.player_color == player_color && p.is_chief}
    end
    if c == 0 then
      return 'Lost all chiefs!'
    end
    return nil
  end
  #постобработчик возможных ходов, который обязывает игрока делать взятие фигуры
  # если оно возможно
  def mandatory_killings(possible_moves)
    if possible_moves.values.count { |move| !move.removing.nil? && move.removing.length>0} then
      possible_moves.delete_if { |key,value| value.removing.nil? || value.removing.length==0}
    end
  end
  
  #pos - Vector
  #positiong - Position  
  # Проверяет лежит ли заданная позиция в пределах игрового поля
  def is_on_board?(pos, position)
    return pos[0] < position.board.height && pos[0] >= 0 && pos[1] < position.board.width && pos[1] >= 0 &&
    position.board.matrix[pos[0]][pos[1]] != nil
  end
  #Функция определяет является ли заданая клетка
  # финишной для фигуры с данным направлением
  # Под финишными клетками подразумеваются те, в которых пешки превращаются в ферзей
  def is_pos_on_finish_line(pos, dir, position)
    return is_on_board?(pos,position) && !is_on_board?(pos+dir,position)
  end

  def can_step_forward?(start, maybe_finish, dir)
    start[0] += dir[0]
    start[1] += dir[1]
    if(start == maybe_finish)
      start[0] -= dir[0]
      start[1] -= dir[1]
      return  true
    end
    start[0] -= dir[0]
    start[1] -= dir[1]
    return  false
    end
end

