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

      @pieces = Hash.new
      @pieces['Pawn'] = PieceDescription.new("Pawn","","p",[movement_rules['step_forward']])


      @setups = Hash.new
      @setups['Classic'] = Setup.new(
        [
          [nil,nil,nil,nil,nil,nil,nil,nil],
          %w[Pawn Pawn Pawn Pawn Pawn Pawn Pawn Pawn]
        ]
      )

      @modes = Hash.new
      @modes['Classic'] = Mode.new(@boards['Square8x8'],
                                   [Spawner.new(Vector[0,0],Vector[1,0],Vector[0,1]),
                                    Spawner.new(Vector[7,0],Vector[-1,0],Vector[0,1])],
                                   2,2,nil)
    end

  def step_forward(piece,position)
    #Если впереди нас стоит какая-либо фигураЮ то походить не можем
    if(check_figure(piece.pos + piece.dir,position) != nil) then
      return []
    end

    movement = [piece.pos,piece.pos + piece.dir]
    notation = piece.piece_description.notation_name +
      NotationTranslationHelper.array_to_notation(movement[0]) + "-" +
      NotationTranslationHelper.array_to_notation(movement[1]);
    return [Move.new(notation,movement)]
  end

  def check_figure(pos, position)
    if (position.board.matrix[pos[0]][pos[1]] != 0 && position.board.matrix[pos[0]][pos[1]] != nil) then
      return position.board.matrix[pos[0]][pos[1]]
      else
      return nil
    end
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

