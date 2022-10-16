=begin
  Класс доски отвечает за конфигурацию
матрицы позиции. Если в клетке матрицы стоит nil, то значит эта клетка находится за доской
Если же стоит 0, то значит клетка свободна
=end


class Board
  attr_accessor :matrix
  attr_reader :height, :width

  def initialize(matrix)
    #Ширина и высота квадрата, в который вписана матрица
    @width = matrix[0].length
    @height = matrix.length
    @matrix = matrix
  end
end
