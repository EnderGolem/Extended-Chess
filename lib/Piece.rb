require 'matrix'

class Piece
  attr_accessor :pos, :team_color, :player_color, :dir, :data
  attr_reader :piece_description


  def initialize(pos, team_color, player_color, dir, piece_description)
    @pos = pos
    @team_color = team_color
    @player_color = player_color
    @dir = dir
    @piece_description = piece_description
    @data = Hash.new
  end

  #position - Position
  def calculatePossibleMoves(position)
    moves = Array.new
    @piece_description.rules.each do |rule|
      moves += rule.call(self,position)
    end
    return moves
  end
end
