include("../utils.jl")

### input
### heightmap of the floor of the nearby caves for you
fn = "2021_09.txt"
input = readInput(fn)
data = parseInput_Array(input)

function neighbours(mtx, pos_x, pos_y, X, Y)
    val_neighbours = []

    if pos_x != 1
        push!(val_neighbours, mtx[pos_x-1, pos_y])
    end
    if pos_x != X
        push!(val_neighbours, mtx[pos_x+1, pos_y])
    end
    if pos_y != 1
        push!(val_neighbours, mtx[pos_x, pos_y-1])
    end
    if pos_y != Y
        push!(val_neighbours, mtx[pos_x, pos_y+1])
    end

    return val_neighbours
end


X, Y= size(data)
risk_levels = []

for x in 1:X
    for y in 1:Y
        location = data[x, y]
        neighbour_heights = neighbours(data, x, y, X, Y)
        
        if sum(neighbour_heights .< location) == 0
            println(location, " => ", neighbour_heights)
            push!(risk_levels, location + 1)
        end
    end
end

sum_risk_levels = sum(risk_levels)
println("Part 1: What is the sum of the risk levels of all low points on your heightmap?")
println(sum_risk_levels)