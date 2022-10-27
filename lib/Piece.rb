require 'matrix'

class Piece
  attr_accessor :pos, :team_color, :player_color, :dir, :data
  attr_reader :piece_description, :is_chief


  def initialize(pos, team_color, player_color, dir, piece_description, is_chief = false)
    @pos = pos
    @team_color = team_color
    @player_color = player_color
    @dir = dir  # Направление движения фигуры
    @piece_description = piece_description # Описание фигуры
    @data = {Count_of_move: 0, Moves: Array.new() } # Различные данные фигуры   Hash[[Symbol, data]]
    @is_chief = is_chief #является ли фигура главной
  end

  #position - Position
  # Подсчитывает возможные ходы
  def calculatePossibleMoves(position)
    moves = Array.new
    @piece_description.rules.each do |rule|
      moves += rule.call(self,position)
    end
    return moves
  end
end
