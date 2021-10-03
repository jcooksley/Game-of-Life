class Cell
    attr_accessor :state, :life

    def initialize
        @state = 0
        @life = 0
    end

    def initialize_copy(original_cell)
        @state = original_cell.state.dup
    end
    def alive
        @state = 1
    end

    def dead
        @state = 0
        @life = 0
    end
    
    def alive?
        @state
    end
end