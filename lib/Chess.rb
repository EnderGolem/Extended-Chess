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


      @pieces = Hash.new
      @pieces['Pawn'] = PieceDescription.new("Pawn","","p",[movement_rules['step_forward']])
      @pieces['Man'] = PieceDescription.new("Man","m","m",
                                            [movement_rules['step_diagonal_right'],movement_rules['step_diagonal_left'],
                                             movement_rules['diagonal_jump_with_kill']])


      @setups = Hash.new
      @setups['Classic'] = Setup.new(
        [
          [nil,nil,nil,nil,nil,nil,nil,nil],
          %w[Pawn Pawn Pawn Pawn Pawn Pawn Pawn Pawn]
        ]
      )

      @setups['Checkers'] = Setup.new(
        [
          ['Man', nil, 'Man', nil, 'Man', nil, 'Man', nil ],
          [ nil, 'Man', nil, 'Man', nil, 'Man', nil, 'Man'],
          ['Man', nil, 'Man', nil, 'Man', nil, 'Man', nil ]
        ]
      )

      @modes = Hash.new
      @modes['Classic'] = Mode.new(@boards['Square8x8'],
                                   [Spawner.new(Vector[0,0],Vector[1,0],Vector[0,1]),
                                    Spawner.new(Vector[7,0],Vector[-1,0],Vector[0,1])],
                                   2,2,nil)
      @modes['Checkers'] = Mode.new(@boards['Square8x8'],
                                   [Spawner.new(Vector[0,0],Vector[1,0],Vector[0,1]),
                                    Spawner.new(Vector[7,7],Vector[-1,0],Vector[0,-1])],
                                   2,2,nil)
    end

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

  def check_figure(pos, position)
    if (position.board.matrix[pos[0]] != nil &&
      position.board.matrix[pos[0]][pos[1]] != nil &&
      position.board.matrix[pos[0]][pos[1]] != 0) then
      return position.board.matrix[pos[0]][pos[1]]
    end
    return nil
  end
  # Проверяет лежит ли заданная позиция в пределах игрового поля
  def is_on_board?(pos, position)
    return pos[0]<position.board.height && pos[0] >= 0 && pos[1]<position.board.width && pos[1] >=0 &&
    position.board.matrix[pos[0]][pos[1]] != nil
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

