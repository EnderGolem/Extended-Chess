require_relative 'Board'
require_relative 'Chess'

class Position
  attr_reader  :possible_moves, :cur_subturn, :turn_num
  attr_accessor :board

=begin
      при создании позиции:
      -задаем доску с уже расставленными фигурами
      - цвета игроков в порядке хода
      - текущий ход
      - номер игрока который ходит в данный момент
=end


  def initialize(board,colors,turn_num = 1, cur_subturn = 0)
    @board = board
    @colors = colors
    @turn_num = turn_num
    @cur_subturn = cur_subturn
    @possible_moves = Hash.new
    calculate_possible_moves
  end

  def calculate_possible_moves
    @possible_moves.clear
    #Для каждой фигуры на доске применяем правила и записываем список всех возможных ходов
    # в possible moves
    @board.matrix.each do |line|
      line.each do |p|
        if p.class == Piece && p.player_color == @colors[@cur_subturn] then
          p.calculatePossibleMoves(self).each do |move|
            @possible_moves[move.notation] = move;
          end
        end
      end
    end
  end

  #notation - String
  def has_move(notation)
    return @possible_moves.has_key?(notation)
  end

  #notation - String
  def step!(notation)
    if has_move(notation)
      make_move(@possible_moves[notation])
      @cur_subturn+=1
      if(@cur_subturn>=@colors.length) then
        @cur_subturn = 0
        @turn_num+=1
      end
      calculate_possible_moves
    end
  end

  def make_move(move)
    if(!move.movements.nil?) then
      move.movements.each do |movement|
        piece = @board.matrix[movement[0][0]][movement[0][1]]
        piece.pos = Vector[movement[1][0],movement[1][1]]
        @board.matrix[movement[0][0]][movement[0][1]] = 0
        @board.matrix[movement[1][0]][movement[1][1]] = piece
      end
    end
    if(!move.removing.nil?) then
      move.removing.each do |rem|
        @board.matrix[rem[0]][rem[1]] = 0
      end
    end
    if(!move.spawn.nil?) then
      chess = Chess.new

      move.spawn.each do |sp|
        @board.matrix[sp[0][0]][sp[0][1]] = Piece.new(sp[0],sp[1],sp[2],sp[3],chess.pieces[sp[4]])
      end
    end
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
