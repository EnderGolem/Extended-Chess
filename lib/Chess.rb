require_relative 'Board'
require_relative 'Move'
require_relative 'Piece'
require_relative 'piece_description'

class Chess
  attr_reader :boards, :movement_rules, :pieces
    def initialize
      @boards = Hash.new
      @boards['Square8x8'] = Board.new(Array.new(8,Array.new(8,0)))
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
      movement_rules['step_forward'] = method(:step_forward)

      @pieces = Hash.new
      @pieces['Pawn'] = PieceDescription.new("Pawn","","p",[movement_rules['step_forward']])
    end

  def step_forward(piece,position)
    return [Move.new('e2-e3')]
  end

end
