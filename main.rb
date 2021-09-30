def setup_board
    board = Array.new(3){Array.new(3)}
    board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          board[row_index][cell_index] = rand(0..1)
        end
    end
    return board
end

def generate(board)
    new_board = board
    board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
            neighbour_count = 0
            if row_index == 0
                if cell_index == 0
                    neighbour_count =  board[row_index][cell_index + 1].to_i + board[row_index + 1][cell_index].to_i + board[row_index + 1][cell_index + 1].to_i
                elsif cell_index == 2
                    neighbour_count =  board[row_index][cell_index - 1].to_i + board[row_index + 1][cell_index].to_i + board[row_index + 1][cell_index - 1].to_i
                else
                    neighbour_count =  board[row_index][cell_index + 1].to_i + board[row_index][cell_index - 1].to_i + board[row_index + 1][cell_index].to_i + board[row_index + 1][cell_index + 1].to_i + board[row_index + 1][cell_index - 1].to_i
                end
            elsif row_index == 2
                if cell_index == 0 
                    neighbour_count =  board[row_index][cell_index + 1].to_i + board[row_index - 1][cell_index].to_i + board[row_index - 1][cell_index + 1].to_i 
                elsif cell_index == 2
                    neighbour_count = board[row_index][cell_index - 1].to_i + board[row_index - 1][cell_index].to_i +  board[row_index - 1][cell_index - 1].to_i
                else
                    neighbour_count =  board[row_index][cell_index + 1].to_i + board[row_index][cell_index - 1].to_i + board[row_index - 1][cell_index].to_i +  board[row_index - 1][cell_index + 1].to_i + board[row_index - 1][cell_index - 1].to_i
                end
            else
                neighbour_count =  board[row_index][cell_index + 1].to_i + board[row_index][cell_index - 1].to_i + board[row_index + 1][cell_index].to_i + board[row_index - 1][cell_index].to_i + board[row_index + 1][cell_index + 1].to_i + board[row_index - 1][cell_index + 1].to_i + board[row_index - 1][cell_index - 1].to_i + board[row_index + 1][cell_index - 1].to_i
            end
            if board[row_index][cell_index ] == 1 && (neighbour_count < 2 || neighbour_count > 3)
                    new_board[row_index][cell_index] = 0
            elsif board[row_index][cell_index] == 0 && neighbour_count == 3
                new_board[row_index][cell_index] = 1  
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
                print "█"
            elsif display_board[row_index][cell_index] == 0
                print " "
            end
        end
    end
end

initial_board  = setup_board()
display_board(initial_board)
print "\n"
display_board(generate(initial_board))
i = 0
loop do 
    i = i+1
    puts "\e[H\e[2J"
    display_board(initial_board)
    initial_board = generate(initial_board)
    if i == 50
        break
    end
end