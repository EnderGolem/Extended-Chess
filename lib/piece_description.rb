#Класс описания фигуры, включающий в себя список правил
# по которым ходит заданная фигура, а также
# другие характеристики характерные для заданного типа фигур

class PieceDescription

  attr_reader :name, :notation_name, :char_name, :rules

  def initialize(name, notation_name, char_name, rules)
    @name = name
    @notation_name = notation_name
    @char_name =char_name
    @rules = rules
  end
end
