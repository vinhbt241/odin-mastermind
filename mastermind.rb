require 'colorize'

class Mastermind
  CIRCLE = "●"  
  HOLLOW_CIRCLE = "○"

  def initialize()
    @board = [Array.new(4, HOLLOW_CIRCLE), Array.new(4, HOLLOW_CIRCLE)]
    @display_message = "Type in your guess: "
    system 'clear'
    until stop?()
      puts "      MASTERMIND"
      build_board(@board)
      print @display_message
      input = gets.chomp
      get_input(input)
      if board_filled?()
        #check with result
        @stop_sign = true
      end
      system 'clear' 
    end
  end

  private

  def build_board(board)
    frame_up = "╔═════════╦═════════╗\n" 
    frame_down = "╚═════════╩═════════╝\n"
    display_guess = board[0].map { |c| " #{c}" }.join("")
    display_result = board[1].map { |c| " #{c}" }.join("")
    frame_side = "║" + display_guess + " ║" + display_result + " ║\n"
    print frame_up + frame_side + frame_down
  end 

  def stop?()
    if @stop_sign == true
      puts "GAME OVER"
      return true
    end
    false
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
    until @board[0][i] == HOLLOW_CIRCLE
      i += 1
    end 
    case choice
    when "black" then @board[0][i] = CIRCLE.black
    when "white" then @board[0][i] = CIRCLE.white
    when "red" then @board[0][i] = CIRCLE.red
    when "green" then @board[0][i] = CIRCLE.green
    when "blue" then @board[0][i] = CIRCLE.blue
    when "yellow" then @board[0][i] = CIRCLE.yellow
    end
  end

  def board_filled?()
    return false if @board[0].any?(HOLLOW_CIRCLE)
    true
  end

end

game = Mastermind.new()
