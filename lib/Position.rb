require_relative 'Board'

class Position

  def initialize(board, setup_white, setup_black)
    @board = board
  end

  def print_board
    ind = @board.matrix.length
    @board.matrix.each do |arr|
      print "#{ind}#{" "*(@board.height.to_s.length-ind.to_s.length)} | "
      ind -= 1
      arr.each { |elem| if elem == nil then print "  " elsif elem.class == Integer
                                                         print "#{0} " end }
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
