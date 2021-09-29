def setup_board
    board = Array.new(10){Array.new(10)}

    board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          board[row_index][cell_index] = rand(0..1)
        end
    end
    
    print board
end

setup_board()