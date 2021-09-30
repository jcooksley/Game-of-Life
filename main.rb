require './classes/cell'
require 'rainbow'
require 'io/console'
require 'tty-prompt'

def setup_board(x,y)
    board = Array.new(x){Array.new(y)}
    board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
            board[row_index][cell_index] = Cell.new()
        end
    end
    return board
end

def neighbourCounter(board,row, cell)
    neighbour_count = 0
    if row == 0
        if cell == 0
            neighbour_count =  board[row][cell + 1].alive? + board[row + 1][cell].alive? + board[row+ 1][cell+ 1].alive?
        elsif cell == board[0].length()-1
            neighbour_count =  board[row][cell - 1].alive? + board[row + 1][cell].alive? + board[row + 1][cell - 1].alive?
        else
            neighbour_count =  board[row][cell + 1].alive? + board[row][cell - 1].alive? + board[row + 1][cell].alive? + board[row + 1][cell + 1].alive? + board[row + 1][cell - 1].alive?
        end
    elsif row == board.length()-1
        if cell == 0 
            neighbour_count =  board[row][cell + 1].alive? + board[row - 1][cell].alive? + board[row - 1][cell + 1].alive? 
        elsif cell == board[0].length()-1
            neighbour_count = board[row][cell - 1].alive? + board[row - 1][cell].alive? +  board[row - 1][cell - 1].alive?
        else
            neighbour_count =  board[row][cell + 1].alive? + board[row][cell - 1].alive? + board[row - 1][cell].alive? +  board[row - 1][cell + 1].alive? + board[row - 1][cell - 1].alive?
        end
    elsif row < board.length()-1 && row > 0
        if cell == 0
            neighbour_count =  board[row][cell + 1].alive? + board[row + 1][cell].alive? + board[row - 1][cell].alive? + board[row + 1][cell + 1].alive? + board[row - 1][cell + 1].alive?
        elsif cell == board[0].length()-1
            neighbour_count =  board[row][cell - 1].alive? + board[row + 1][cell].alive? + board[row - 1][cell].alive? + board[row - 1][cell - 1].alive? + board[row + 1][cell - 1].alive?
        else
            neighbour_count =  board[row][cell + 1].alive? + board[row][cell - 1].alive? + board[row + 1][cell].alive? + board[row - 1][cell].alive? + board[row + 1][cell + 1].alive? + board[row - 1][cell + 1].alive? + board[row - 1][cell - 1].alive? + board[row - 1][cell + 1].alive?
        end
    end
    return neighbour_count
end

def generate(board)
    new_board = board
    board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
            neighbour_count = neighbourCounter(board,row_index,cell_index)
            state = cell.alive?
            if state == 1 && (neighbour_count < 2 || neighbour_count > 3)
                new_board[row_index][cell_index].dead
            elsif state == 0 && neighbour_count == 3
                new_board[row_index][cell_index].alive
            elsif state == 1 && (neighbour_count == 2 || neighbour_count == 3) 
                new_board[row_index][cell_index].alive
                new_board[row_index][cell_index].life += 1
            end
        end
    end
    return new_board
end


def display_board (board)
    pastel  = Pastel.new
    cell_display = "██"
    display_board = board
    display_board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
            if cell_index == 0
                print "\n"
            end
            if cell.state == 1
                if cell.life >= 1 && cell.life < 3
                    print Rainbow(cell_display).red
                elsif cell.life >= 3
                    print Rainbow(cell_display).green
                else 
                    print Rainbow(cell_display).white
                end
            elsif cell.state == 0
                print pastel.black(cell_display)
            end
        end
    end
end

def fill(board)
    i = 0
    board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
            cell.state = rand(0..1)
        end
    end
end

def display_loop
    initial_board  = setup_board(20,80)
    initial_board = fill(initial_board)
    generation = 0
    loop do
        char = STDIN.getch
        puts "\e[H\e[2J"
        display_board(initial_board)
        initial_board = generate(initial_board)
        puts "\nGenerations: #{generation}"
        puts Rainbow("██").red + " lasted 1 or more generations " + Rainbow("██").green + " lasted 3 or more generations "
        puts "Press any key to for another generation, Press q to exit " 
        generation += 1
        break if char == 'q'
    end
end

t = Thread.new{display_loop}
t.join
