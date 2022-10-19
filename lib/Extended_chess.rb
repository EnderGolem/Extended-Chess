# frozen_string_literal: true

require 'colorize'
require_relative 'Position'
require_relative 'Chess'
require_relative 'Move'
require_relative 'Player'

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
  game.position.print_board
end
