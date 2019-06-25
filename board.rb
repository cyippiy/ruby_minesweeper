require './space'

class Board
    attr_reader :board, :bombs, :flag_count, :bomb_click

    def initialize(board = Array.new(5){ Array.new(5) { Space.new }})
        @board = board
        @bombs = {}
        @flag_count = 0
        @bomb_click = false
    end

    def setup_board(bombs=5)
        @board.each do |row|
            row.each do |space|
                space.reset
            end
        end
        @bombs = {}
        i = 0
        x = rand(@board.length)
        y = rand(@board[0].length)
        while i < bombs
            while @board[x][y].is_bomb?
                x = rand(@board.length)
                y = rand(@board[0].length)
            end
            @board[x][y].value = :bomb
            @bombs["#{x},#{y}"] = 1
            i+=1
        end

        evaluate_spaces
    end

    def [](x,y)
        @board[x][y]
    end

    def render
        output_row = ""
        row_dashes = ""
        @board.each_with_index do |row,idx1|
            output_row = "|"
            row_dashes = "-"
            row.each do |space,idx2|
                output_row+=" #{space.display} |" unless game_over? == true
                output_row+=" #{space.display_end} |" if game_over? == true
                row_dashes+="----"
            end
            puts row_dashes if idx1 == 0
            puts output_row
            puts row_dashes
        end
        return
    end


    def flag(x,y)
        cord = "#{x},#{y}"
        spot = @board[x][y]
        unless spot.show
            spot.toggle_flag
            if spot.flag
                @flag_count +=1
                if @bombs[cord] == 1
                    @bombs[cord] = 0
                end
            else
                @flag_count -= 1
                if @bombs[cord] == 0
                    @bombs[cord] = 1
                end
            end
        end
    end

    def click(x,y)
        spot = @board[x][y]
        @bomb_click = true if spot.is_bomb? 
        reveal(x,y) unless spot.flag
        # spot.toggle_show unless spot.flag
    end

    def game_over?
        winner? or @bomb_click
    end

    def winner?
        @bombs.each do |k,v|
            return false unless v == 0
        end
        if @bombs.keys.length == @flag_count
            end_game
            render
            return true 
        end
    end


    def evaluate_spaces
        i = 0
        while i < @board.length
            j = 0
            while j < @board[0].length
                check_neighbors(i,j)
                j+=1
            end
            i+=1
        end
    end

    def check_neighbors(i,j)
        count = 0
        return :bomb if @board[i][j].is_bomb?

        (-1..1).each do |idx|
            (-1..1).each do |idj|
                x = i+idx
                y = j+idj
                if (x>=0) and (y>=0) and (y<@board[0].length) and (x < @board.length)
                    unless x == y and idx == 0
                    count+=1 if @board[x][y].is_bomb?
                    end
                end
            end

        end

        @board[i][j].value = count
        return count
    end

    def end_game
        @board.each do |row|
            row.each do |space|
                space.toggle_show
            end
        end
    end

    def reveal(x,y)
        neighbors = []
        if (x < 0 or y < 0) or (x>= @board.length or y>= @board[0].length)
            return
        end
        space = @board[x][y]
        return if space.show or space.flag
        if space.is_bomb?
            return :bomb
        end
        space.toggle_show
        if space.value > 0
            return space.value
        else
            neighbors << [x-1,y-1] if self[x-1,y-1]
            neighbors << [x-1,y] if self[x-1,y]
            neighbors << [x-1,y+1] if self[x-1,y+1]
            neighbors << [x,y-1] if self[x,y-1]
            neighbors << [x+1,y-1] if self[x+1,y-1]
            neighbors << [x,y+1] if self[x,y+1]
            neighbors << [x+1,y] if self[x+1,y]
            neighbors << [x+1,y+1] if self[x+1,y+1]

            until neighbors.empty?
                cord = neighbors.pop
                reveal(cord[0],cord[1])
            end
        end
    end
end