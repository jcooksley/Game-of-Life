def setup_board
    board = Array.new(10){Array.new(100)}
    board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          board[row_index][cell_index] = rand(0..1)
        end
    end
    return board
end

def display_board
    new_board = setup_board()
    new_board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
            if cell_index == 0
                print "\n"
            end
            if new_board[row_index][cell_index] == 1
                print "█"
            elsif new_board[row_index][cell_index] == 0
                print " "
            end
        end
    end
end


setup_board()
display_board()