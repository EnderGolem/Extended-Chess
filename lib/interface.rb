require_relative 'Chess'
require_relative 'Move'
require_relative 'Mode'


class Interface
  attr_reader :chess

  def initialize
    @chess = Chess.new()
  end
  def start
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

    players = Array.new(a)
    a -= 1;
    while a >= 0
      players[a] = (choose_player(players));
      a -= 1;
    end

    puts "Players: "
    players.each {|player|  puts player.name.colorize(player.color) }

    puts "Choose mode"
    mode = choose_mode()

    setups = choose_setups(players)

    puts "START GAME"
    game = mode.make_game(players, setups)

    game.position.print_board
    while true do
      puts ("Move player: " + game.position.get_cur_color_player().name ).colorize(game.position.get_cur_color_player())  #Написать правильно
      step = gets.chomp
      if(!game.step!(step))
        puts "WRONG MOVE".colorize(:red)  #Написать правильно
        redo
      end
      game.position.print_board
      if(game.is_ended?) then
        p game.get_result
        break
      end
      #p game.p
    end
  end

  def choose_setups(players)
    setups = Array.new(players.size)
    players.each_index  do |ind|
      player = players[ind]
      puts ("Choose setup, player: " + player.name).colorize(player.color)
      @chess.setups.each_key{ |setup_key|    puts setup_key }
      setup = ""
      loop do
        setup = readline().chomp
        if(@chess.setups.has_key?(setup))
          break
        end
        puts "Not a correct setup".colorize(:red)
      end
      setups[ind] = @chess.setups[setup]
    end
    return setups
  end
  def choose_mode
    @chess.modes.each_value { |mode|   puts @chess.modes.key(mode) }
    mode = ""
    loop do
      mode = readline().chomp
      if(@chess.modes.has_key?(mode))
        break
      end
      puts "Not a correct mod".colorize(:red)
    end
    return @chess.modes[mode]
  end


  #players - Array[Class: player]
  #name - String
  def is_name_taken?(players, name)
    players.each_index do |ind|
      if(players[ind].class != NilClass && name == players[ind].name)
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
      name = readline().chop()
      if not is_name_taken?(players, name)
        break
      end
      puts "This name already taken".colorize(:red)
      puts "Enter another name"
    end

    puts "Choose your color"
    color = :a
    available_colors = [:red,:blue,:white,:black]
    players.each_index do |ind|
      if(players[ind].class != NilClass)
        available_colors.delete(players[ind].color)
        end
    end
    available_colors.each_index { |index| puts index.to_s + ": " + available_colors[index].to_s  }

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
