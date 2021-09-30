def setup_board
    board = Array.new(20){Array.new(80)}
    board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          board[row_index][cell_index] = rand(0..1)
        end
    end
    return board
end

def neighbourCounter(board,row, cell)
    neighbour_count = 0
    if row == 0
        if cell == 0
            neighbour_count =  board[row][cell + 1].to_i + board[row + 1][cell].to_i + board[row+ 1][cell+ 1].to_i
        elsif cell == board[0].length()-1
            neighbour_count =  board[row][cell - 1].to_i + board[row + 1][cell].to_i + board[row + 1][cell - 1].to_i
        else
            neighbour_count =  board[row][cell + 1].to_i + board[row][cell - 1].to_i + board[row + 1][cell].to_i + board[row + 1][cell + 1].to_i + board[row + 1][cell - 1].to_i
        end
    elsif row == board.length()-1
        if cell == 0 
            neighbour_count =  board[row][cell + 1].to_i + board[row - 1][cell].to_i + board[row - 1][cell + 1].to_i 
        elsif cell == board[0].length()-1
            neighbour_count = board[row][cell - 1].to_i + board[row - 1][cell].to_i +  board[row - 1][cell - 1].to_i
        else
            neighbour_count =  board[row][cell + 1].to_i + board[row][cell - 1].to_i + board[row - 1][cell].to_i +  board[row - 1][cell + 1].to_i + board[row - 1][cell - 1].to_i
        end
    elsif row < board.length()-1 && row > 0
        if cell == 0
            neighbour_count =  board[row][cell + 1].to_i + board[row + 1][cell].to_i + board[row - 1][cell].to_i + board[row + 1][cell + 1].to_i + board[row - 1][cell + 1].to_i
        elsif cell == board[0].length()-1
            neighbour_count =  board[row][cell - 1].to_i + board[row + 1][cell].to_i + board[row - 1][cell].to_i + board[row - 1][cell - 1].to_i + board[row + 1][cell - 1].to_i
        else
            neighbour_count =  board[row][cell + 1].to_i + board[row][cell - 1].to_i + board[row + 1][cell].to_i + board[row - 1][cell].to_i + board[row + 1][cell + 1].to_i + board[row - 1][cell + 1].to_i + board[row - 1][cell - 1].to_i + board[row - 1][cell + 1].to_i
        end
    end
    return neighbour_count
end

def generate(board)
    new_board = setup_board
    board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
            neighbour_count = neighbourCounter(board,row_index,cell_index)
            state = board[row_index][cell_index]
            if state == 1 && (neighbour_count < 2 || neighbour_count > 3)
                new_board[row_index][cell_index] = 0
            elsif state == 0 && neighbour_count == 3
                new_board[row_index][cell_index] = 1  
            else
                new_board[row_index][cell_index] = state
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
            if display_board[row_index][cell_index] == 1
                print "██"
            elsif display_board[row_index][cell_index] == 0
                print "  "
            end
        end
    end
end

initial_board  = setup_board()
# initial_board = [[0,0,0,],[1,1,1],[0,0,0]]
i = 0
loop do 
    i = i+1
    display_board(initial_board)
    sleep 0.2
    initial_board = generate(initial_board)
    puts "\e[H\e[2J"
    print "\n"
    if i == 20
        break
    end
end