require './classes/cell'
def setup_board
    board = Array.new(3){Array.new(3)}
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
    new_board = setup_board
    board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
            neighbour_count = neighbourCounter(board,row_index,cell_index)
            state = board[row_index][cell_index].alive?
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
    display_board = board
    display_board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
            if cell_index == 0
                print "\n"
            end
            if cell.state == 1
                print "1"
            elsif cell.state == 0
                print "0"
            end
        end
    end
end

def fill(board)
    i = 0
    board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
            cell.state = rand(0..1)
            # cell.state = j[i]
            # i += 1
        end
    end
end

initial_board  = setup_board()
initial_board = fill(initial_board)
# stripe = [0,0,0,1,1,1,0,0,0]
# initial_board = fill(initial_board, stripe)
# initial_board = [[0,0,0,],[1,1,1],[0,0,0]]
i = 0
loop do 
    i = i+1
    display_board(initial_board)
    sleep 0.2
    initial_board = generate(initial_board)
    puts "\e[H\e[2J"
    print "\n"
    if i == 5
        break
    end
end