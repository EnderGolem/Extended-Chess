require_relative 'Board'

class Position

  attr_accessor :board
  def initialize(board)
    @board = board
  end

  def print_board
    ind = @board.matrix.length
    @board.matrix.each do |arr|
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
