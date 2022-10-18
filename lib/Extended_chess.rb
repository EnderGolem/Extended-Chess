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
  p chess.movement_rules['step_forward'].call(nil,nil)
  pawn_d = chess.pieces["Pawn"]
  p pawn_d
  p pawn_d.rules[0].call(nil,nil)
  pawn = Piece.new(Vector.zero(2),'red','red',Vector[0,1],pawn_d)
  p pawn
  puts pawn.calculatePossibleMoves(nil)
  board = Board.new(Array.new(8){Array.new(8){0}})
  board.matrix[2][1] = Piece.new(nil ,nil,nil,nil,nil)
  vec = Vector[0,1]
  puts board.matrix[vec[0]][vec[1]].to_s.colorize(:green)
  pos = Position.new(chess.boards['FFA'])
  del = Proc.new { f }
  arr = [f,f1, f+f1]
  arr.push f
  p arr.sum(init = [])
  m =  Move.new("e2-e3")
  p m.instance_variable_get('@notation')
  p 'Hello world!'
  f
  del.call
  f1
  pos.print_board
  mode = chess.modes['Classic']
  player1 = Player.new('Alex',:red)
  player2 = Player.new('Max',:blue)
  game = mode.make_game([player1,player2],[chess.setups['Classic'],chess.setups['Classic']])
  game.position.print_board
end
