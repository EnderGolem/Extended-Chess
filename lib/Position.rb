require_relative 'Board'
require_relative 'Chess'

class Position
  attr_reader :possible_moves, :cur_subturn, :turn_num, :colors, :active_players, :winners, :losers, :is_final
  attr_accessor :board

=begin
      при создании позиции:
      -задаем доску с уже расставленными фигурами
      - цвета игроков в порядке хода
      - текущий ход
      - номер игрока который ходит в данный момент
=end
  SKIP_MOVE = Move.new(' ')

  def initialize(board,colors,player_defeat_conditions,player_win_conditions,no_move_policy,turn_num = 1, cur_subturn = 0)
    @board = board
    @colors = colors
    @active_players = colors
    @winners = []   #format: [[color, win_reason:string],...]
    @losers = []    #format: [[color, lose_reason:string],...]
    @player_defeat_conditions = player_defeat_conditions
    @player_win_conditions = player_win_conditions
    @no_move_policy = no_move_policy
    @turn_num = turn_num
    @cur_subturn = cur_subturn
    @possible_moves = Hash.new
    @is_final = false #определяет закончилась ли игра
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
    if @is_final then return end
    if has_move(notation)
      make_move(@possible_moves[notation])
      check_losers_and_winners
      if @is_final then return end
      #Если у игрока нет ходов, то нужно обработать это
      # после чего пересчитать победителей и проигравших и понять не закончилась ли игра
      # И так до тех пор пока не найдем игрока, который может нормально ходить
      mc = 0
      while mc==0
        inc_subturn
        calculate_possible_moves
        mc = @possible_moves.length
        handle_no_possible_moves
        check_losers_and_winners
        if @is_final then return end
      end
      puts "losers: #{losers}"
      puts "winners: #{winners}"
      puts @is_final
    end
  end

    def check_losers_and_winners
      change = false
      loop do
        flag = false
        deleted = []
        @active_players.each_index do |ind|
          if(!@player_defeat_conditions.nil?) then
            res = nil
            @player_defeat_conditions.each do |cond|
              res = cond.call(@active_players[ind],self)
            end
            if(!res.nil?) then
              @losers.push([@active_players[ind],res])
              deleted.push(@active_players[ind])
              flag = true
            end
          end
          if(!flag && !@player_win_conditions.nil?) then
            res = nil
            @player_win_conditions.each do |cond|
              res = cond.call(@active_players[ind],self)
            end
            if(!res.nil?) then
              @winners.push([@active_players[ind],res])
              deleted.push(@active_players[ind])
              flag = true
            end
          end
          if flag then change = true end
        end

        @active_players -= deleted

        break if !change || @active_players.length == 0
      end
      if(@active_players.length == 0) then @is_final = true; end
    end
  def handle_no_possible_moves
    if(@possible_moves.length > 0 ) then return end

    if(@no_move_policy == 'winning') then
      @winners.push([get_cur_player,'All moves was blocked!'])
      @active_players-=get_cur_player
    elsif (@no_move_policy == 'losing') then
      @losers.push([get_cur_player,'All moves was blocked!'])
      @active_players-=get_cur_player
    elsif (@no_move_policy == 'skipping')
      inc_subturn
    elsif (@no_move_policy == 'draw')
      #TODO: make draw
    end
  end
  def inc_subturn
    @cur_subturn+=1
    if(@cur_subturn>=@colors.length) then
      @cur_subturn = 0
      @turn_num+=1
    end
    #Пока не найдем все еще активного игрока, за неактивных просто пропускаем ход
    while(!@active_players.include?(@colors[cur_subturn]))
      make_move(SKIP_MOVE)
      @cur_subturn+=1
      if(@cur_subturn>=@colors.length) then
        @cur_subturn = 0
        @turn_num+=1
      end
    end
  end

  def get_cur_player
    return @active_players[@cur_subturn]
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