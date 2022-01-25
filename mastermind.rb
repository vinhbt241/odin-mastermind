require 'colorize'

class Mastermind
  CIRCLE = "●"  
  HOLLOW_CIRCLE = "○"
  CIRCLE_COLLECTION = [CIRCLE.black, CIRCLE.white, CIRCLE.red, CIRCLE.green, CIRCLE.blue, CIRCLE.yellow]

  def initialize()
    # init valriables for game
    @board = Array.new(6) { [Array.new(4, HOLLOW_CIRCLE), Array.new(4, HOLLOW_CIRCLE)] }
    @current_row = 0
    @code = Array.new(4) { |circle| circle = CIRCLE_COLLECTION.sample }
    @stop_sign = false
    @victory_sign = false
    @display_message = "Type in your guess: "

    # Run game
    # system 'clear'
    until @stop_sign == true || @current_row >= @board.length || @victory_sign
      @code.each { |c| print " #{c} " }
      puts "      MASTERMIND"
      build_board(@board)
      print @display_message
      input = gets.chomp
      get_input(input)
      if row_filled?(0)
        check_result()
        check_vitory = row_filled?(1) && @board[@current_row][1].all?(CIRCLE.red)
        @victory_sign = true if check_vitory
        @current_row += 1
      end
      # system 'clear' 
    end
    stop() if @stop_sign
    victory() if @victory_sign
    puts "GAME OVER"
  end

  private

  def build_board(board)
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

  def check_result()
    result = {
      correct_position: 0,
      wrong_position: 0
    }

    row_to_check = @board[@current_row][0]
    code_to_guess = @code.dup

    row_to_check.each_with_index do |circle, index|
      puts  "code #{@code[index]}"
      code_to_guess.each { |i| puts "Code to guess #{i}" }
      if code_to_guess.any?(circle)
        # BUG: ELEMENT WAS REMOVED BEFORE COMAPRE CORRECTLY
        if @code[index] == circle
          result[:correct_position] += 1
        else
          result[:wrong_position] += 1
        end 

        index_to_del = code_to_guess.index(circle)
        code_to_guess.delete_at(index_to_del)

      end
    end
    process_result(result)

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

end

game = Mastermind.new()
