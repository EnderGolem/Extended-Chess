# frozen_string_literal: true

require_relative "test_helper"

class TestExtendedChess < MiniTest::Test

  def test_
    assert_equal 5,5
  end

   def setup
      @chess = Chess.new
      @mode = @chess.modes['Classic']
      @player1 = Player.new('Alex',:red)
      @player2 = Player.new('Max',:blue)
      @game = @mode.make_game([@player1,@player2],[@chess.setups['Classic'],@chess.setups['Classic']])
      @game.position.print_board
      # p @game.position.board.matrix.length
   end

  def test_f1
    assert_equal 'Alex', @player1.name
  end

  def test_f2
    assert_equal color = :red, @player1.color
  end

  # Проверяет правильную расстановку фигур в зависимости от режима игры и двух игроков
  def test_check_figure
    # Проверка что в е3 нет фигуры
    #  @game.step!('e2-e3')
    # Проверка что в е3 появилась фигира, а в е2 стал 0
  end

  # Заранее подготовить конечную доску
  # Начальное состояние -> Делаю ходы -> Сравниваю с конечной доской
  def test_matr
    matr_final =
      [
        ['Man', nil, 'Man', nil, 'Man', nil, 'Man', nil ],
        [ nil, 'Man', nil, 'Man', nil, 'Man', nil, 'Man'],
        ['Man', nil, 'Man', nil, 'Man', nil, 'Man', nil ],
        [nil,   nil, 'Man', nil, nil, nil, 'Man', nil ],
        [nil, nil, nil, nil, nil, nil, nil, nil ],
        [nil, nil, nil, nil, nil, nil, nil, nil ],
        ['Pawn', 'Pawn', 'Man', nil, 'Man', nil, 'Man', nil ],
        ['Man', nil, 'Man', nil, 'Man', nil, 'Man', nil ]
      ]

    matr_nachalo =
      [
        [ nil, nil, nil, nil, nil, nil, nil, nil],
        [ 'Pawn', 'Pawn', 'Pawn', 'Pawn', 'Pawn', 'Pawn', 'Pawn', 'Pawn'],
        [nil, nil, nil, nil, nil, nil, nil, nil ],
        [nil,   nil, nil, nil, nil, nil, nil, nil ],
        [nil, nil, nil, nil, nil, nil, nil, nil ],
        [nil, nil, nil, nil, nil, nil, nil, nil ],
        [ 'Pawn', 'Pawn', 'Pawn', 'Pawn', 'Pawn', 'Pawn', 'Pawn', 'Pawn'],
        [ nil, nil, nil, nil, nil, nil, nil, nil]
      ]
    #@game.position.print_board

    # test_2?(@game.position.board.matrix, matr_nachalo)
    
  end
end
