require './classes/cell'
require 'rainbow'
require 'io/console'
require 'tty-prompt'
require 'json'
file =  File.read('./patterns.json')
data_hash = JSON.parse(file)

prompt = TTY::Prompt.new

def setup_board(y,x)
    board = Array.new(y){Array.new(x)}
    board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
            board[row_index][cell_index] = Cell.new()
        end
    end
    return board
end

def neighbourCounter(board_s,row, cell)
    neighbour_count = 0
    if row == 0
        if cell == 0
            neighbour_count =  board_s[row][cell + 1].state 
            neighbour_count += board_s[row + 1][cell].state 
            neighbour_count += board_s[row+ 1][cell+ 1].state
        elsif cell == board_s[0].length()-1
            neighbour_count =  board_s[row][cell - 1].state
            neighbour_count += board_s[row + 1][cell].state 
            neighbour_count += board_s[row + 1][cell - 1].state
        else
            neighbour_count =  board_s[row][cell + 1].state 
            neighbour_count += board_s[row][cell - 1].state 
            neighbour_count += board_s[row + 1][cell].state 
            neighbour_count += board_s[row + 1][cell + 1].state 
            neighbour_count += board_s[row + 1][cell - 1].state
        end
    elsif row == board_s.length()-1
        if cell == 0 
            neighbour_count =  board_s[row][cell + 1].state 
            neighbour_count += board_s[row - 1][cell].state 
            neighbour_count += board_s[row - 1][cell + 1].state 
        elsif cell == board_s[0].length()-1
            neighbour_count = board_s[row][cell - 1].state 
            neighbour_count += board_s[row - 1][cell].state 
            neighbour_count +=  board_s[row - 1][cell - 1].state
        else
            neighbour_count =  board_s[row][cell + 1].state
            neighbour_count += board_s[row][cell - 1].state
            neighbour_count += board_s[row - 1][cell].state
            neighbour_count += board_s[row - 1][cell + 1].state
            neighbour_count += board_s[row - 1][cell - 1].state
        end
    elsif row < board_s.length()-1 && row > 0
        if cell == 0
            neighbour_count =  board_s[row][cell + 1].state
            neighbour_count += board_s[row + 1][cell].state
            neighbour_count += board_s[row - 1][cell].state
            neighbour_count += board_s[row + 1][cell + 1].state
            neighbour_count += board_s[row - 1][cell + 1].state
        elsif cell == board_s[0].length()-1
            neighbour_count =  board_s[row][cell - 1].state
            neighbour_count += board_s[row + 1][cell].state
            neighbour_count += board_s[row - 1][cell].state
            neighbour_count += board_s[row - 1][cell - 1].state
            neighbour_count += board_s[row + 1][cell - 1].state
        else
            neighbour_count =  board_s[row][cell + 1].state
            neighbour_count += board_s[row][cell - 1].state
            neighbour_count += board_s[row + 1][cell].state
            neighbour_count += board_s[row - 1][cell].state
            neighbour_count += board_s[row + 1][cell + 1].state
            neighbour_count += board_s[row - 1][cell + 1].state
            neighbour_count += board_s[row - 1][cell - 1].state
            neighbour_count += board_s[row + 1][cell - 1].state
        end
    end
    return neighbour_count
end

def fill(board, cells)
    filled_board = Marshal.load(Marshal.dump(board))
    i=0
    filled_board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
            if cells == "r"
                cell.state = rand(0..1)
            else
                cell.state = cells[i].to_i
                i += 1 
            end
        end
    end
    return filled_board
end

def generate(board)
    new_board = Marshal.load(Marshal.dump(board))
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
                print Rainbow(cell_display).black
            end
        end
    end
end



def display_loop(board)
    generation = 0
    loop do
        char = STDIN.getch
        puts "\e[H\e[2J"
        display_board(board)
        board = generate(board)
        puts "\nGenerations: #{generation}"
        puts Rainbow("██").red + " lasted 1 or more generations " + Rainbow("██").green + " lasted 3 or more generations "
        puts "Press any key to for another generation, Press q to exit " 
        generation += 1
        break if char == 'q'
    end
end


def custom_board_input(width,height)
    prompt = TTY::Prompt.new
    cus_board = ""
    for i in 1..height do
        row_input = prompt.ask("Input #{width} cells, 0 = dead 1 = alive \n")
        cus_board += row_input
    end
    puts cus_board
    return cus_board
end


def menu
    prompt = TTY::Prompt.new
    file =  File.read('./patterns.json')
    data_hash = JSON.parse(file)
    puts data_hash
    choice = prompt.select("Would you like a pre-set board or custom?", %w(pre-set custom))
    if choice == "custom"
        width = prompt.slider("Width", min: 1, max: 100, step: 1, default:1)
        height = prompt.slider("Height", min: 1, max: 100, step: 1, default:1)
        custom_board = setup_board(height,width)
        ran_or_not = prompt.select("Would you like a to input your own data or generate a random board?", %w(input random))
        if ran_or_not == "input"
            board_input = custom_board_input(width,height)
             custom_board = fill(custom_board,board_input)
             display_loop(custom_board)
        elsif ran_or_not == "random"
            custom_board = fill(custom_board, "r")
            display_loop(custom_board)
        end
        save = prompt.ask("Would you like to save your board? y/n")
        if save == "y"
            name = prompt.ask("What do you want to call your board?")
            data_hash[name] = {"width" => width, "height" => height, "board" => board_input}
            File.write('./patterns.json', JSON.dump(data_hash))
        end
    elsif choice == "pre-set"
        pre_set_choices = data_hash
        pre_set_choice  = prompt.select("Pre-sets", pre_set_choices)
        width = pre_set_choice['width']
        height = pre_set_choice['height']
        cells = pre_set_choice['board']
        preset_board = setup_board(height,width)
        initial_board = fill(preset_board,cells)
        display_loop(initial_board)
    end
end
menu()



