

require 'colorize'
require_relative 'Position'
require_relative 'Chess'
require_relative 'Move'
require_relative 'Player'
require_relative 'Board'
require_relative 'Helpers/notation_translation_helper'

def f
  [Move.new("e2-e3"), Move.new("e2-e4")]
end

def f1
  [112,34,67]
end
module ExtendedChess


  chess = Chess.new
  mode = chess.modes['Classic']
  player1 = Player.new('Alex',:red)
  player2 = Player.new('Max',:blue)
  game = mode.make_game([player1,player2],[chess.setups['Classic'],chess.setups['Classic']])
  #puts game.position.possible_moves
  game.position.print_board


  game.step!('e2-e3')
  game.step!('c7-c6')
  game.step!('c6-c5')
  game.step!('a7-a5')
  game.step!('f2-f3')


  game.position.print_board

  puts NotationTranslationHelper.array_to_notation([5,2]);
  puts NotationTranslationHelper.notation_to_array('c6');

  mode = chess.modes['Checkers']
  game = mode.make_game([player1,player2],[chess.setups['Checkers'],chess.setups['Checkers']])
  game.position.print_board

  while true do
    m = gets.chomp
    game.step!(m)
    game.position.print_board
    #p game.position.possible_moves
  end
end
