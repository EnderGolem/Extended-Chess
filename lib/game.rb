require_relative 'Chess'
require_relative 'Move'
class Game
  attr_reader :players, :position
  attr_accessor :cur_player
  def initialize(players, position)
    @players = players
    @position = position
  end


  def check_figure?(pos)
    return @position.board.matrix[pos[0]][pos[1]] != 0 && @position.board.matrix[pos[0]][pos[1]] != nil
  end
  def check_move?(start, finish)
    chess = Chess.new
    piece_description = chess.pieces[position.board.matrix[start[0]][start[1]].piece_description.name]
    move = piece_description.rules.first.call(start, finish)
    return  move.first.movement.first.call(start, finish, @position.board.matrix[start[0]][start[1]].dir )  #TODO more than 1
  end
  def make_movement(start, finish)

    piece = @position.board.matrix[start[0]][start[1]]
    @position.board.matrix[start[0]][start[1]] = 0
    @position.board.matrix[finish[0]][finish[1]] = piece
    #Perhaps some effects from the movement
    #but there aren't any yet, so bruh
  end
  def step!(start, finish)

    if(!check_figure?(start))
      return  false
    end
    if(!check_move?(start, finish))
      return  false
    end
    make_movement(start, finish)
  end
end
