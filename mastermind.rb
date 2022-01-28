require 'colorize'

class Mastermind
  CIRCLE = "●"  
  HOLLOW_CIRCLE = "○"
  CIRCLE_COLLECTION = [CIRCLE.black, CIRCLE.white, CIRCLE.red, CIRCLE.green, CIRCLE.blue, CIRCLE.yellow]

  def initialize()
    
    mode = choose_mode()

    # init valriables for game
    if mode == "CODE MAKER"
      puts "Code maker mode!"
      @board_length = get_length("How many guesses thou shall give the lowly machine? (I personally suggest 12)")
      @board = Array.new(@board_length) { [Array.new(4, HOLLOW_CIRCLE), Array.new(4, HOLLOW_CIRCLE)] }
      @code = make_code()
      puts "Now, we shall see the lowly machines struggle..."
      guesses = code_breaker()
      if guesses > @board_length
        puts "It's seem like these machine don't stand a chance, my lord"
      else
        puts "MACHINE WON"
      end

    end
    
    if mode == "CODE BREAKER"
      board_length = get_length("How many guess do you want to take? (I personally suggest 12)")
      @board = Array.new(board_length) { [Array.new(4, HOLLOW_CIRCLE), Array.new(4, HOLLOW_CIRCLE)] }
      @current_row = 0
      @code = Array.new(4) { |circle| circle = CIRCLE_COLLECTION.sample } 
      @stop_sign = false
      @victory_sign = false
      @display_message = "Type in your guess: "

      # Run game
      system 'clear'
      until @stop_sign == true || @current_row >= @board.length || @victory_sign
        build_board(@board)
        print @display_message
        input = gets.chomp
        get_input(input)
        if row_filled?(0)
          result = check_result(@code, @board[@current_row][0])
          process_result(result)
          check_vitory = row_filled?(1) && @board[@current_row][1].all?(CIRCLE.red)
          @victory_sign = true if check_vitory
          @current_row += 1
        end
        system 'clear' 
      end
      build_board(@board)
      display_code()
      stop() if @stop_sign
      victory() if @victory_sign
      puts "GAME OVER"
    end

  end

  private

  def build_board(board)
    puts "      MASTERMIND"
    frame = ""
    board.each_with_index do |row, index|
      frame += "╔═════════╦═════════╗\n" if index == 0
      display_guess = row[0].map { |c| " #{c}" }.join("") 
      display_result = row[1].map { |c| " #{c}" }.join("")
      frame += "║" + display_guess + " ║" + display_result + " ║\n"
      if index == board.length - 1
        frame += "╚═════════╩═════════╝\n"
      else
        frame += "╠═════════╬═════════╣\n"
      end
    end
    print frame
  end 

  def stop()
    puts "GAME HAS BEEN STOPPED"
  end

  def get_input(input)
    if input == "S"
      @stop_sign = true
    elsif ["black", "white", "red", "green", "blue", "yellow"].any?(input)
      @display_message = "Type in your guess: "
      process_input(input)
    else 
      @display_message = "Invalid input, try again: "
    end
  end

  def process_input(choice)
    i = 0
    until @board[@current_row][0][i] == HOLLOW_CIRCLE
      i += 1
    end 
    case choice
    when "black" then @board[@current_row][0][i] = CIRCLE.black
    when "white" then @board[@current_row][0][i] = CIRCLE.white
    when "red" then @board[@current_row][0][i] = CIRCLE.red
    when "green" then @board[@current_row][0][i] = CIRCLE.green
    when "blue" then @board[@current_row][0][i] = CIRCLE.blue
    when "yellow" then @board[@current_row][0][i] = CIRCLE.yellow
    end
  end

  def row_filled?(index)
    return false if @board[@current_row][index].any?(HOLLOW_CIRCLE)
    true
  end

  def check_result(code, board)
    correct_positions = Hash.new(0)
    result = {
      correct_position: 0,
      wrong_position: 0
    }
    code_to_guess = code.dup
    row_to_check = board.dup

    row_to_check.each_with_index do |circle, index|
      if @code[index] == circle
        correct_positions[circle] += 1
      end
    end

    correct_positions.each_value { |v| result[:correct_position] += v }

    uniq_colors = row_to_check.uniq()
    uniq_colors.each do |color|
      if code_to_guess.any?(color)
        count_guess = code_to_guess.count(color)
        count_check = row_to_check.count(color)
        if count_guess > count_check
          wrong_position = count_check - correct_positions[color]
        else
          wrong_position = count_guess - correct_positions[color]
        end
         result[:wrong_position] += wrong_position
      end
    end
    
    result

  end

  def process_result(result)
    index_display = 0
    result.each do |position| 
      symbol = position[0]
      quantity = position[1]
      while quantity > 0
        if symbol == :correct_position
          @board[@current_row][1][index_display] = CIRCLE.red
        else
          @board[@current_row][1][index_display] = CIRCLE.white
        end
        index_display += 1
        quantity -= 1
      end
    end
  end

  def victory()
    puts "CONGRATULATION, YOU WON!"
  end

  def get_length(message)
    while true
      system 'clear'
      puts message
      board_length = gets.chomp
      if (board_length.match?(/\d+/))
        board_length = board_length.to_i
        if board_length % 2 == 0
          return board_length
        else
          message = "Invalid length, length must be even"
        end
      else
        message =  "Invalid input, input must be even number" 
      end
    end
  end
  
  def display_code()
    print "THE CORRECT CODE IS"
    @code.each { |c| print " #{c} " }
    print "\n"
  end

  def choose_mode()
    puts "The time has come." 
    puts "Would you like to become a brave Code Dreaker and fight with the Machine Lord," 
    puts "or would you like to become the Code Maker - a powerful god who toy with machine peasant by the code you create?"
    print "Type B to become code Breaker, or M to become Code Maker: "
    while true
      player_choice = gets.chomp
      if player_choice == "B"
        return "CODE BREAKER"
      elsif player_choice == "M"
        return "CODE MAKER"
      else
        print "There is no such character, choose again: "
      end
    end
  end

  def make_code()
    message = "Type in your code: "
    i = 0
    code = Array.new(4, HOLLOW_CIRCLE)
    while code.any?(HOLLOW_CIRCLE)
      system 'clear'
      puts "Now thou shall create the sacred, unbreakable code, which the machine can't never guess!"
      display = "                                     "
      code.each { |c| display += " #{c}" }
      puts display
      print message
      input = gets.chomp
      if ["black", "white", "red", "green", "blue", "yellow"].any?(input)
        case input
        when "black" then code[i] = CIRCLE.black
        when "white" then code[i] = CIRCLE.white
        when "red" then code[i] = CIRCLE.red
        when "green" then code[i] = CIRCLE.green
        when "blue" then code[i] = CIRCLE.blue
        when "yellow" then code[i] = CIRCLE.yellow
        end
        i += 1
        message = "Type in your code: "
      else
        message = "Invalid input, try again: "
      end
    end

    system 'clear'
    display = ""
    code.each { |c| display += " #{c}" }
    puts "Thou's code is#{display}, what a marvelous code!"

    code
  end

  def code_breaker()
    guesses = 0
    arr_to_check = Array.new()

    CIRCLE_COLLECTION.each do |first_circle|
      arr = [first_circle]
      CIRCLE_COLLECTION.each do |second_circle|
        arr.push(second_circle)
        CIRCLE_COLLECTION.each do |third_circle|
          arr.push(third_circle)
          CIRCLE_COLLECTION.each do |fourth_circle|
            arr.push(fourth_circle)
            arr_to_check.push(arr.dup)
            arr.pop()
          end
          arr.pop()
        end
        arr.pop()
      end
      arr.pop()
    end

    guess = [CIRCLE.red, CIRCLE.red, CIRCLE.green, CIRCLE.green]
    guess_have_taken = [guess]
    display_guess = "Machine has guess:"
    guess.each { |g| display_guess += " #{g}"}
    display_guess += "\n"
    print display_guess
    result = check_result(@code, guess)
    guesses += 1


    until result[:correct_position] == 4
      arr_to_check.filter! do |posibility|
        pos_result = check_result(posibility, guess)
        check1 = pos_result[:correct_position] == result[:correct_position]
        check2 = pos_result[:wrong_position] == result[:wrong_position]
        check1 && check2
      end
      while guess_have_taken.any?(guess)
        guess = arr_to_check.sample()
      end
      guess_have_taken.push(guess.dup)
      display_guess = "Machine has guess:"
      guess.each { |g| display_guess += " #{g}"}
      display_guess += "\n"
      print display_guess
      result = check_result(@code, guess)
      guesses += 1
    end

    puts "Thou have set the number of guesses, which is #{@board_length}"
    puts "Machine has take #{guesses} guesses to find the correct answer"

    guesses

  end

end

game = Mastermind.new()

