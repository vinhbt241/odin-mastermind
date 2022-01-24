require 'colorize'

class Mastermind
  def initialize
    circle = "●"  
    hollow_circle = "○"
    circles_collection = [hollow_circle, circle.white, circle.black, circle.green, circle.red, circle.yellow, circle.blue] 
    circles_collection.each {|c| print " #{c} "}
  end


end

game = Mastermind.new()
