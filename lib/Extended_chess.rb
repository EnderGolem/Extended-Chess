require 'colorize'
require_relative 'Position'
require_relative 'Chess'
require_relative 'Move'
require_relative 'Player'
require_relative 'Board'
require_relative 'Interface'
require_relative 'Helpers/notation_translation_helper'


module ExtendedChess
interface = Interface.new()
interface.interface()
=begin
  chess = Chess.new
  mode = chess.modes['Classic']
  player1 = Player.new('Alex',:red)
  player2 = Player.new('Max',:blue)
  game = mode.make_game([player1,player2],[chess.setups['Classic'],chess.setups['Classic']])
  # puts game.position.possible_moves
  # game.position.print_board
  # p game.position.board.matrix.length

  game.step!('e2-e3')
  puts 'e2-e3'
  game.position.print_board
  game.step!('c7-c6')
  puts 'c7-c6'
  game.position.print_board
  game.step!('c6-c5')
  puts 'c6-c5'
  game.position.print_board
  game.step!('a7-a6')
  puts 'a7-a6'
  game.position.print_board
  game.step!('f2-f3')

  game.position.print_board

  #mode = chess.modes['Checkers']
  #game = mode.make_game([player1,player2],[chess.setups['Checkers'],chess.setups['Checkers']])
  mode = chess.modes['Test']
  game = mode.make_game([player1,player2],[chess.setups['test1'],chess.setups['test1']])
  game.position.print_board
  var = ([0,1,-1].product [0,1,-1] ).to_a
  var.delete([0,0])
  p (var)
  while true do
    m = gets.chomp
    game.step!(m)
    game.position.print_board

    if(game.is_ended?) then
      p game.get_result
      break
    end
    #p game.position.possible_moves
  end
=end

end
