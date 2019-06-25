require "./board"

class Game
    attr_accessor :board

    def initialize
        @board = nil
        mode = nil
        input = ""
    end


    def play
        puts "MINESWEEPER!"
        setup = false
        until setup
            puts "type e for easy, m for medium, h for hard "
            settings = gets.chomp
            if settings.downcase  == "e"
                @board = Board.new
                @board.setup_board
                setup = true
                mode = :easy
            elsif settings.downcase == "m"
                @board = Board.new(Array.new(10){ Array.new(10) { Space.new }})
                @board.setup_board(10)
                setup = true
                mode = :medium
            elsif settings.downcase == "h"
                @board = Board.new(Array.new(20){ Array.new(20) { Space.new }})
                @board.setup_board(20)
                setup = true
                mode = :hard
            end
        end
        until game_over?
            system "clear"
            @board.render
            puts "Enter coordinates with (f)lag or (c)lick"
            puts "EG: Click is c,0,0. Flag is f,0,0"
            input = gets.chomp.downcase
            if valid_move?(input)
                input = input.split(",")
                input[1] = input[1].to_i
                input[2] = input[2].to_i
                if input[0] == "c"
                    last = @board.click(input[1],input[2])
                elsif input[0] == "f"
                    @board.flag(input[1],input[2])
                end
            end
        end
        system "clear"
        @board.end_game
        @board.render
        if @board.winner?
            puts "WINNER!!!"
        else
            puts "Game over. #{input[1]},#{input[2]} was a bomb"
        end
        puts "to play again, press enter. type exit to exit"
        input = gets.chomp.downcase
        unless input == "exit"
            self.play
        end
    end

    def game_over?
        @board.game_over?
    end

    def valid_move?(str)
        input = str.split(",")
        valid = "fc"
        return false unless input.length == 3
        return false unless valid.include?(input[0])
        input[1] = input[1].to_i
        input[2] = input[2].to_i
        return false unless input[1].is_a? Numeric and input[2].is_a? Numeric
        if input[1] < 0 or input[2] < 0
            return false
        elsif input[1] > @board.board.length or input[2] > @board.board[0].length
            return false
        end
        return true
    end

end