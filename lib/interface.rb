require_relative 'Chess'
require_relative 'Move'
require_relative 'Mode'


class Interface
  attr_reader :chess

  def initialize
    @chess = Chess.new()
  end
  def inteface()

    puts "Select the number of players"
    puts "You can choose only two"
    a = 0
    loop do
      a = readline().to_i
      if a == 2
        break
      end
      puts "YOU CAN CHOOSE ONLY TWO".colorize(:red)
    end

    players = Hash.new()
    while a > 0
      players[a] = (choose_player(players));
      a -= 1;
    end

    puts "Players: "
    players.each_value do |player|
      puts player.name.colorize(player.color)
    end

    puts "Choose mode"
    @chess.modes.each_value do |mode|
      puts @chess.modes.key(mode)
    end
    mode = ""
    loop do
      mode = readline().chomp
      if(@chess.modes.has_key?(mode))
        break
      end
      puts "Not a correct mod".colorize(:red)
    end


    puts "Choose setup"
    setups = Hash.new()
    players.each_value do |player|
      @chess.setups.each_key do |setup_key|
        puts setup_key
      end
      setup = ""
      loop do
        setup = readline().chomp
        if(@chess.setups.has_key?(setup))
          break
        end
        puts "Not a correct setup".colorize(:red)
      end
      setups[player.name] = setup
    end


    puts "START GAME"
    #TODO game


  end

  #players - Array[Class: player]
  #name - String
  def is_name_taken?(players, name)
    players.each_value do |player|
      if(name == player.name)
        return  true
      end
    end
    return  false
  end
  #players - Array[Class: player]
  def choose_player(players)
    puts "Enter your name"
    name = ""
    loop do
      name = readline()
      if not is_name_taken?(players, name)
        break
      end
      puts "This name already taken".colorize(:red)
      puts "Enter another name"
    end


    puts "Choose your color"
    color = :a
    available_colors = [:red,:blue,:white,:black]
    players.each_value do |player|
      available_colors.delete(player.color)
    end
    available_colors.each_index do |index|
      puts index.to_s + ": " + available_colors[index].to_s
    end

    loop do
      color = readline().to_i
      if color < available_colors.size and color >= 0
        color = available_colors[color]
        break
      end
      puts "Choose correct color".colorize(:red)
    end
    return Player.new(name, color)
   end
end
