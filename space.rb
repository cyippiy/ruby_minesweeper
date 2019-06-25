class Space
    attr_accessor :value, :show, :flag

    def initialize(value = 0,show=false,flag=false)
        @value = value
        @show = show
        @flag = flag
    end

    def reset
        @value = 0
        @show = false
        @flag = false
    end

    def is_bomb?
        @value == :bomb
    end

    def display
        return "F" if @flag == true
        return " " if @show == false and @flag == false
        return "B" if @value == :bomb
        return @value
    end

    def toggle_flag
        @flag = !@flag
    end

    def toggle_show
        @show = !@show unless @show
    end

    def to_s
        "Space value:#{@value} show:#{@show} flag: #{@flag}"
    end

    def inspect
        "Space value:#{@value} show:#{@show} flag: #{@flag} "
    end

end