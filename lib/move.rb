class Move
  attr_accessor :notation, :movement, :removing, :spawn

  def initialize(notation, movement = nil, removing = nil, spawn = nil)
    @notation = notation  # :String
    @movement = movement  #format: [точка из которой переходит фигура  :Vector,точка куда переходит фигура :Vector]
    @removing = removing  #format: [Точка из которой убираем фигуру :Vector]
    @spawn    = spawn     #format: [Точка в которую ставим фигуру :Vector, название ставимой фигуры :String]
  end

end