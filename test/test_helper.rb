# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "Chess"
require"player"
require 'Position'
require 'colorize'
require 'game'
require 'GameResult'
require 'interface'
require 'Mode'

require "minitest/autorun"

# Сравнивает две матрицы
def equal_matrix?(game_matrix, test_matrix)
  game_matrix.each_index do |i|
    game_matrix[i].each_index do |j|
      if !((game_matrix[i][j].class == Piece and game_matrix[i][j].piece_description.name == test_matrix[i][j]) or (game_matrix[i][j].class != Piece and test_matrix[i][j].nil?))
        return false
      end
    end
  end
  return true
end

