require_relative 'Board'

class Position
  attr_reader  :possible_moves
  attr_accessor :board
  def initialize(board)
    @board = board
    @possible_moves = Hash.new
    calculate_possible_moves
  end

  def calculate_possible_moves
    #Для каждой фигуры на доске применяем правила и записываем список всех возможных ходов
    # в possible moves
    @board.matrix.each do |line|
      line.each do |p|
        if p.class == Piece then
          p.calculatePossibleMoves(self).each do |move|
            puts move.notation
            @possible_moves[move.notation] = move;
          end
        end
      end
    end
  end

  def has_move(notation)
    return @possible_moves.has_key?(notation)
  end

  def step!(notation)
    if has_move(notation)
      make_move(@possible_moves[notation])
      calculate_possible_moves
    end
  end

  def make_move(move)

      piece = @board.matrix[move.movement[0][0]][move.movement[0][1]]
      puts piece
      piece.pos = Vector[move.movement[1][0],move.movement[1][1]]
      @board.matrix[move.movement[0][0]][move.movement[0][1]] = 0
      @board.matrix[move.movement[1][0]][move.movement[1][1]] = piece

    #Perhaps some effects from the movement
    #but there aren't any yet, so bruh
  end

  def print_board
    ind = @board.matrix.length
    @board.matrix.reverse_each do |arr|
      print "#{ind}#{" "*(@board.height.to_s.length-ind.to_s.length)} | "
      ind -= 1
      arr.each { |elem| if elem == nil then print "  "
                        elsif elem.class == Integer then print "#{0} "
                        elsif elem.class == Piece then print "#{elem.piece_description.char_name} ".colorize(elem.player_color) end }
      puts
    end
    print '    '
    @board.matrix[0].length.times do
      print '- '
    end
    ch = 'A'
    puts
    print '    '
    @board.matrix[0].length.times do
      print "#{ch} "
      ch.next!
    end
    puts
  end
end
