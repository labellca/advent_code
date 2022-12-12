###########
#### Data
fn = "_data/day10.txt"
f = open(fn, "r")
data  = readlines(f)
close(f)


###########
#### Part 1
cycle = 0
x_register = 1
cycle_check = 20
sum_signal_strength = 0

while cycle_check <= 220
    for line in data
        cmd = split(line, " ")

        if "noop" == cmd[1]
            cycle += 1
            if cycle % cycle_check == 0
                sum_signal_strength += cycle * x_register
                cycle_check += 40
            end
        else
            if (cycle + 2) % cycle_check == 0
                sum_signal_strength += (cycle + 2) * x_register
                cycle_check += 40
            elseif (cycle + 1) % cycle_check == 0
                sum_signal_strength += (cycle + 1) * x_register
                cycle_check += 40
            end
            cycle += 2
            x_register += parse(Int, cmd[2])
        end
    end
end

## Find the signal strength during the 20th, 60th, 100th, 140th, 180th, and 220th cycles. What is the sum of these six signal strengths?
println(cycle_check)
println(sum_signal_strength)

###########
#### Part 2
function checkRow(cycle::Int64)
    if (cycle % w) == 0
        return 1
    else 
        return 0
    end
end

function CRTdraw(cycle::Int64, sprite_pos::Array{String})
    if sprite_pos[(cycle % w)+1] == "#"
        print(" CRT draws pixel (#) in position ", (cycle % w))
        return "#"
    else
        print(" CRT draws pixel (.) in position ", (cycle % w))
        return "."
    end
end

w = 40
h = 6
CRT = [copy(repeat([""], w)) for i in 1:h]
cycle = 0
x_register = 1
row = 1

for line in data
    cmd = split(line, " ") 

    ## sprite psoition 
    sprite_pos = repeat(["."], w)
    sprite_pos[abs(x_register):x_register+2] = repeat(["#"], length(abs(x_register):x_register+2))
    println("Sprite position: ", join(sprite_pos))
    println()

    ## execute command
    println("Start cycle $cycle : begin executing $line")
    print("During cycle $cycle : ")
    row += checkRow(row)
    CRT[row][(cycle % w)+1] = CRTdraw(cycle, sprite_pos)
    print(" -- Row $row")
    println("\nCurrent CRT row: ", join(CRT[row]))

    if cmd[1] == "noop"
        println("End of cycle $cycle : finishing executing $line")
        println()
        cycle += 1
        row += checkRow(cycle)
    else
        cycle += 1
        row += checkRow(cycle)

        println()
        print("During cycle $cycle : ")
        CRT[row][(cycle % w)+1] = CRTdraw(cycle, sprite_pos)
        print(" -- Row $row")
        println("\nCurrent CRT row: ", join(CRT[row]))

        x_register += parse(Int, cmd[2])
        println("End of cycle $cycle : finishing executing $line (Register X is now $x_register)")
        cycle += 1
        row += checkRow(cycle)
        
    end
    
end


## Render the image given by your program. What eight capital letters appear on your CRT?
for row in CRT
    println(join(row))
end
