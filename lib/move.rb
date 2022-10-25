# Класс хода
class Move
  attr_accessor :notation, :movements, :removing, :spawn

  def initialize(notation, movement = nil, removing = nil, spawn = nil)
    @notation = notation  # :String
    @movements = movement  #format: [точка из которой переходит фигура  :Vector,точка куда переходит фигура :Vector]
    @removing = removing  #format: [Точка из которой убираем фигуру :Vector]
    @spawn    = spawn     #format: [Точка в которую ставим фигуру :Vector, цвет команды,цвет игрока, направление, название ставимой фигуры :String]
  end

end